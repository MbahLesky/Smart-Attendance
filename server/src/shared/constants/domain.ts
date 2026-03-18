export const organizationStatuses = [
  'active',
  'inactive',
  'suspended',
] as const;

export const profileRoles = [
  'super_admin',
  'organization_admin',
  'attendee',
] as const;

export const profileStatuses = [
  'invited',
  'active',
  'inactive',
  'suspended',
] as const;

export const attendanceMethods = ['qr', 'manual', 'hybrid'] as const;

export const sessionStatuses = [
  'draft',
  'active',
  'closed',
  'cancelled',
] as const;

export const attendanceRecordStatuses = [
  'present',
  'late',
  'absent',
  'excused',
] as const;

export const attendanceEntryMethods = ['qr', 'manual'] as const;

export const attendanceLogActions = [
  'checked_in',
  'marked_manual',
  'status_changed',
  'duplicate_attempt_blocked',
  'location_verified',
] as const;

export type OrganizationStatus = (typeof organizationStatuses)[number];
export type ProfileRole = (typeof profileRoles)[number];
export type ProfileStatus = (typeof profileStatuses)[number];
export type AttendanceMethod = (typeof attendanceMethods)[number];
export type SessionStatus = (typeof sessionStatuses)[number];
export type AttendanceRecordStatus = (typeof attendanceRecordStatuses)[number];
export type AttendanceEntryMethod = (typeof attendanceEntryMethods)[number];
export type AttendanceLogAction = (typeof attendanceLogActions)[number];
