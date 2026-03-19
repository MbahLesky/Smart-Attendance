import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class DepartmentDetailsScreen extends ConsumerWidget {
  final String deptId;
  final String deptName;

  const DepartmentDetailsScreen({
    super.key,
    required this.deptId,
    required this.deptName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(deptName),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _buildSessionStats(),
          const Gap(32),
          const Text(
            'Ongoing & Upcoming Sessions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          _buildSessionTile(
            context,
            title: 'Computer Science 101',
            time: '09:00 AM - 11:00 AM',
            status: 'Ongoing',
            isOngoing: true,
          ),
          const Gap(12),
          _buildSessionTile(
            context,
            title: 'Data Structures',
            time: '01:00 PM - 03:00 PM',
            status: 'Scheduled',
            isOngoing: false,
          ),
          const Gap(32),
          const Text(
            'Recent Check-ins',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          _buildCheckInItem('Yesterday', '09:05 AM', 'Present'),
          _buildCheckInItem('Monday, 12 Oct', '09:15 AM', 'Late'),
          _buildCheckInItem('Friday, 09 Oct', '09:00 AM', 'Present'),
        ],)
      ),
    );
  }

  Widget _buildSessionStats() {
    return Row(
      children: [
        _StatBox(label: 'Total Sessions', value: '45', color: AppColors.primary),
        const Gap(16),
        _StatBox(label: 'Attendance Rate', value: '88%', color: AppColors.success),
      ],
    );
  }

  Widget _buildSessionTile(BuildContext context, {required String title, required String time, required String status, required bool isOngoing}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isOngoing ? AppColors.primary.withOpacity(0.3) : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (isOngoing ? AppColors.primary : AppColors.textSecondary).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isOngoing ? AppColors.primary : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              const Icon(PhosphorIconsRegular.clock, size: 16, color: AppColors.textSecondary),
              const Gap(8),
              Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              const Spacer(),
              if (isOngoing)
                ElevatedButton(
                  onPressed: () => context.push(AppRouter.scanner),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(80, 36),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Text('Check In', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInItem(String date, String time, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const Icon(PhosphorIconsRegular.check, size: 16, color: AppColors.success),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(time, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Text(
            status,
            style: TextStyle(
              color: status == 'Present' ? AppColors.success : AppColors.warning,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const Gap(4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
