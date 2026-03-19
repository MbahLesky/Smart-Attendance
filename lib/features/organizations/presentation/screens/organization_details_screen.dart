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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(orgName),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          _buildSectionHeader('Your Departments'),
          const Gap(16),
          _buildDeptCard(
            context,
            name: 'Computer Science',
            code: 'CS-DEPT',
            members: 120,
          ),
          const Gap(12),
          _buildDeptCard(
            context,
            name: 'Software Engineering',
            code: 'SE-DEPT',
            members: 85,
          ),
          const Gap(32),
          _buildSectionHeader('Organization Info'),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Column(
              children: [
                _InfoRow(label: 'Location', value: 'Main Campus, Building A'),
                Divider(height: 32),
                _InfoRow(label: 'Admin', value: 'Dr. Robert Smith'),
                Divider(height: 32),
                _InfoRow(label: 'Contact', value: 'admin@unitech.edu'),
              ],
            ),
          ),
        ],)
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
    return InkWell(
      onTap: () => context.push(AppRouter.departmentDetails, extra: {'name': name, 'id': code}),
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
                  Text(code, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
