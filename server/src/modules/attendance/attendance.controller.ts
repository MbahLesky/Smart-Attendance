import type { Request, Response } from 'express';

import { sendSuccess } from '../../shared/utils/api-response';
import { asyncHandler } from '../../shared/utils/async-handler';

import {
  checkInAttendanceService,
  manualAttendanceMarkingService,
} from './attendance.service';
import type {
  CheckInAttendanceInput,
  ManualAttendanceMarkingInput,
} from './attendance.validation';

export const checkInAttendanceController = asyncHandler(
  async (request: Request, response: Response) => {
    const attendanceRecord = await checkInAttendanceService(
      request.body as CheckInAttendanceInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Attendance check-in recorded successfully.',
      data: attendanceRecord,
    });
  },
);

export const manualAttendanceMarkingController = asyncHandler(
  async (request: Request, response: Response) => {
    const attendanceRecord = await manualAttendanceMarkingService(
      request.body as ManualAttendanceMarkingInput,
      request.auth!,
    );

    return sendSuccess(response, {
      statusCode: 201,
      message: 'Manual attendance recorded successfully.',
      data: attendanceRecord,
    });
  },
);
