import type { AuthContext } from '../../shared/types/auth';
import { ForbiddenError } from '../../shared/errors';

import { createOrganization } from './organization.repository';
import type { CreateOrganizationInput } from './organization.validation';

export const createOrganizationService = async (
  input: CreateOrganizationInput,
  actor?: AuthContext,
) => {
  if (actor && actor.role !== 'super_admin') {
    throw new ForbiddenError('Only super admins can create organizations.');
  }

  return createOrganization({
    ...input,
    name: input.name.trim(),
    email: input.email.toLowerCase(),
  });
};
