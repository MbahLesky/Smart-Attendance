import { and, eq } from 'drizzle-orm';
import type { InferInsertModel, InferSelectModel } from 'drizzle-orm';

import { db } from '../../db';
import type { DatabaseClient } from '../../db/client.types';
import { departments } from '../../db/schema';

export type Department = InferSelectModel<typeof departments>;
export type NewDepartment = InferInsertModel<typeof departments>;

export const createDepartment = async (
  payload: NewDepartment,
  client: DatabaseClient = db,
): Promise<Department> => {
  const [department] = await client
    .insert(departments)
    .values(payload)
    .returning();
  if (!department) {
    throw new Error('Failed to create department.');
  }
  return department;
};

export const getDepartmentById = async (
  departmentId: string,
  client: DatabaseClient = db,
): Promise<Department | null> => {
  const [department] = await client
    .select()
    .from(departments)
    .where(eq(departments.id, departmentId))
    .limit(1);

  return department ?? null;
};

export const getDepartmentByIdAndOrganizationId = async (
  departmentId: string,
  organizationId: string,
  client: DatabaseClient = db,
): Promise<Department | null> => {
  const [department] = await client
    .select()
    .from(departments)
    .where(
      and(
        eq(departments.id, departmentId),
        eq(departments.organizationId, organizationId),
      ),
    )
    .limit(1);

  return department ?? null;
};
