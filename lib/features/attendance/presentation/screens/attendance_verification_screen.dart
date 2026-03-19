import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';
import '../providers/attendance_provider.dart';

class AttendanceVerificationScreen extends ConsumerStatefulWidget {
  final String qrData;
  const AttendanceVerificationScreen({super.key, required this.qrData});

  @override
  ConsumerState<AttendanceVerificationScreen> createState() => _AttendanceVerificationScreenState();
}

class _AttendanceVerificationScreenState extends ConsumerState<AttendanceVerificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(attendanceProvider.notifier).verifyAttendance(widget.qrData);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceProvider);

    // Navigate to result screen when verification is done
    if (!state.isVerifying && (state.isGeoVerified && state.isWifiVerified)) {
      Future.microtask(() {
        context.pushReplacement(AppRouter.result, extra: true);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Verifying Attendance',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Gap(8),
              const Text(
                'Please stay on this screen while we verify your location and network.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const Gap(48),
              _buildVerificationStep(
                title: 'Scanning QR Code',
                subtitle: 'Data successfully captured',
                isCompleted: true,
                isLoading: false,
              ),
              const Gap(24),
              _buildVerificationStep(
                title: 'Geolocation Verification',
                subtitle: state.isGeoVerified ? 'You are within the allowed radius' : 'Checking your current location...',
                isCompleted: state.isGeoVerified,
                isLoading: state.isVerifying && !state.isGeoVerified,
              ),
              const Gap(24),
              _buildVerificationStep(
                title: 'Wi-Fi Network Check',
                subtitle: state.isWifiVerified ? 'Connected to authorized network' : 'Verifying network connection...',
                isCompleted: state.isWifiVerified,
                isLoading: state.isVerifying && state.isGeoVerified && !state.isWifiVerified,
              ),
              const Spacer(),
              if (state.errorMessage != null)
                Text(
                  state.errorMessage!,
                  style: const TextStyle(color: AppColors.error),
                ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(attendanceProvider.notifier).reset();
                    context.pop();
                  },
                  child: const Text('Cancel Verification'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationStep({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLoading,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.success.withOpacity(0.1) : (isLoading ? AppColors.primary.withOpacity(0.1) : AppColors.border.withOpacity(0.5)),
            shape: BoxShape.circle,
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(
                  isCompleted ? PhosphorIconsFill.checkCircle : PhosphorIconsRegular.circle,
                  color: isCompleted ? AppColors.success : AppColors.textSecondary,
                ),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? AppColors.textPrimary : (isLoading ? AppColors.primary : AppColors.textSecondary),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
