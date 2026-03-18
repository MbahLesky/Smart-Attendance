import {
  foreignKey,
  index,
  jsonb,
  numeric,
  pgTable,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

import { attendanceEntryMethodEnum, attendanceRecordStatusEnum } from './enums';
import { profiles } from './profiles';
import { sessions } from './sessions';

export const attendanceRecords = pgTable(
  'attendance_records',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    sessionId: uuid('session_id').notNull(),
    userId: uuid('user_id').notNull(),
    checkInTime: timestamp('check_in_time', { withTimezone: true }).notNull(),
    status: attendanceRecordStatusEnum('status').notNull(),
    method: attendanceEntryMethodEnum('method').notNull(),
    latitude: numeric('latitude', { precision: 9, scale: 6 }),
    longitude: numeric('longitude', { precision: 9, scale: 6 }),
    deviceInfo: jsonb('device_info').$type<Record<string, unknown> | null>(),
    photoUrl: text('photo_url'),
    remarks: text('remarks'),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.sessionId],
      foreignColumns: [sessions.id],
      name: 'attendance_records_session_id_fk',
    }).onDelete('cascade'),
    foreignKey({
      columns: [table.userId],
      foreignColumns: [profiles.id],
      name: 'attendance_records_user_id_fk',
    }).onDelete('cascade'),
    unique('attendance_records_session_user_unique').on(
      table.sessionId,
      table.userId,
    ),
    index('attendance_records_session_id_idx').on(table.sessionId),
    index('attendance_records_user_id_idx').on(table.userId),
    index('attendance_records_status_idx').on(table.status),
  ],
);
