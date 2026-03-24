import { assertDepartmentInOrganization } from '../departments/department.service';
import { getOrganizationById } from '../organizations/organization.repository';
import { ForbiddenError, NotFoundError } from '../../shared/errors';
import type { AuthContext } from '../../shared/types/auth';

import {
  createProfile,
  getProfileByAuthUserId,
  getProfileById,
  type ProfileUpdates,
  updateProfile,
} from './profile.repository';
import type {
  CreateProfileInput,
  UpdateProfileInput,
} from './profile.validation';

export const createProfileService = async (
  input: CreateProfileInput,
  actor: AuthContext,
) => {
  if (
    actor.role !== 'super_admin' &&
    actor.organizationId !== input.organizationId
  ) {
    throw new ForbiddenError(
      'Organization admins can only create profiles in their own organization.',
    );
  }

  const organization = await getOrganizationById(input.organizationId);

  if (!organization) {
    throw new NotFoundError('Organization not found.');
  }

  if (input.departmentId) {
    await assertDepartmentInOrganization(
      input.departmentId,
      input.organizationId,
    );
  }

  return createProfile({
    ...input,
    email: input.email.toLowerCase(),
  });
};

export const updateProfileService = async (
  profileId: string,
  input: UpdateProfileInput,
  actor: AuthContext,
) => {
  const existingProfile = await getProfileById(profileId);

  if (!existingProfile) {
    throw new NotFoundError('Profile not found.');
  }

  if (
    actor.role !== 'super_admin' &&
    actor.organizationId !== existingProfile.organizationId
  ) {
    throw new ForbiddenError(
      'Organization admins can only update profiles in their own organization.',
    );
  }

  if (input.departmentId) {
    await assertDepartmentInOrganization(
      input.departmentId,
      existingProfile.organizationId,
    );
  }

  const sanitizedInput = Object.fromEntries(
    Object.entries(input).filter(([, value]) => value !== undefined),
  ) as ProfileUpdates;

  const updatedProfile = await updateProfile(profileId, sanitizedInput);

  if (!updatedProfile) {
    throw new NotFoundError('Profile not found after update.');
  }

  return updatedProfile;
};

export const getProfileByAuthUserIdService = async (authUserId: string) => {
  const profile = await getProfileByAuthUserId(authUserId);

  if (!profile) {
    throw new NotFoundError('Profile not found for the given auth user ID.');
  }

  return profile;
};
