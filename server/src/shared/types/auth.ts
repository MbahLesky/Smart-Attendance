import type { ProfileRole } from '../constants/domain';

export interface AuthContext {
  authUserId: string;
  profileId: string;
  organizationId: string;
  role: ProfileRole;
}
