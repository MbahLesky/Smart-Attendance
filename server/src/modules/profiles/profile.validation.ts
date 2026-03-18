import { z } from 'zod';

import { profileRoles, profileStatuses } from '../../shared/constants/domain';

export const createProfileSchema = z.object({
  authUserId: z.uuid(),
  organizationId: z.uuid(),
  departmentId: z.uuid().optional().nullable(),
  firstName: z.string().trim().min(1).max(80),
  lastName: z.string().trim().min(1).max(80),
  email: z.email().transform((value) => value.toLowerCase()),
  phone: z.string().trim().min(7).max(30).optional(),
  role: z.enum(profileRoles),
  employeeCode: z.string().trim().max(60).optional(),
  avatarUrl: z.url().optional(),
  status: z.enum(profileStatuses).optional(),
});

export const updateProfileSchema = z
  .object({
    departmentId: z.uuid().nullable().optional(),
    firstName: z.string().trim().min(1).max(80).optional(),
    lastName: z.string().trim().min(1).max(80).optional(),
    email: z
      .email()
      .transform((value) => value.toLowerCase())
      .optional(),
    phone: z.string().trim().min(7).max(30).optional(),
    role: z.enum(profileRoles).optional(),
    employeeCode: z.string().trim().max(60).optional().nullable(),
    avatarUrl: z.url().optional().nullable(),
    status: z.enum(profileStatuses).optional(),
  })
  .refine((value) => Object.keys(value).length > 0, {
    message: 'At least one field is required for update.',
  });

export type CreateProfileInput = z.infer<typeof createProfileSchema>;
export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
