import { ForbiddenError, NotFoundError } from '../../shared/errors';
import type { AuthContext } from '../../shared/types/auth';
import { getOrganizationById } from '../organizations/organization.repository';

import {
  createDepartment,
  getDepartmentByIdAndOrganizationId,
} from './department.repository';
import type { CreateDepartmentInput } from './department.validation';

export const createDepartmentService = async (
  input: CreateDepartmentInput,
  actor: AuthContext,
) => {
  if (
    actor.role !== 'super_admin' &&
    actor.organizationId !== input.organizationId
  ) {
    throw new ForbiddenError(
      'Organization admins can only create departments in their own organization.',
    );
  }

  const organization = await getOrganizationById(input.organizationId);

  if (!organization) {
    throw new NotFoundError('Organization not found.');
  }

  return createDepartment({
    organizationId: input.organizationId,
    name: input.name.trim(),
    description: input.description?.trim(),
  });
};

export const assertDepartmentInOrganization = async (
  departmentId: string,
  organizationId: string,
) => {
  const department = await getDepartmentByIdAndOrganizationId(
    departmentId,
    organizationId,
  );

  if (!department) {
    throw new NotFoundError('Department not found in the target organization.');
  }

  return department;
};
