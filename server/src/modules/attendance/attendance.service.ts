import { db } from '../../db';
import {
  BadRequestError,
  ConflictError,
  ForbiddenError,
  isDatabaseError,
} from '../../shared/errors';
import { buildUtcDateTime, isSameUtcDate } from '../../shared/utils/date-time';
import { calculateDistanceMeters } from '../../shared/utils/geo';
import type { AuthContext } from '../../shared/types/auth';

import {
  ensureProfileEligibleForSession,
  getSessionByIdService,
} from '../sessions/session.service';

import {
  checkExistingAttendanceRecord,
  createAttendanceLog,
  createAttendanceRecord,
  listSessionAttendance,
} from './attendance.repository';
import type {
  CheckInAttendanceInput,
  ManualAttendanceMarkingInput,
} from './attendance.validation';

const isDuplicateAttendanceConflict = (error: unknown): boolean => {
  return (
    isDatabaseError(error) &&
    error.code === '23505' &&
    (error.constraint === 'attendance_records_session_user_unique' ||
      error.constraint_name === 'attendance_records_session_user_unique')
  );
};

const logDuplicateAttempt = async (
  attendanceRecordId: string,
  actorProfileId: string,
  method: 'qr' | 'manual',
  sessionId: string,
) => {
  await createAttendanceLog({
    attendanceRecordId,
    action: 'duplicate_attempt_blocked',
    metadata: {
      attemptedAt: new Date().toISOString(),
      actorProfileId,
      method,
      sessionId,
    },
  });
};

const ensureSessionAllowsQrCheckIn = (
  attendanceMethod: 'qr' | 'manual' | 'hybrid',
) => {
  if (attendanceMethod === 'manual') {
    throw new ForbiddenError(
      'This session only allows manual attendance marking by administrators.',
    );
  }
};

const ensureSessionAllowsManualMarking = (
  attendanceMethod: 'qr' | 'manual' | 'hybrid',
) => {
  if (attendanceMethod === 'qr') {
    throw new ForbiddenError(
      'This session only allows QR-based attendee check-in.',
    );
  }
};

const assertLocationRequirement = (
  session: Awaited<ReturnType<typeof getSessionByIdService>>,
  latitude?: number,
  longitude?: number,
) => {
  if (!session.locationRequired) {
    return null;
  }

  if (latitude === undefined || longitude === undefined) {
    throw new BadRequestError(
      'This session requires a location-based check-in.',
    );
  }

  if (
    session.latitude === null ||
    session.longitude === null ||
    session.radiusMeters === null
  ) {
    throw new BadRequestError(
      'This session is misconfigured for location validation.',
    );
  }

  const distanceMeters = calculateDistanceMeters(
    Number(session.latitude),
    Number(session.longitude),
    latitude,
    longitude,
  );

  if (distanceMeters > session.radiusMeters) {
    throw new ForbiddenError(
      'The check-in attempt is outside the allowed attendance radius.',
    );
  }

  return distanceMeters;
};

const ensureSessionTimeAllowsCheckIn = (
  session: Awaited<ReturnType<typeof getSessionByIdService>>,
  now: Date,
) => {
  if (session.status !== 'active') {
    throw new ForbiddenError(
      'Only active sessions may accept attendee check-in.',
    );
  }

  if (!isSameUtcDate(session.sessionDate, now)) {
    throw new ForbiddenError(
      'Check-in is only allowed on the session date using UTC-based scheduling.',
    );
  }

  const sessionEnd = buildUtcDateTime(session.sessionDate, session.endTime);

  if (now.getTime() > sessionEnd.getTime()) {
    throw new ForbiddenError('This session is already past its end time.');
  }
};

const resolvePresentOrLateStatus = (
  sessionDate: string,
  startTime: string,
  graceMinutes: number,
  checkInTime: Date,
): 'present' | 'late' => {
  const sessionStart = buildUtcDateTime(sessionDate, startTime);
  const graceDeadline = new Date(
    sessionStart.getTime() + graceMinutes * 60 * 1000,
  );

  return checkInTime.getTime() <= graceDeadline.getTime() ? 'present' : 'late';
};

export const checkInAttendanceService = async (
  input: CheckInAttendanceInput,
  actor: AuthContext,
) => {
  const now = new Date();
  const { session, profile } = await ensureProfileEligibleForSession(
    input.sessionId,
    actor.profileId,
  );

  ensureSessionAllowsQrCheckIn(session.attendanceMethod);
  ensureSessionTimeAllowsCheckIn(session, now);

  if (input.qrToken !== session.qrToken) {
    throw new ForbiddenError(
      'The supplied QR token is invalid for this session.',
    );
  }

  if (profile.status !== 'active') {
    throw new ForbiddenError('Only active profiles may check in.');
  }

  const distanceMeters = assertLocationRequirement(
    session,
    input.latitude,
    input.longitude,
  );

  const existingRecord = await checkExistingAttendanceRecord(
    input.sessionId,
    actor.profileId,
  );

  if (existingRecord) {
    await logDuplicateAttempt(
      existingRecord.id,
      actor.profileId,
      input.method,
      input.sessionId,
    );

    throw new ConflictError(
      'Attendance has already been recorded for this profile and session.',
    );
  }

  const attendanceStatus = resolvePresentOrLateStatus(
    session.sessionDate,
    session.startTime,
    session.graceMinutes,
    now,
  );

  try {
    return await db.transaction(async (tx) => {
      const record = await createAttendanceRecord(
        {
          sessionId: input.sessionId,
          userId: actor.profileId,
          checkInTime: now,
          status: attendanceStatus,
          method: 'qr',
          latitude:
            input.latitude !== undefined ? String(input.latitude) : null,
          longitude:
            input.longitude !== undefined ? String(input.longitude) : null,
          deviceInfo: input.deviceInfo ?? null,
          photoUrl: input.photoUrl,
          remarks: input.remarks,
        },
        tx,
      );

      await createAttendanceLog(
        {
          attendanceRecordId: record.id,
          action: 'checked_in',
          metadata: {
            actorProfileId: actor.profileId,
            status: attendanceStatus,
            method: 'qr',
            checkInTime: now.toISOString(),
          },
        },
        tx,
      );

      if (distanceMeters !== null) {
        await createAttendanceLog(
          {
            attendanceRecordId: record.id,
            action: 'location_verified',
            metadata: {
              distanceMeters,
              allowedRadiusMeters: session.radiusMeters,
            },
          },
          tx,
        );
      }

      return record;
    });
  } catch (error) {
    if (isDuplicateAttendanceConflict(error)) {
      const concurrentRecord = await checkExistingAttendanceRecord(
        input.sessionId,
        actor.profileId,
      );

      if (concurrentRecord) {
        await logDuplicateAttempt(
          concurrentRecord.id,
          actor.profileId,
          input.method,
          input.sessionId,
        );
      }

      throw new ConflictError(
        'Attendance was already recorded by a concurrent request.',
      );
    }

    throw error;
  }
};

export const manualAttendanceMarkingService = async (
  input: ManualAttendanceMarkingInput,
  actor: AuthContext,
) => {
  if (actor.role === 'attendee') {
    throw new ForbiddenError('Attendees cannot manually mark attendance.');
  }

  const now = new Date();
  const session = await getSessionByIdService(input.sessionId);
  await ensureProfileEligibleForSession(input.sessionId, input.userId);

  if (
    actor.role !== 'super_admin' &&
    actor.organizationId !== session.organizationId
  ) {
    throw new ForbiddenError(
      'Organization admins can only mark attendance in their own organization.',
    );
  }

  ensureSessionAllowsManualMarking(session.attendanceMethod);

  if (!['active', 'closed'].includes(session.status)) {
    throw new ForbiddenError(
      'Manual attendance can only be marked for active or closed sessions.',
    );
  }

  const existingRecord = await checkExistingAttendanceRecord(
    input.sessionId,
    input.userId,
  );

  if (existingRecord) {
    await logDuplicateAttempt(
      existingRecord.id,
      actor.profileId,
      'manual',
      input.sessionId,
    );

    throw new ConflictError(
      'Attendance has already been recorded for this profile and session.',
    );
  }

  try {
    return await db.transaction(async (tx) => {
      const record = await createAttendanceRecord(
        {
          sessionId: input.sessionId,
          userId: input.userId,
          checkInTime: now,
          status: input.status,
          method: 'manual',
          latitude:
            input.latitude !== undefined ? String(input.latitude) : null,
          longitude:
            input.longitude !== undefined ? String(input.longitude) : null,
          deviceInfo: input.deviceInfo ?? null,
          photoUrl: input.photoUrl,
          remarks: input.remarks,
        },
        tx,
      );

      await createAttendanceLog(
        {
          attendanceRecordId: record.id,
          action: 'marked_manual',
          metadata: {
            actorProfileId: actor.profileId,
            status: input.status,
            markedAt: now.toISOString(),
          },
        },
        tx,
      );

      if (input.status !== 'present') {
        await createAttendanceLog(
          {
            attendanceRecordId: record.id,
            action: 'status_changed',
            metadata: {
              actorProfileId: actor.profileId,
              status: input.status,
            },
          },
          tx,
        );
      }

      return record;
    });
  } catch (error) {
    if (isDuplicateAttendanceConflict(error)) {
      const concurrentRecord = await checkExistingAttendanceRecord(
        input.sessionId,
        input.userId,
      );

      if (concurrentRecord) {
        await logDuplicateAttempt(
          concurrentRecord.id,
          actor.profileId,
          'manual',
          input.sessionId,
        );
      }

      throw new ConflictError(
        'Attendance was already recorded by a concurrent request.',
      );
    }

    throw error;
  }
};

export const listSessionAttendanceService = async (sessionId: string) => {
  return listSessionAttendance(sessionId);
};
