import { z } from 'zod';

import { organizationStatuses } from '../../shared/constants/domain';

export const createOrganizationSchema = z.object({
  name: z.string().trim().min(2).max(150),
  email: z.email().transform((value) => value.toLowerCase()),
  phone: z.string().trim().min(7).max(30).optional(),
  address: z.string().trim().max(300).optional(),
  logoUrl: z.url().optional(),
  status: z.enum(organizationStatuses).optional(),
});

export type CreateOrganizationInput = z.infer<typeof createOrganizationSchema>;
