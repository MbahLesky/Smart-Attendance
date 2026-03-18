import { and, count, eq, inArray } from 'drizzle-orm';
import type { InferInsertModel, InferSelectModel } from 'drizzle-orm';

import { db } from '../../db';
import type { DatabaseClient } from '../../db/client.types';
import { profiles, sessionParticipants, sessions } from '../../db/schema';

export type Session = InferSelectModel<typeof sessions>;
export type NewSession = InferInsertModel<typeof sessions>;
export type SessionParticipant = InferSelectModel<typeof sessionParticipants>;

export const createSession = async (
  payload: NewSession,
  client: DatabaseClient = db,
): Promise<Session> => {
  const [session] = await client.insert(sessions).values(payload).returning();
  if (!session) {
    throw new Error('Failed to create session.');
  }
  return session;
};

export const getSessionById = async (
  sessionId: string,
  client: DatabaseClient = db,
): Promise<Session | null> => {
  const [session] = await client
    .select()
    .from(sessions)
    .where(eq(sessions.id, sessionId))
    .limit(1);

  return session ?? null;
};

export const addParticipantToSession = async (
  payload: InferInsertModel<typeof sessionParticipants>,
  client: DatabaseClient = db,
): Promise<SessionParticipant> => {
  const [participant] = await client
    .insert(sessionParticipants)
    .values(payload)
    .returning();

  if (!participant) {
    throw new Error('Failed to add session participant.');
  }

  return participant;
};

export const batchAddParticipantsToSession = async (
  sessionId: string,
  userIds: string[],
  client: DatabaseClient = db,
): Promise<SessionParticipant[]> => {
  if (userIds.length === 0) {
    return [];
  }

  return client
    .insert(sessionParticipants)
    .values(userIds.map((userId) => ({ sessionId, userId })))
    .onConflictDoNothing({
      target: [sessionParticipants.sessionId, sessionParticipants.userId],
    })
    .returning();
};

export const countSessionParticipants = async (
  sessionId: string,
  client: DatabaseClient = db,
): Promise<number> => {
  const [result] = await client
    .select({ total: count() })
    .from(sessionParticipants)
    .where(eq(sessionParticipants.sessionId, sessionId));

  return Number(result?.total ?? 0);
};

export const getSessionParticipant = async (
  sessionId: string,
  userId: string,
  client: DatabaseClient = db,
): Promise<SessionParticipant | null> => {
  const [participant] = await client
    .select()
    .from(sessionParticipants)
    .where(
      and(
        eq(sessionParticipants.sessionId, sessionId),
        eq(sessionParticipants.userId, userId),
      ),
    )
    .limit(1);

  return participant ?? null;
};

export const listSessionParticipants = async (
  sessionId: string,
  client: DatabaseClient = db,
) => {
  return client
    .select({
      participantId: sessionParticipants.id,
      sessionId: sessionParticipants.sessionId,
      userId: sessionParticipants.userId,
      createdAt: sessionParticipants.createdAt,
      firstName: profiles.firstName,
      lastName: profiles.lastName,
      email: profiles.email,
      role: profiles.role,
      departmentId: profiles.departmentId,
    })
    .from(sessionParticipants)
    .innerJoin(profiles, eq(sessionParticipants.userId, profiles.id))
    .where(eq(sessionParticipants.sessionId, sessionId));
};

export const listProfilesEligibleForSession = async (
  userIds: string[],
  client: DatabaseClient = db,
) => {
  if (userIds.length === 0) {
    return [];
  }

  return client.select().from(profiles).where(inArray(profiles.id, userIds));
};
