import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class JoinDepartmentScreen extends ConsumerWidget {
  const JoinDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Department'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Your Department',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            const Text(
              'University of Technology',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            const Gap(32),
            _buildDepartmentTile(context, name: 'Computer Science', head: 'Dr. Jane Doe'),
            const Gap(12),
            _buildDepartmentTile(context, name: 'Information Systems', head: 'Prof. John Smith'),
            const Gap(12),
            _buildDepartmentTile(context, name: 'Software Engineering', head: 'Dr. Alan Turing'),
            const Gap(12),
            _buildDepartmentTile(context, name: 'Cyber Security', head: 'Prof. Grace Hopper'),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentTile(BuildContext context, {required String name, required String head}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(PhosphorIconsRegular.usersThree, color: AppColors.secondary),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Gap(4),
                Text('HOD: $head', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Request to join $name sent!'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.go(AppRouter.dashboard);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}
