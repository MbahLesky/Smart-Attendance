import { Router } from 'express';
import { z } from 'zod';

import {
  requireAuthenticatedProfile,
  requireRole,
} from '../../shared/middleware/auth.middleware';
import { validateRequest } from '../../shared/middleware/validate-request.middleware';

import {
  createProfileController,
  getProfileByAuthUserIdController,
  updateProfileController,
} from './profile.controller';
import { createProfileSchema, updateProfileSchema } from './profile.validation';

const profileParamsSchema = z.object({
  profileId: z.uuid(),
});

const authUserParamsSchema = z.object({
  authUserId: z.uuid(),
});

export const profileRouter = Router();

profileRouter.post(
  '/',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ body: createProfileSchema }),
  createProfileController,
);

profileRouter.patch(
  '/:profileId',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ params: profileParamsSchema, body: updateProfileSchema }),
  updateProfileController,
);

profileRouter.get(
  '/by-auth/:authUserId',
  requireAuthenticatedProfile,
  validateRequest({ params: authUserParamsSchema }),
  getProfileByAuthUserIdController,
);
