import type { Request, Response } from 'express';

import { sendSuccess } from '../../shared/utils/api-response';
import { asyncHandler } from '../../shared/utils/async-handler';

import { createOrganizationService } from './organization.service';
import type { CreateOrganizationInput } from './organization.validation';

export const createOrganizationController = asyncHandler(
  async (request: Request, response: Response) => {
    const organization = await createOrganizationService(
      request.body as CreateOrganizationInput,
      request.auth,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Organization created successfully.',
      data: organization,
    });
  },
);
