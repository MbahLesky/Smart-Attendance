import type { Request, Response } from 'express';

import { sendSuccess } from '../../shared/utils/api-response';
import { asyncHandler } from '../../shared/utils/async-handler';
import { listSessionAttendanceService } from '../attendance/attendance.service';

import {
  assignSessionParticipantsService,
  createSessionService,
  getSessionByIdService,
} from './session.service';
import { listSessionParticipants } from './session.repository';
import type {
  AssignSessionParticipantsInput,
  CreateSessionInput,
} from './session.validation';

export const createSessionController = asyncHandler(
  async (request: Request, response: Response) => {
    const session = await createSessionService(
      request.body as CreateSessionInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Session created successfully.',
      data: session,
    });
  },
);

export const getSessionByIdController = asyncHandler(
  async (request: Request, response: Response) => {
    const { sessionId } = request.params as { sessionId: string };
    const session = await getSessionByIdService(sessionId);

    return sendSuccess(response, {
      message: 'Session retrieved successfully.',
      data: session,
    });
  },
);

export const assignSessionParticipantsController = asyncHandler(
  async (request: Request, response: Response) => {
    const { sessionId } = request.params as { sessionId: string };
    const result = await assignSessionParticipantsService(
      sessionId,
      request.body as AssignSessionParticipantsInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Session participants assigned successfully.',
      data: result,
    });
  },
);

export const listSessionParticipantsController = asyncHandler(
  async (request: Request, response: Response) => {
    const { sessionId } = request.params as { sessionId: string };
    const participants = await listSessionParticipants(sessionId);

    return sendSuccess(response, {
      message: 'Session participants retrieved successfully.',
      data: participants,
    });
  },
);

export const listSessionAttendanceController = asyncHandler(
  async (request: Request, response: Response) => {
    const { sessionId } = request.params as { sessionId: string };
    const attendance = await listSessionAttendanceService(sessionId);

    return sendSuccess(response, {
      message: 'Session attendance retrieved successfully.',
      data: attendance,
    });
  },
);
