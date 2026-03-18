import postgres from 'postgres';
import { drizzle } from 'drizzle-orm/postgres-js';

import { env } from '../config/env';
import * as schema from './schema';

const parsedDatabaseUrl = new URL(env.DATABASE_URL);
const databaseHost = parsedDatabaseUrl.hostname;
const databasePort = parsedDatabaseUrl.port || '5432';
const isSupabaseDatabase =
  databaseHost.endsWith('supabase.co') ||
  databaseHost.endsWith('pooler.supabase.com');
const isTransactionPooler = databasePort === '6543';

export const sql = postgres(env.DATABASE_URL, {
  max: env.NODE_ENV === 'production' ? 20 : 10,
  idle_timeout: 20,
  connect_timeout: 15,
  ...(isSupabaseDatabase ? { ssl: 'require' as const } : {}),
  ...(isTransactionPooler ? { prepare: false } : {}),
});

export const db = drizzle(sql, {
  schema,
  casing: 'snake_case',
});
