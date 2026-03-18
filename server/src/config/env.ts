import { config } from 'dotenv';
import { z } from 'zod';

config();

const isPostgresConnectionString = (value: string): boolean => {
  try {
    const parsed = new URL(value);
    return ['postgres:', 'postgresql:'].includes(parsed.protocol);
  } catch {
    return false;
  }
};

const envSchema = z.object({
  NODE_ENV: z
    .enum(['development', 'test', 'production'])
    .default('development'),
  PORT: z.coerce.number().int().positive().default(4000),
  DATABASE_URL: z
    .string()
    .min(1, 'DATABASE_URL is required')
    .refine(isPostgresConnectionString, {
      message:
        'DATABASE_URL must be a PostgreSQL connection string starting with postgres:// or postgresql://. For Supabase, copy a Postgres connection string from the Connect panel, not the project https URL.',
    }),
  CORS_ORIGIN: z.string().default('*'),
});

export const env = envSchema.parse(process.env);

export type AppEnv = typeof env;
