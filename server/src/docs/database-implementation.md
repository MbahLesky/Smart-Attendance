# Smart Attendance Backend Database Implementation

## Architecture Overview

This backend is organized around a modular layered architecture:

- `config/` owns validated environment configuration.
- `db/` owns Drizzle schema definitions, relations, migrations, and the database client.
- `modules/` owns business features such as organizations, departments, profiles, sessions, and attendance.
- `shared/` owns cross-cutting concerns like error handling, validation middleware, request helpers, and domain constants.

The database is the final source of truth for tenant boundaries, uniqueness, foreign keys, and duplicate-prevention constraints. The service layer adds business checks before writes, but production safety still relies on the database constraints.

## Ownership Model: Supabase Auth vs Profiles

This project deliberately separates authentication identity from application data.

- `auth.users` in Supabase is external and handles authentication only.
- `profiles` is the application user table and the source of truth for business identity.
- `profiles.auth_user_id` stores the Supabase auth user ID.
- `profiles.id` is the app-level profile ID that the rest of the platform must use.
- `sessions.created_by` references `profiles.id`, not `auth.users.id`.
- `session_participants.user_id` references `profiles.id`.
- `attendance_records.user_id` references `profiles.id`.

Why there is no direct FK to `auth.users`:

- `auth.users` is managed outside this Drizzle schema and often lives in a separately managed Supabase schema lifecycle.
- Cross-schema FKs can be practical in some setups, but they are usually a deployment coordination risk when the auth schema is not owned by the same migration pipeline.
- The backend therefore enforces a logical relationship by making `profiles.auth_user_id` unique and required.

Frontend rule:

- Use Supabase Auth only to know who is authenticated.
- Use backend profile lookup to resolve the authenticated user into a `profiles.id`.
- After that, use `profiles.id` for all app-level references.

## Table-by-Table Explanation

### `organizations`

- Represents the tenant or institution.
- One organization owns departments, profiles, and sessions.
- Email is unique.
- Status is modeled as an enum for cleaner filtering and lifecycle control.

### `departments`

- Belongs to one organization.
- `unique(organization_id, name)` prevents duplicate department names inside the same organization.
- The same department name can still exist in different organizations.

### `profiles`

- Stores app-level user data.
- `auth_user_id` maps logically to Supabase Auth.
- `id` is the app-level business identity.
- `role` is constrained to `super_admin`, `organization_admin`, or `attendee`.
- `email` and `auth_user_id` are globally unique.
- `department_id` is optional because some users may exist at org scope without department assignment.

### `sessions`

- Belongs to one organization.
- May optionally target one department.
- `created_by` references `profiles.id`.
- Session timing uses `session_date`, `start_time`, and `end_time`.
- `grace_minutes` supports present-versus-late calculation.
- `attendance_method` supports `qr`, `manual`, and `hybrid`.
- `qr_token` is unique and required.
- `location_required` plus `latitude`, `longitude`, and `radius_meters` support geofencing.

Database checks:

- `end_time > start_time`
- `grace_minutes >= 0`
- when `location_required = true`, latitude/longitude/radius are required

### `session_participants`

- Defines expected attendees for a session.
- `unique(session_id, user_id)` prevents the same user from being assigned twice.
- This table is strongly recommended because it narrows who is allowed to check in.

### `attendance_records`

- Stores one attendance outcome per user per session.
- `unique(session_id, user_id)` is the final production guard against duplicate attendance.
- `status` supports `present`, `late`, `absent`, and `excused`.
- `method` supports `qr` or `manual`.
- `device_info` is JSONB to keep the API flexible across mobile and web clients.

### `attendance_logs`

- Stores the audit trail for attendance changes and attempts.
- References a concrete `attendance_record_id`.
- Supports actions:
  - `checked_in`
  - `marked_manual`
  - `status_changed`
  - `duplicate_attempt_blocked`
  - `location_verified`

## Relationship Summary

- `organizations -> departments` is one-to-many.
- `organizations -> profiles` is one-to-many.
- `organizations -> sessions` is one-to-many.
- `departments -> profiles` is one-to-many.
- `departments -> sessions` is one-to-many.
- `profiles -> sessions` is one-to-many through `sessions.created_by`.
- `sessions -> session_participants` is one-to-many.
- `profiles -> session_participants` is one-to-many.
- `sessions -> attendance_records` is one-to-many.
- `profiles -> attendance_records` is one-to-many.
- `attendance_records -> attendance_logs` is one-to-many.

## Enum Summary

- `organization_status`: `active`, `inactive`, `suspended`
- `profile_role`: `super_admin`, `organization_admin`, `attendee`
- `profile_status`: `invited`, `active`, `inactive`, `suspended`
- `attendance_method`: `qr`, `manual`, `hybrid`
- `session_status`: `draft`, `active`, `closed`, `cancelled`
- `attendance_record_status`: `present`, `late`, `absent`, `excused`
- `attendance_entry_method`: `qr`, `manual`
- `attendance_log_action`: `checked_in`, `marked_manual`, `status_changed`, `duplicate_attempt_blocked`, `location_verified`

## Duplicate Attendance Prevention

Duplicate prevention is intentionally layered:

1. The service layer checks for an existing record before insert.
2. The insert runs inside a transaction with attendance logs.
3. The database unique constraint `attendance_records_session_user_unique` is the final guard.
4. If a concurrent request wins the race, the backend catches the unique violation and returns a conflict response.
5. A `duplicate_attempt_blocked` log is written against the existing attendance record.

This design prevents both casual double taps and true concurrent race conditions.

## Attendance Business Rules Implemented

### Attendee check-in

- Session must exist.
- Session must be `active`.
- Current UTC date must match `session_date`.
- Current time must be before the session end time.
- Session method must allow QR check-in.
- Submitted QR token must match the session token.
- If `session_participants` exists, the profile must be included.
- If the session targets a department, the profile must belong to that department.
- If geolocation is required, the submitted coordinates must fall within the configured radius.
- Status is computed as:
  - `present` if check-in time is on or before `start_time + grace_minutes`
  - `late` otherwise

### Manual attendance marking

- Only `super_admin` or `organization_admin` may do it.
- Session must allow manual marking (`manual` or `hybrid`).
- Session must be `active` or `closed`.
- The target profile must belong to the same organization.
- If the session targets a department, the target profile must belong to that department.
- If `session_participants` exists, the target profile must be included.
- Duplicate records are blocked with the same unique-constraint strategy.

## UTC and Timestamp Notes

- All timestamps are stored as `timestamp with time zone`.
- Session scheduling uses UTC-based interpretation for `session_date` and `start_time`/`end_time`.
- Frontend clients should not assume local browser time when interpreting attendance eligibility.
- If the product later needs organization-specific time zones, add an explicit organization time zone field and perform server-side normalization before persisting sessions.

## Migration Workflow

Commands:

```bash
npm run db:generate
npm run db:migrate
```

Workflow:

1. Update the Drizzle schema files in `src/db/schema/`.
2. Generate a migration with `npm run db:generate`.
3. Review the SQL file in `src/db/migrations/`.
4. Apply it in the target environment with `npm run db:migrate`.
5. Deploy backend code only after the migration is applied or as part of an ordered release.

Production guidance:

- Keep migrations small and reviewable.
- Never edit a migration that has already been applied in shared environments.
- Prefer additive changes first, then backfill, then tighten constraints.
- Use explicit names in migrations so database errors map cleanly back to business meaning.

Naming convention:

- Let Drizzle generate a versioned file.
- Keep the SQL reviewed and committed.
- If you rename generated files, use a semantic prefix like `0001_add_profile_status`.

## API Response Convention

Successful responses:

```json
{
  "success": true,
  "message": "Session created successfully.",
  "data": {}
}
```

Error responses:

```json
{
  "success": false,
  "message": "Attendance has already been recorded for this profile and session.",
  "error": {
    "code": "CONFLICT",
    "details": {}
  }
}
```

## Frontend Integration Notes

Frontend developers should follow this exact identity flow:

1. Authenticate with Supabase Auth.
2. Send the authenticated Supabase user ID to the backend context layer.
3. Resolve that identity to a backend `profiles` row.
4. Store and use `profiles.id` for all app business operations.

Do not do this:

- do not send `auth.users.id` into `sessions.created_by`
- do not send `auth.users.id` into `session_participants.user_id`
- do not send `auth.users.id` into `attendance_records.user_id`

Do this instead:

- use `profiles.id` everywhere the backend expects a user reference
- keep Supabase Auth IDs only for authentication and profile lookup

Recommended frontend queries:

- fetch the current profile after login
- cache `profile.id`, `organization_id`, `department_id`, and `role`
- use `session.id` and `profile.id` as the stable IDs for attendance workflows

## Common Developer Mistakes to Avoid

- Confusing `auth_user_id` with `profiles.id`
- Bypassing service-layer validation and inserting attendance records directly
- Treating `session_participants` as optional forever instead of using it to lock down eligibility
- Assuming the pre-check alone is enough to stop duplicates
- Ignoring UTC when deciding whether a session is open for check-in
- Trusting frontend role checks without backend role checks
- Assuming nullable geolocation fields mean geolocation is unimportant

## Future Considerations

- `deleted_at` soft deletion can be added later if audit or recovery needs grow.
- `updated_at` auto-touch triggers can be added later if the team wants database-managed update timestamps.
- Partial unique indexes for `employee_code` within organization can be added later if employee code becomes mandatory.
- If the team decides to own the Supabase auth schema lifecycle in the same migration pipeline, a future cross-schema FK from `profiles.auth_user_id` to `auth.users.id` can be reconsidered.
