import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class OrganizationsListScreen extends ConsumerWidget {
  const OrganizationsListScreen({super.key});

  Future<void> _launchAdminUrl() async {
    final Uri url = Uri.parse('https://smart-attendance-admin.vercel.app/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Organizations'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push(AppRouter.joinOrganization),
                  icon: const Icon(PhosphorIconsRegular.plus, size: 20, color: Colors.white,),
                  label: const Text('Join', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(0, 56),
                  ),
                ),
              ),
              const Gap(16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _launchAdminUrl,
                  icon: const Icon(PhosphorIconsRegular.plus, size: 20),
                  label: const Text('Create'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),
          const Gap(32),
          const Text(
            'Joined Organizations',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Gap(16),
          _buildOrgCard(
            context,
            id: 'ORG-GDG',
            name: 'GDG Bamenda',
            departments: 4,
            logo: PhosphorIconsFill.googleLogo,
            color: Colors.red,
          ),
          const Gap(16),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        context.push(AppRouter.organizationDetails, extra: {'id': id, 'name': name});
      },
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
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary, 
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              PhosphorIconsRegular.caretRight, 
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
