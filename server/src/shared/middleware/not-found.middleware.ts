import type { NextFunction, Request, Response } from 'express';

import { NotFoundError } from '../errors';

export const notFoundHandler = (
  request: Request,
  _response: Response,
  next: NextFunction,
): void => {
  next(
    new NotFoundError(
      `Route ${request.method} ${request.originalUrl} was not found.`,
    ),
  );
};
