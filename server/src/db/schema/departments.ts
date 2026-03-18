import {
  foreignKey,
  index,
  pgTable,
  text,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

import { organizations } from './organizations';

export const departments = pgTable(
  'departments',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    organizationId: uuid('organization_id').notNull(),
    name: text('name').notNull(),
    description: text('description'),
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
      name: 'departments_organization_id_fk',
    }).onDelete('cascade'),
    unique('departments_organization_name_unique').on(
      table.organizationId,
      table.name,
    ),
    index('departments_organization_id_idx').on(table.organizationId),
  ],
);
