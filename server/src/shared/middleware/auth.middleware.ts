import type { NextFunction, Request, Response } from 'express';

import type { ProfileRole } from '../constants/domain';
import { ForbiddenError, UnauthorizedError } from '../errors';

export const requireAuthenticatedProfile = (
  request: Request,
  _response: Response,
  next: NextFunction,
): void => {
  if (!request.auth?.profileId || !request.auth.organizationId) {
    next(
      new UnauthorizedError(
        'Authenticated profile context is required. Attach verified Supabase identity to req.auth before these routes run.',
      ),
    );
    return;
  }

  next();
};

export const requireRole =
  (...roles: ProfileRole[]) =>
  (request: Request, _response: Response, next: NextFunction): void => {
    if (!request.auth) {
      next(new UnauthorizedError());
      return;
    }

    if (!roles.includes(request.auth.role)) {
      next(
        new ForbiddenError('Your profile role is not allowed for this action.'),
      );
      return;
    }

    next();
  };
