import type { Request, Response } from 'express';

import { sendSuccess } from '../../shared/utils/api-response';
import { asyncHandler } from '../../shared/utils/async-handler';

import {
  createProfileService,
  getProfileByAuthUserIdService,
  updateProfileService,
} from './profile.service';
import type {
  CreateProfileInput,
  UpdateProfileInput,
} from './profile.validation';

export const createProfileController = asyncHandler(
  async (request: Request, response: Response) => {
    const profile = await createProfileService(
      request.body as CreateProfileInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Profile created successfully.',
      data: profile,
    });
  },
);

export const updateProfileController = asyncHandler(
  async (request: Request, response: Response) => {
    const { profileId } = request.params as { profileId: string };
    const profile = await updateProfileService(
      profileId,
      request.body as UpdateProfileInput,
      request.auth!,
    );

    return sendSuccess(response, {
      message: 'Profile updated successfully.',
      data: profile,
    });
  },
);

export const getProfileByAuthUserIdController = asyncHandler(
  async (request: Request, response: Response) => {
    const { authUserId } = request.params as { authUserId: string };
    const profile = await getProfileByAuthUserIdService(authUserId);

    return sendSuccess(response, {
      message: 'Profile retrieved successfully.',
      data: profile,
    });
  },
);
