import express from 'express';

import { attendanceRouter } from './modules/attendance/attendance.routes';
import { departmentRouter } from './modules/departments/department.routes';
import { organizationRouter } from './modules/organizations/organization.routes';
import { profileRouter } from './modules/profiles/profile.routes';
import { sessionRouter } from './modules/sessions/session.routes';
import { errorHandler } from './shared/middleware/error-handler.middleware';
import { notFoundHandler } from './shared/middleware/not-found.middleware';
import { sendSuccess } from './shared/utils/api-response';

export const app = express();

app.disable('x-powered-by');
app.use(express.json({ limit: '2mb' }));
app.use(express.urlencoded({ extended: true }));

app.get('/health', (_request, response) =>
  sendSuccess(response, {
    message: 'Smart Attendance backend is healthy.',
    data: {
      status: 'ok',
      timestamp: new Date().toISOString(),
    },
  }),
);

app.use('/api/v1/organizations', organizationRouter);
app.use('/api/v1/departments', departmentRouter);
app.use('/api/v1/profiles', profileRouter);
app.use('/api/v1/sessions', sessionRouter);
app.use('/api/v1/attendance', attendanceRouter);

app.use(notFoundHandler);
app.use(errorHandler);
