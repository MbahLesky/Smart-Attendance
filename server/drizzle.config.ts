import 'dotenv/config';

import { defineConfig } from 'drizzle-kit';

const databaseUrl =
  process.env.DATABASE_URL ??
  'postgresql://postgres:postgres@localhost:5432/smart_attendance';

export default defineConfig({
  dialect: 'postgresql',
  schema: './src/db/schema/index.ts',
  out: './src/db/migrations',
  dbCredentials: {
    url: databaseUrl,
  },
  verbose: true,
  strict: true,
});
