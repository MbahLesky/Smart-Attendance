import { z } from 'zod';

import {
  attendanceMethods,
  sessionStatuses,
} from '../../shared/constants/domain';

const timePattern = /^([01]\d|2[0-3]):([0-5]\d)(:[0-5]\d)?$/;

export const createSessionSchema = z
  .object({
    organizationId: z.uuid(),
    departmentId: z.uuid().optional().nullable(),
    title: z.string().trim().min(3).max(160),
    description: z.string().trim().max(1000).optional(),
    sessionDate: z.iso.date(),
    startTime: z
      .string()
      .regex(timePattern, 'startTime must use HH:MM or HH:MM:SS'),
    endTime: z
      .string()
      .regex(timePattern, 'endTime must use HH:MM or HH:MM:SS'),
    graceMinutes: z.coerce.number().int().min(0).default(0),
    attendanceMethod: z.enum(attendanceMethods),
    qrToken: z.string().trim().min(10).max(255).optional(),
    locationRequired: z.boolean().default(false),
    latitude: z.coerce.number().min(-90).max(90).optional(),
    longitude: z.coerce.number().min(-180).max(180).optional(),
    radiusMeters: z.coerce.number().int().positive().optional(),
    status: z.enum(sessionStatuses).optional(),
  })
  .superRefine((value, context) => {
    if (
      value.locationRequired &&
      (value.latitude === undefined ||
        value.longitude === undefined ||
        value.radiusMeters === undefined)
    ) {
      context.addIssue({
        code: z.ZodIssueCode.custom,
        path: ['locationRequired'],
        message:
          'latitude, longitude, and radiusMeters are required when locationRequired is true.',
      });
    }
  });

export const addSessionParticipantSchema = z.object({
  userId: z.uuid(),
});

export const assignSessionParticipantsSchema = z.object({
  userIds: z.array(z.uuid()).min(1).max(500),
});

export type CreateSessionInput = z.infer<typeof createSessionSchema>;
export type AddSessionParticipantInput = z.infer<
  typeof addSessionParticipantSchema
>;
export type AssignSessionParticipantsInput = z.infer<
  typeof assignSessionParticipantsSchema
>;
