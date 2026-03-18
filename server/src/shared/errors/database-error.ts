import { AppError, BadRequestError, ConflictError } from './app-error';

interface DatabaseErrorShape {
  code?: string;
  constraint_name?: string;
  constraint?: string;
  detail?: string;
  message?: string;
}

const UNIQUE_VIOLATION = '23505';
const FOREIGN_KEY_VIOLATION = '23503';
const CHECK_VIOLATION = '23514';
const NOT_NULL_VIOLATION = '23502';

const conflictConstraintMessages: Record<string, string> = {
  departments_organization_name_unique:
    'A department with this name already exists in the organization.',
  profiles_auth_user_id_unique:
    'This Supabase auth identity is already linked to a profile.',
  profiles_email_unique: 'A profile with this email already exists.',
  sessions_qr_token_unique: 'This QR token is already in use.',
  session_participants_session_user_unique:
    'The profile is already assigned to this session.',
  attendance_records_session_user_unique:
    'Attendance for this user and session already exists.',
};

const constraintOrUndefined = (error: DatabaseErrorShape): string | undefined =>
  error.constraint_name ?? error.constraint;

export const isDatabaseError = (
  error: unknown,
): error is DatabaseErrorShape => {
  if (!error || typeof error !== 'object') {
    return false;
  }

  return 'code' in error || 'constraint' in error || 'constraint_name' in error;
};

export const toAppErrorFromDatabase = (error: DatabaseErrorShape): AppError => {
  const constraint = constraintOrUndefined(error);

  if (error.code === UNIQUE_VIOLATION) {
    return new ConflictError(
      constraint
        ? (conflictConstraintMessages[constraint] ??
            'A unique constraint was violated.')
        : 'A unique constraint was violated.',
      {
        constraint,
        detail: error.detail,
      },
    );
  }

  if (error.code === FOREIGN_KEY_VIOLATION) {
    return new BadRequestError('A referenced record does not exist.', {
      constraint,
      detail: error.detail,
    });
  }

  if (error.code === CHECK_VIOLATION) {
    return new BadRequestError('A database rule rejected this operation.', {
      constraint,
      detail: error.detail,
    });
  }

  if (error.code === NOT_NULL_VIOLATION) {
    return new BadRequestError('A required database field is missing.', {
      constraint,
      detail: error.detail,
    });
  }

  return new AppError(
    error.message ?? 'An unexpected database error occurred.',
    500,
    'DATABASE_ERROR',
  );
};
