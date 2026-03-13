import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class AttendanceResultScreen extends StatelessWidget {
  final bool isSuccess;

  const AttendanceResultScreen({
    super.key,
    required this.isSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildStatusIcon(),
              const Gap(32),
              Text(
                isSuccess ? 'Attendance Confirmed!' : 'Check-in Failed',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              Text(
                isSuccess
                    ? 'Your attendance has been successfully recorded for this session.'
                    : 'We could not verify your attendance. Please try scanning the QR code again.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(48),
              if (isSuccess) _buildResultCard(context),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go(AppRouter.dashboard),
                child: Text(isSuccess ? 'Back to Dashboard' : 'Try Again'),
              ),
              const Gap(16),
              if (isSuccess)
                TextButton(
                  onPressed: () => context.push(AppRouter.history),
                  child: const Text('View History'),
                ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: (isSuccess ? AppColors.success : AppColors.error).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isSuccess ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.xCircle,
        color: isSuccess ? AppColors.success : AppColors.error,
        size: 80,
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildResultRow(
            context,
            'Session',
            'Computer Science 101',
            PhosphorIconsRegular.bookOpen,
          ),
          const Divider(height: 32),
          _buildResultRow(
            context,
            'Time',
            DateFormat('hh:mm a').format(DateTime.now()),
            PhosphorIconsRegular.clock,
          ),
          const Divider(height: 32),
          _buildResultRow(
            context,
            'Status',
            'Present',
            PhosphorIconsRegular.info,
            valueColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const Gap(12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor ?? AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}
