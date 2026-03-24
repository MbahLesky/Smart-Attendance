import { eq } from 'drizzle-orm';
import type { InferInsertModel, InferSelectModel } from 'drizzle-orm';

import { db } from '../../db';
import type { DatabaseClient } from '../../db/client.types';
import { organizations } from '../../db/schema';

export type Organization = InferSelectModel<typeof organizations>;
export type NewOrganization = InferInsertModel<typeof organizations>;

export const createOrganization = async (
  payload: NewOrganization,
  client: DatabaseClient = db,
): Promise<Organization> => {
  const [organization] = await client
    .insert(organizations)
    .values(payload)
    .returning();
  if (!organization) {
    throw new Error('Failed to create organization.');
  }
  return organization;
};

export const getOrganizationById = async (
  organizationId: string,
  client: DatabaseClient = db,
): Promise<Organization | null> => {
  const [organization] = await client
    .select()
    .from(organizations)
    .where(eq(organizations.id, organizationId))
    .limit(1);

  return organization ?? null;
};
