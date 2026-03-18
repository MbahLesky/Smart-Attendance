import {
  foreignKey,
  index,
  pgTable,
  timestamp,
  unique,
  uuid,
} from 'drizzle-orm/pg-core';

import { profiles } from './profiles';
import { sessions } from './sessions';

export const sessionParticipants = pgTable(
  'session_participants',
  {
    id: uuid('id').defaultRandom().primaryKey(),
    sessionId: uuid('session_id').notNull(),
    userId: uuid('user_id').notNull(),
    createdAt: timestamp('created_at', { withTimezone: true })
      .defaultNow()
      .notNull(),
  },
  (table) => [
    foreignKey({
      columns: [table.sessionId],
      foreignColumns: [sessions.id],
      name: 'session_participants_session_id_fk',
    }).onDelete('cascade'),
    foreignKey({
      columns: [table.userId],
      foreignColumns: [profiles.id],
      name: 'session_participants_user_id_fk',
    }).onDelete('cascade'),
    unique('session_participants_session_user_unique').on(
      table.sessionId,
      table.userId,
    ),
    index('session_participants_session_id_idx').on(table.sessionId),
    index('session_participants_user_id_idx').on(table.userId),
  ],
);
