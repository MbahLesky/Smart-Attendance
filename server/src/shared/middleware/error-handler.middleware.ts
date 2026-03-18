import type { NextFunction, Request, Response } from 'express';
import { ZodError } from 'zod';

import { AppError, isDatabaseError, toAppErrorFromDatabase } from '../errors';
import type { ApiErrorResponse } from '../types/api';

export const errorHandler = (
  error: unknown,
  _request: Request,
  response: Response<ApiErrorResponse>,
  _next: NextFunction,
): Response<ApiErrorResponse> => {
  void _next;

  if (error instanceof ZodError) {
    return response.status(400).json({
      success: false,
      message: 'Request validation failed.',
      error: {
        code: 'VALIDATION_ERROR',
        details: error.flatten(),
      },
    });
  }

  if (isDatabaseError(error)) {
    const mappedError = toAppErrorFromDatabase(error);

    return response.status(mappedError.statusCode).json({
      success: false,
      message: mappedError.message,
      error: {
        code: mappedError.code,
        details: mappedError.details,
      },
    });
  }

  if (error instanceof AppError) {
    return response.status(error.statusCode).json({
      success: false,
      message: error.message,
      error: {
        code: error.code,
        details: error.details,
      },
    });
  }

  return response.status(500).json({
    success: false,
    message: 'An unexpected internal server error occurred.',
    error: {
      code: 'INTERNAL_SERVER_ERROR',
    },
  });
};
