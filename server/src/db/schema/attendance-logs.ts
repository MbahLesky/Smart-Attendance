import {
  foreignKey,
  index,
  jsonb,
  pgTable,
  timestamp,
  uuid,
} from 'drizzle-orm/pg-core';

import { attendanceLogActionEnum } from './enums';
import { attendanceRecords } from './attendance-records';

export const attendanceLogs = pgTable(
  'attendance_logs',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    attendanceRecordId: uuid('attendance_record_id').notNull(),
    action: attendanceLogActionEnum('action').notNull(),
    metadata: jsonb('metadata').$type<Record<string, unknown> | null>(),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.attendanceRecordId],
      foreignColumns: [attendanceRecords.id],
      name: 'attendance_logs_attendance_record_id_fk',
    }).onDelete('cascade'),
    index('attendance_logs_attendance_record_id_idx').on(
      table.attendanceRecordId,
    ),
    index('attendance_logs_action_idx').on(table.action),
  ],
);
