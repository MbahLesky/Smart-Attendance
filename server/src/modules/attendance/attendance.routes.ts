import { Router } from 'express';

import {
  requireAuthenticatedProfile,
  requireRole,
} from '../../shared/middleware/auth.middleware';
import { validateRequest } from '../../shared/middleware/validate-request.middleware';

import {
  checkInAttendanceController,
  manualAttendanceMarkingController,
} from './attendance.controller';
import {
  checkInAttendanceSchema,
  manualAttendanceMarkingSchema,
} from './attendance.validation';

export const attendanceRouter = Router();

attendanceRouter.post(
  '/check-in',
  requireAuthenticatedProfile,
  validateRequest({ body: checkInAttendanceSchema }),
  checkInAttendanceController,
);

attendanceRouter.post(
  '/manual',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ body: manualAttendanceMarkingSchema }),
  manualAttendanceMarkingController,
);
