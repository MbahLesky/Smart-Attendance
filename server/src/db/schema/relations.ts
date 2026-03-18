import { relations } from 'drizzle-orm';

import { attendanceLogs } from './attendance-logs';
import { attendanceRecords } from './attendance-records';
import { departments } from './departments';
import { organizations } from './organizations';
import { profiles } from './profiles';
import { sessionParticipants } from './session-participants';
import { sessions } from './sessions';

export const organizationsRelations = relations(organizations, ({ many }) => ({
  departments: many(departments),
  profiles: many(profiles),
  sessions: many(sessions),
}));

export const departmentsRelations = relations(departments, ({ one, many }) => ({
  organization: one(organizations, {
    fields: [departments.organizationId],
    references: [organizations.id],
  }),
  profiles: many(profiles),
  sessions: many(sessions),
}));

export const profilesRelations = relations(profiles, ({ one, many }) => ({
  organization: one(organizations, {
    fields: [profiles.organizationId],
    references: [organizations.id],
  }),
  department: one(departments, {
    fields: [profiles.departmentId],
    references: [departments.id],
  }),
  createdSessions: many(sessions),
  sessionParticipants: many(sessionParticipants),
  attendanceRecords: many(attendanceRecords),
}));

export const sessionsRelations = relations(sessions, ({ one, many }) => ({
  organization: one(organizations, {
    fields: [sessions.organizationId],
    references: [organizations.id],
  }),
  department: one(departments, {
    fields: [sessions.departmentId],
    references: [departments.id],
  }),
  creator: one(profiles, {
    fields: [sessions.createdBy],
    references: [profiles.id],
  }),
  participants: many(sessionParticipants),
  attendanceRecords: many(attendanceRecords),
}));

export const sessionParticipantsRelations = relations(
  sessionParticipants,
  ({ one }) => ({
    session: one(sessions, {
      fields: [sessionParticipants.sessionId],
      references: [sessions.id],
    }),
    profile: one(profiles, {
      fields: [sessionParticipants.userId],
      references: [profiles.id],
    }),
  }),
);

export const attendanceRecordsRelations = relations(
  attendanceRecords,
  ({ one, many }) => ({
    session: one(sessions, {
      fields: [attendanceRecords.sessionId],
      references: [sessions.id],
    }),
    profile: one(profiles, {
      fields: [attendanceRecords.userId],
      references: [profiles.id],
    }),
    logs: many(attendanceLogs),
  }),
);

export const attendanceLogsRelations = relations(attendanceLogs, ({ one }) => ({
  attendanceRecord: one(attendanceRecords, {
    fields: [attendanceLogs.attendanceRecordId],
    references: [attendanceRecords.id],
  }),
}));
