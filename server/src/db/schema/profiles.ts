import {
  foreignKey,
  index,
  pgTable,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

import { profileRoleEnum, profileStatusEnum } from './enums';
import { departments } from './departments';
import { organizations } from './organizations';

export const profiles = pgTable(
  'profiles',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    authUserId: uuid('auth_user_id').notNull(),
    organizationId: uuid('organization_id').notNull(),
    departmentId: uuid('department_id'),
    firstName: text('first_name').notNull(),
    lastName: text('last_name').notNull(),
    email: text('email').notNull(),
    phone: text('phone'),
    role: profileRoleEnum('role').notNull().default('attendee'),
    employeeCode: text('employee_code'),
    avatarUrl: text('avatar_url'),
    status: profileStatusEnum('status').notNull().default('active'),
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
      name: 'profiles_organization_id_fk',
    }).onDelete('restrict'),
    foreignKey({
      columns: [table.departmentId],
      foreignColumns: [departments.id],
      name: 'profiles_department_id_fk',
    }).onDelete('set null'),
    uniqueIndex('profiles_auth_user_id_unique').on(table.authUserId),
    uniqueIndex('profiles_email_unique').on(table.email),
    index('profiles_organization_id_idx').on(table.organizationId),
    index('profiles_department_id_idx').on(table.departmentId),
    index('profiles_role_idx').on(table.role),
  ],
);
