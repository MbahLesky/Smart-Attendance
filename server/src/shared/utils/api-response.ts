import type { Response } from 'express';

export const sendSuccess = <T>(
  response: Response,
  {
    statusCode = 200,
    message,
    data,
  }: {
    statusCode?: number;
    message: string;
    data: T;
  },
): Response => {
  return response.status(statusCode).json({
    success: true,
    message,
    data,
  });
};
