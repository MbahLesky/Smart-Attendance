import { and, eq } from 'drizzle-orm';
import type { InferInsertModel, InferSelectModel } from 'drizzle-orm';

import { db } from '../../db';
import type { DatabaseClient } from '../../db/client.types';
import { attendanceLogs, attendanceRecords, profiles } from '../../db/schema';

export type AttendanceRecord = InferSelectModel<typeof attendanceRecords>;
export type NewAttendanceRecord = InferInsertModel<typeof attendanceRecords>;
export type AttendanceLog = InferSelectModel<typeof attendanceLogs>;
export type NewAttendanceLog = InferInsertModel<typeof attendanceLogs>;

export const checkExistingAttendanceRecord = async (
  sessionId: string,
  userId: string,
  client: DatabaseClient = db,
): Promise<AttendanceRecord | null> => {
  const [record] = await client
    .select()
    .from(attendanceRecords)
    .where(
      and(
        eq(attendanceRecords.sessionId, sessionId),
        eq(attendanceRecords.userId, userId),
      ),
    )
    .limit(1);

  return record ?? null;
};

export const createAttendanceRecord = async (
  payload: NewAttendanceRecord,
  client: DatabaseClient = db,
): Promise<AttendanceRecord> => {
  const [record] = await client
    .insert(attendanceRecords)
    .values(payload)
    .returning();

  if (!record) {
    throw new Error('Failed to create attendance record.');
  }

  return record;
};

export const createAttendanceLog = async (
  payload: NewAttendanceLog,
  client: DatabaseClient = db,
): Promise<AttendanceLog> => {
  const [log] = await client.insert(attendanceLogs).values(payload).returning();
  if (!log) {
    throw new Error('Failed to create attendance log.');
  }
  return log;
};

export const listSessionAttendance = async (
  sessionId: string,
  client: DatabaseClient = db,
) => {
  return client
    .select({
      attendanceRecordId: attendanceRecords.id,
      sessionId: attendanceRecords.sessionId,
      userId: attendanceRecords.userId,
      checkInTime: attendanceRecords.checkInTime,
      status: attendanceRecords.status,
      method: attendanceRecords.method,
      latitude: attendanceRecords.latitude,
      longitude: attendanceRecords.longitude,
      deviceInfo: attendanceRecords.deviceInfo,
      photoUrl: attendanceRecords.photoUrl,
      remarks: attendanceRecords.remarks,
      createdAt: attendanceRecords.createdAt,
      updatedAt: attendanceRecords.updatedAt,
      firstName: profiles.firstName,
      lastName: profiles.lastName,
      email: profiles.email,
      role: profiles.role,
    })
    .from(attendanceRecords)
    .innerJoin(profiles, eq(attendanceRecords.userId, profiles.id))
    .where(eq(attendanceRecords.sessionId, sessionId));
};
