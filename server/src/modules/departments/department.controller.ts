import type { Request, Response } from 'express';

import { sendSuccess } from '../../shared/utils/api-response';
import { asyncHandler } from '../../shared/utils/async-handler';

import { createDepartmentService } from './department.service';
import type { CreateDepartmentInput } from './department.validation';

export const createDepartmentController = asyncHandler(
  async (request: Request, response: Response) => {
    const department = await createDepartmentService(
      request.body as CreateDepartmentInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Department created successfully.',
      data: department,
    });
  },
);
