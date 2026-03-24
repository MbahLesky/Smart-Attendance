import {
  boolean,
  check,
  foreignKey,
  index,
  integer,
  numeric,
  pgTable,
  text,
  time,
  timestamp,
  uniqueIndex,
  uuid,
  date,
} from 'drizzle-orm/pg-core';
import { sql } from 'drizzle-orm';

import { attendanceMethodEnum, sessionStatusEnum } from './enums';
import { departments } from './departments';
import { organizations } from './organizations';
import { profiles } from './profiles';

export const sessions = pgTable(
  'sessions',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    organizationId: uuid('organization_id').notNull(),
    departmentId: uuid('department_id'),
    createdBy: uuid('created_by').notNull(),
    title: text('title').notNull(),
    description: text('description'),
    sessionDate: date('session_date', { mode: 'string' }).notNull(),
    startTime: time('start_time').notNull(),
    endTime: time('end_time').notNull(),
    graceMinutes: integer('grace_minutes').notNull().default(0),
    attendanceMethod: attendanceMethodEnum('attendance_method')
      .notNull()
      .default('qr'),
    qrToken: text('qr_token').notNull(),
    locationRequired: boolean('location_required').notNull().default(false),
    latitude: numeric('latitude', { precision: 9, scale: 6 }),
    longitude: numeric('longitude', { precision: 9, scale: 6 }),
    radiusMeters: integer('radius_meters'),
    status: sessionStatusEnum('status').notNull().default('draft'),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
    updatedAt: timestamp('updated_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.organizationId],
      foreignColumns: [organizations.id],
      name: 'sessions_organization_id_fk',
    }).onDelete('cascade'),
    foreignKey({
      columns: [table.departmentId],
      foreignColumns: [departments.id],
      name: 'sessions_department_id_fk',
    }).onDelete('set null'),
    foreignKey({
      columns: [table.createdBy],
      foreignColumns: [profiles.id],
      name: 'sessions_created_by_fk',
    }).onDelete('restrict'),
    uniqueIndex('sessions_qr_token_unique').on(table.qrToken),
    index('sessions_organization_id_idx').on(table.organizationId),
    index('sessions_department_id_idx').on(table.departmentId),
    index('sessions_created_by_idx').on(table.createdBy),
    index('sessions_status_idx').on(table.status),
    index('sessions_session_date_idx').on(table.sessionDate),
    check(
      'sessions_end_time_after_start_time_check',
      sql`${table.endTime} > ${table.startTime}`,
    ),
    check(
      'sessions_grace_minutes_non_negative_check',
      sql`${table.graceMinutes} >= 0`,
    ),
    check(
      'sessions_location_fields_check',
      sql`(${table.locationRequired} = false) OR (${table.latitude} IS NOT NULL AND ${table.longitude} IS NOT NULL AND ${table.radiusMeters} IS NOT NULL AND ${table.radiusMeters} > 0)`,
    ),
  ],
);
