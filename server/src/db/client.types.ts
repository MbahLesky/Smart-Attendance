import type { ExtractTablesWithRelations } from 'drizzle-orm';
import type { PgTransaction } from 'drizzle-orm/pg-core';
import type { PostgresJsDatabase } from 'drizzle-orm/postgres-js';
import type { PostgresJsQueryResultHKT } from 'drizzle-orm/postgres-js/session';

import type * as schema from './schema';

export type DatabaseSchema = typeof schema;
export type DatabaseRelationalSchema =
  ExtractTablesWithRelations<DatabaseSchema>;

export type TransactionClient = PgTransaction<
  PostgresJsQueryResultHKT,
  DatabaseSchema,
  DatabaseRelationalSchema
>;

export type DatabaseClient =
  | PostgresJsDatabase<DatabaseSchema>
  | TransactionClient;
