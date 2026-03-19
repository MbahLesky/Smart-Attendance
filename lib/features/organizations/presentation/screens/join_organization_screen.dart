import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class JoinOrganizationScreen extends ConsumerWidget {
  const JoinOrganizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Organization'),
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
              'Enter Organization Code',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            const Text(
              'Get the unique code from your organization administrator to join.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const Gap(32),
            TextField(
              decoration: InputDecoration(
                hintText: 'e.g. ORG-12345',
                prefixIcon: const Icon(PhosphorIconsRegular.buildings),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate finding organization and moving to departments
                  context.push(AppRouter.joinDepartment);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue'),
              ),
            ),
            const Gap(40),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR', style: TextStyle(color: AppColors.textSecondary)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const Gap(40),
            const Text(
              'Nearby Organizations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Gap(16),
            _buildOrgTile(
              context,
              name: 'University of Technology',
              location: 'Main Campus',
            ),
            const Gap(12),
            _buildOrgTile(
              context,
              name: 'Global Tech Academy',
              location: 'Downtown Branch',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrgTile(BuildContext context, {required String name, required String location}) {
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(PhosphorIconsRegular.buildings, color: AppColors.primary),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Gap(4),
                Text(location, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push(AppRouter.joinDepartment),
            icon: const Icon(PhosphorIconsRegular.caretRight),
          ),
        ],
      ),
    );
  }
}
