import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class OrganizationsListScreen extends ConsumerWidget {
  const OrganizationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Organizations'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.joinOrganization),
            icon: const Icon(PhosphorIconsRegular.plus),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildOrgCard(
            context,
            id: 'ORG-001',
            name: 'University of Technology',
            departments: 2,
            logo: PhosphorIconsFill.graduationCap,
            color: Colors.blue,
          ),
          const Gap(16),
          _buildOrgCard(
            context,
            id: 'ORG-002',
            name: 'Global Tech Solutions',
            departments: 1,
            logo: PhosphorIconsFill.briefcase,
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildOrgCard(
    BuildContext context, {
    required String id,
    required String name,
    required int departments,
    required IconData logo,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        context.push(AppRouter.organizationDetails, extra: {'id': id, 'name': name});
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(logo, color: color, size: 32),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Gap(4),
                  Text(
                    '$departments Departments joined',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const Icon(PhosphorIconsRegular.caretRight, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
