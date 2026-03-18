import { Router } from 'express';
import { z } from 'zod';

import {
  requireAuthenticatedProfile,
  requireRole,
} from '../../shared/middleware/auth.middleware';
import { validateRequest } from '../../shared/middleware/validate-request.middleware';

import {
  assignSessionParticipantsController,
  createSessionController,
  getSessionByIdController,
  listSessionAttendanceController,
  listSessionParticipantsController,
} from './session.controller';
import {
  assignSessionParticipantsSchema,
  createSessionSchema,
} from './session.validation';

const sessionParamsSchema = z.object({
  sessionId: z.uuid(),
});

export const sessionRouter = Router();

sessionRouter.post(
  '/',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ body: createSessionSchema }),
  createSessionController,
);

sessionRouter.get(
  '/:sessionId',
  requireAuthenticatedProfile,
  validateRequest({ params: sessionParamsSchema }),
  getSessionByIdController,
);

sessionRouter.post(
  '/:sessionId/participants',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({
    params: sessionParamsSchema,
    body: assignSessionParticipantsSchema,
  }),
  assignSessionParticipantsController,
);

sessionRouter.get(
  '/:sessionId/participants',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ params: sessionParamsSchema }),
  listSessionParticipantsController,
);

sessionRouter.get(
  '/:sessionId/attendance',
  requireAuthenticatedProfile,
  requireRole('super_admin', 'organization_admin'),
  validateRequest({ params: sessionParamsSchema }),
  listSessionAttendanceController,
);
