import { Router } from 'express';

import {
  requireAuthenticatedProfile,
  requireRole,
} from '../../shared/middleware/auth.middleware';
import { validateRequest } from '../../shared/middleware/validate-request.middleware';

import { createDepartmentController } from './department.controller';
import { createDepartmentSchema } from './department.validation';

export const departmentRouter = Router();

departmentRouter.post(
  '/',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ body: createDepartmentSchema }),
  createDepartmentController,
);
