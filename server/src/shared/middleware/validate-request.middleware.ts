import type { NextFunction, Request, Response } from 'express';
import type { ZodType } from 'zod';

type RequestSchemas = {
  body?: ZodType;
  params?: ZodType;
  query?: ZodType;
};

export const validateRequest =
  (schemas: RequestSchemas) =>
  async (
    request: Request,
    _response: Response,
    next: NextFunction,
  ): Promise<void> => {
    try {
      if (schemas.body) {
        request.body = await schemas.body.parseAsync(request.body);
      }

      if (schemas.params) {
        request.params = (await schemas.params.parseAsync(
          request.params,
        )) as Request['params'];
      }

      if (schemas.query) {
        request.query = (await schemas.query.parseAsync(
          request.query,
        )) as Request['query'];
      }

      next();
    } catch (error) {
      next(error);
    }
  };
