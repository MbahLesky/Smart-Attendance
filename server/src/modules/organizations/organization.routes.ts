import { Router } from 'express';

import {
  requireAuthenticatedProfile,
  requireRole,
} from '../../shared/middleware/auth.middleware';
import { validateRequest } from '../../shared/middleware/validate-request.middleware';

import { createOrganizationController } from './organization.controller';
import { createOrganizationSchema } from './organization.validation';

export const organizationRouter = Router();

organizationRouter.post(
  '/',
  requireAuthenticatedProfile,
  requireRole('super_admin'),
  validateRequest({ body: createOrganizationSchema }),
  createOrganizationController,
);
