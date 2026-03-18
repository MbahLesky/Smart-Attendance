import { env } from '../config/env';
import { migrate } from 'drizzle-orm/postgres-js/migrator';

import { db, sql } from './index';

const logConnectionGuidance = (error: unknown): void => {
  const databaseUrl = new URL(env.DATABASE_URL);
  const host = databaseUrl.hostname;
  const port = databaseUrl.port || '5432';
  const cause =
    error && typeof error === 'object' && 'cause' in error
      ? error.cause
      : undefined;
  const errorCode =
    cause && typeof cause === 'object' && 'code' in cause
      ? cause.code
      : undefined;

  if (errorCode !== 'CONNECT_TIMEOUT') {
    return;
  }

  const isSupabaseHost =
    host.endsWith('supabase.co') || host.endsWith('pooler.supabase.com');

  if (!isSupabaseHost) {
    console.error(
      `Database connection timed out while connecting to ${host}:${port}. Verify network reachability, host, port, and firewall rules.`,
    );
    return;
  }

  console.error(
    [
      `Database connection to Supabase timed out at ${host}:${port}.`,
      'Common causes:',
      '1. DATABASE_URL is using the project https URL instead of a Postgres connection string.',
      '2. You are using the direct database host on an IPv4-only network.',
      '3. Your current network or firewall is blocking outbound Postgres traffic.',
      'Recommended fix for this Express backend:',
      '- Open Supabase Dashboard -> Connect.',
      '- Copy the Session pooler connection string for persistent backend traffic.',
      '- It should look like: postgres://postgres.<project-ref>:[password]@aws-0-<region>.pooler.supabase.com:5432/postgres',
      '- If you intentionally use Transaction pooler on port 6543, this backend now disables prepared statements automatically.',
    ].join('\n'),
  );
};

const run = async (): Promise<void> => {
  try {
    await migrate(db, {
      migrationsFolder: './src/db/migrations',
    });
  } catch (error) {
    logConnectionGuidance(error);
    throw error;
  } finally {
    await sql.end();
  }
};

void run();
