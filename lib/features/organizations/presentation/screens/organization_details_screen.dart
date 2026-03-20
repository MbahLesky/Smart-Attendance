import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class OrganizationDetailsScreen extends ConsumerWidget {
  final String orgId;
  final String orgName;

  const OrganizationDetailsScreen({
    super.key,
    required this.orgId,
    required this.orgName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGDG = orgId == 'ORG-GDG';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> departments = isGDG ? [
      {'name': 'DevFest', 'code': 'DF-2026', 'members': 500},
      {'name': 'Google IO', 'code': 'GIO-EXT', 'members': 300},
      {'name': 'Friends of Figma', 'code': 'FOF-BMDA', 'members': 150},
      {'name': 'Women\'s Tech Maker', 'code': 'WTM-BMDA', 'members': 200},
    ] : [
      {'name': 'Computer Science', 'code': 'CS-DEPT', 'members': 120},
      {'name': 'Software Engineering', 'code': 'SE-DEPT', 'members': 85},
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(orgName),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Your Departments'),
            const Gap(16),
            ...departments.map((dept) => Column(
              children: [
                _buildDeptCard(
                  context,
                  name: dept['name'],
                  code: dept['code'],
                  members: dept['members'],
                ),
                const Gap(12),
              ],
            )),
            const Gap(20),
            _buildSectionHeader('Organization Info'),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: (isDark ? AppColors.borderDark : AppColors.border).withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Location', value: isGDG ? 'Bamenda, North West' : 'Main Campus, Building A'),
                  const Divider(height: 32),
                  _InfoRow(label: 'Admin', value: isGDG ? 'GDG Organizers' : 'Dr. Robert Smith'),
                  const Divider(height: 32),
                  _InfoRow(label: 'Contact', value: isGDG ? 'hello@gdgbamenda.org' : 'admin@unitech.edu'),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDeptCard(BuildContext context, {required String name, required String code, required int members}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => context.push(AppRouter.departmentDetails, extra: {'name': name, 'id': code}),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: (isDark ? AppColors.borderDark : AppColors.border).withOpacity(0.5)),
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
                  Text('$code • $members members', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
