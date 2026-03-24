import { z } from 'zod';

export const createDepartmentSchema = z.object({
  organizationId: z.uuid(),
  name: z.string().trim().min(2).max(120),
  description: z.string().trim().max(300).optional(),
});

export type CreateDepartmentInput = z.infer<typeof createDepartmentSchema>;
