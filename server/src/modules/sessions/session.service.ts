import { db } from '../../db';
import {
  BadRequestError,
  ForbiddenError,
  NotFoundError,
} from '../../shared/errors';
import { buildUtcDateTime } from '../../shared/utils/date-time';
import { generateQrToken } from '../../shared/utils/qr-token';
import type { AuthContext } from '../../shared/types/auth';

import { assertDepartmentInOrganization } from '../departments/department.service';
import { getOrganizationById } from '../organizations/organization.repository';
import {
  getProfileById,
  listProfilesByIds,
} from '../profiles/profile.repository';

import {
  batchAddParticipantsToSession,
  countSessionParticipants,
  createSession,
  getSessionById,
  getSessionParticipant,
  listSessionParticipants,
} from './session.repository';
import type {
  AssignSessionParticipantsInput,
  CreateSessionInput,
} from './session.validation';

const assertAdminActorForOrganization = (
  actor: AuthContext,
  organizationId: string,
): void => {
  if (actor.role === 'attendee') {
    throw new ForbiddenError('Attendees cannot manage attendance sessions.');
  }

  if (actor.role !== 'super_admin' && actor.organizationId !== organizationId) {
    throw new ForbiddenError(
      'Organization admins can only manage sessions in their own organization.',
    );
  }
};

export const createSessionService = async (
  input: CreateSessionInput,
  actor: AuthContext,
) => {
  assertAdminActorForOrganization(actor, input.organizationId);

  const [organization, creatorProfile] = await Promise.all([
    getOrganizationById(input.organizationId),
    getProfileById(actor.profileId),
  ]);

  if (!organization) {
    throw new NotFoundError('Organization not found.');
  }

  if (
    !creatorProfile ||
    creatorProfile.organizationId !== input.organizationId
  ) {
    throw new ForbiddenError(
      'The authenticated profile must belong to the target organization to create sessions.',
    );
  }

  if (input.departmentId) {
    await assertDepartmentInOrganization(
      input.departmentId,
      input.organizationId,
    );
  }

  const sessionStart = buildUtcDateTime(input.sessionDate, input.startTime);
  const sessionEnd = buildUtcDateTime(input.sessionDate, input.endTime);

  if (sessionEnd.getTime() <= sessionStart.getTime()) {
    throw new BadRequestError('endTime must be later than startTime.');
  }

  return createSession({
    organizationId: input.organizationId,
    departmentId: input.departmentId ?? null,
    createdBy: actor.profileId,
    title: input.title.trim(),
    description: input.description?.trim(),
    sessionDate: input.sessionDate,
    startTime: input.startTime,
    endTime: input.endTime,
    graceMinutes: input.graceMinutes,
    attendanceMethod: input.attendanceMethod,
    qrToken: input.qrToken ?? generateQrToken(),
    locationRequired: input.locationRequired,
    latitude: input.latitude !== undefined ? String(input.latitude) : null,
    longitude: input.longitude !== undefined ? String(input.longitude) : null,
    radiusMeters: input.radiusMeters ?? null,
    status: input.status ?? 'draft',
  });
};

export const assignSessionParticipantsService = async (
  sessionId: string,
  input: AssignSessionParticipantsInput,
  actor: AuthContext,
) => {
  const session = await getSessionById(sessionId);

  if (!session) {
    throw new NotFoundError('Session not found.');
  }

  assertAdminActorForOrganization(actor, session.organizationId);

  const uniqueUserIds = [...new Set(input.userIds)];

  const [profiles, existingParticipants] = await Promise.all([
    listProfilesByIds(uniqueUserIds),
    listSessionParticipants(sessionId),
  ]);

  if (profiles.length !== uniqueUserIds.length) {
    throw new BadRequestError('One or more profiles do not exist.');
  }

  for (const profile of profiles) {
    if (profile.organizationId !== session.organizationId) {
      throw new BadRequestError(
        'Every participant must belong to the same organization as the session.',
      );
    }

    if (session.departmentId && profile.departmentId !== session.departmentId) {
      throw new BadRequestError(
        'A department-scoped session can only contain profiles from that department.',
      );
    }
  }

  const existingUserIds = new Set(
    existingParticipants.map((item) => item.userId),
  );
  const newUserIds = uniqueUserIds.filter(
    (userId) => !existingUserIds.has(userId),
  );

  const insertedParticipants = await db.transaction(async (tx) => {
    return batchAddParticipantsToSession(sessionId, newUserIds, tx);
  });

  const totalParticipants = await countSessionParticipants(sessionId);

  return {
    sessionId,
    insertedCount: insertedParticipants.length,
    skippedCount: uniqueUserIds.length - insertedParticipants.length,
    totalParticipants,
    insertedParticipants,
  };
};

export const getSessionByIdService = async (sessionId: string) => {
  const session = await getSessionById(sessionId);

  if (!session) {
    throw new NotFoundError('Session not found.');
  }

  return session;
};

export const ensureProfileEligibleForSession = async (
  sessionId: string,
  profileId: string,
) => {
  const session = await getSessionByIdService(sessionId);
  const profile = await getProfileById(profileId);

  if (!profile) {
    throw new NotFoundError('Profile not found.');
  }

  if (profile.organizationId !== session.organizationId) {
    throw new ForbiddenError(
      'Profiles can only attend sessions in their own organization.',
    );
  }

  if (session.departmentId && profile.departmentId !== session.departmentId) {
    throw new ForbiddenError(
      'This session is restricted to a different department.',
    );
  }

  const participantCount = await countSessionParticipants(sessionId);

  if (participantCount > 0) {
    const participant = await getSessionParticipant(sessionId, profileId);

    if (!participant) {
      throw new ForbiddenError(
        'This profile is not listed in the expected session participants.',
      );
    }
  }

  return { session, profile };
};
