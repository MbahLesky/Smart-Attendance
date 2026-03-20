import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/attendance/presentation/screens/qr_scanner_screen.dart';
import '../../features/attendance/presentation/screens/attendance_result_screen.dart';
import '../../features/attendance/presentation/screens/attendance_verification_screen.dart';
import '../../features/history/presentation/screens/history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/notifications_screen.dart';
import '../../features/dashboard/presentation/screens/main_screen.dart';
import '../../features/organizations/presentation/screens/join_organization_screen.dart';
import '../../features/organizations/presentation/screens/join_department_screen.dart';
import '../../features/organizations/presentation/screens/organization_details_screen.dart';
import '../../features/organizations/presentation/screens/department_details_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String scanner = '/scanner';
  static const String verification = '/verification';
  static const String result = '/result';
  static const String history = '/history';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String joinOrganization = '/join-organization';
  static const String joinDepartment = '/join-department';
  static const String organizationDetails = '/organization-details';
  static const String departmentDetails = '/department-details';

  static final router = GoRouter(
    initialLocation: dashboard,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: dashboard,
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: scanner,
        builder: (context, state) => const QRScannerScreen(),
      ),
      GoRoute(
        path: verification,
        builder: (context, state) {
          final qrData = state.extra as String? ?? '';
          return AttendanceVerificationScreen(qrData: qrData);
        },
      ),
      GoRoute(
        path: result,
        builder: (context, state) {
          final isSuccess = state.extra as bool? ?? true;
          return AttendanceResultScreen(isSuccess: isSuccess);
        },
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: joinOrganization,
        builder: (context, state) => const JoinOrganizationScreen(),
      ),
      GoRoute(
        path: joinDepartment,
        builder: (context, state) => const JoinDepartmentScreen(),
      ),
      GoRoute(
        path: organizationDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OrganizationDetailsScreen(
            orgId: extra?['id'] ?? 'ORG-001',
            orgName: extra?['name'] ?? 'Organization',
          );
        },
      ),
      GoRoute(
        path: departmentDetails,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return DepartmentDetailsScreen(
            deptId: extra?['id'] ?? 'DEPT-001',
            deptName: extra?['name'] ?? 'Department',
          );
        },
      ),
    ],
  );
}
