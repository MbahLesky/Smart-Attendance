import { and, eq, inArray } from 'drizzle-orm';
import type { InferInsertModel, InferSelectModel } from 'drizzle-orm';

import { db } from '../../db';
import type { DatabaseClient } from '../../db/client.types';
import { profiles } from '../../db/schema';

export type Profile = InferSelectModel<typeof profiles>;
export type NewProfile = InferInsertModel<typeof profiles>;
export type ProfileUpdates = Partial<
  Omit<NewProfile, 'id' | 'authUserId' | 'organizationId' | 'createdAt'>
>;

export const createProfile = async (
  payload: NewProfile,
  client: DatabaseClient = db,
): Promise<Profile> => {
  const [profile] = await client.insert(profiles).values(payload).returning();
  if (!profile) {
    throw new Error('Failed to create profile.');
  }
  return profile;
};

export const updateProfile = async (
  profileId: string,
  payload: ProfileUpdates,
  client: DatabaseClient = db,
): Promise<Profile | null> => {
  const [profile] = await client
    .update(profiles)
    .set({
      ...payload,
      updatedAt: new Date(),
    })
    .where(eq(profiles.id, profileId))
    .returning();

  return profile ?? null;
};

export const getProfileById = async (
  profileId: string,
  client: DatabaseClient = db,
): Promise<Profile | null> => {
  const [profile] = await client
    .select()
    .from(profiles)
    .where(eq(profiles.id, profileId))
    .limit(1);

  return profile ?? null;
};

export const getProfileByAuthUserId = async (
  authUserId: string,
  client: DatabaseClient = db,
): Promise<Profile | null> => {
  const [profile] = await client
    .select()
    .from(profiles)
    .where(eq(profiles.authUserId, authUserId))
    .limit(1);

  return profile ?? null;
};

export const getProfileByIdAndOrganizationId = async (
  profileId: string,
  organizationId: string,
  client: DatabaseClient = db,
): Promise<Profile | null> => {
  const [profile] = await client
    .select()
    .from(profiles)
    .where(
      and(
        eq(profiles.id, profileId),
        eq(profiles.organizationId, organizationId),
      ),
    )
    .limit(1);

  return profile ?? null;
};

export const listProfilesByIds = async (
  profileIds: string[],
  client: DatabaseClient = db,
): Promise<Profile[]> => {
  if (profileIds.length === 0) {
    return [];
  }

  return client.select().from(profiles).where(inArray(profiles.id, profileIds));
};
