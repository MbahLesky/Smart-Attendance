import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routing/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRouter.settings),
            icon: const Icon(PhosphorIconsRegular.gear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildProfileCard(context),
            const Gap(32),
            _buildInfoSection(context),
            const Gap(32),
            _buildMenuSection(context),
            const Gap(40),
            _buildLogoutButton(context),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.border,
                child: Icon(PhosphorIconsFill.user, size: 50, color: Colors.white),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(PhosphorIconsFill.pencilSimple, size: 16, color: Colors.white),
            ),
          ],
        ),
        const Gap(16),
        Text(
          'John Doe',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Gap(4),
        Text(
          'john.doe@university.edu',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          _buildInfoRow(context, 'Organization', 'Tech University'),
          const Divider(height: 32),
          _buildInfoRow(context, 'Department', 'Computer Science'),
          const Divider(height: 32),
          _buildInfoRow(context, 'Student ID', 'STU-2024-001'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(
          context,
          icon: PhosphorIconsRegular.bell,
          title: 'Notifications',
          onTap: () => context.push(AppRouter.notifications),
        ),
        const Gap(12),
        _buildMenuItem(
          context,
          icon: PhosphorIconsRegular.shieldCheck,
          title: 'Privacy & Security',
          onTap: () {},
        ),
        const Gap(12),
        _buildMenuItem(
          context,
          icon: PhosphorIconsRegular.question,
          title: 'Help & Support',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const Gap(16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            const Icon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout from your account?'),
            actions: [
              TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
              TextButton(
                onPressed: () => context.go(AppRouter.login),
                child: const Text('Logout', style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.error,
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIconsRegular.signOut),
          Gap(12),
          Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
