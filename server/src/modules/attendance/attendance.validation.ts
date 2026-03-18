import { z } from 'zod';

import { attendanceRecordStatuses } from '../../shared/constants/domain';

export const checkInAttendanceSchema = z.object({
  sessionId: z.uuid(),
  method: z.literal('qr').default('qr'),
  qrToken: z.string().trim().min(10),
  latitude: z.coerce.number().min(-90).max(90).optional(),
  longitude: z.coerce.number().min(-180).max(180).optional(),
  deviceInfo: z.record(z.string(), z.unknown()).optional(),
  photoUrl: z.url().optional(),
  remarks: z.string().trim().max(1000).optional(),
});

export const manualAttendanceMarkingSchema = z.object({
  sessionId: z.uuid(),
  userId: z.uuid(),
  status: z.enum(attendanceRecordStatuses),
  latitude: z.coerce.number().min(-90).max(90).optional(),
  longitude: z.coerce.number().min(-180).max(180).optional(),
  deviceInfo: z.record(z.string(), z.unknown()).optional(),
  photoUrl: z.url().optional(),
  remarks: z.string().trim().max(1000).optional(),
});

export type CheckInAttendanceInput = z.infer<typeof checkInAttendanceSchema>;
export type ManualAttendanceMarkingInput = z.infer<
  typeof manualAttendanceMarkingSchema
>;
