import { pgEnum } from 'drizzle-orm/pg-core';

import {
  attendanceEntryMethods,
  attendanceLogActions,
  attendanceMethods,
  attendanceRecordStatuses,
  organizationStatuses,
  profileRoles,
  profileStatuses,
  sessionStatuses,
} from '../../shared/constants/domain';

export const organizationStatusEnum = pgEnum(
  'organization_status',
  organizationStatuses,
);

export const profileRoleEnum = pgEnum('profile_role', profileRoles);

export const profileStatusEnum = pgEnum('profile_status', profileStatuses);

export const attendanceMethodEnum = pgEnum(
  'attendance_method',
  attendanceMethods,
);

export const sessionStatusEnum = pgEnum('session_status', sessionStatuses);

export const attendanceRecordStatusEnum = pgEnum(
  'attendance_record_status',
  attendanceRecordStatuses,
);

export const attendanceEntryMethodEnum = pgEnum(
  'attendance_entry_method',
  attendanceEntryMethods,
);

export const attendanceLogActionEnum = pgEnum(
  'attendance_log_action',
  attendanceLogActions,
);
