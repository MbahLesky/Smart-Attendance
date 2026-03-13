import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _locationTracking = true;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            _buildSectionHeader('General'),
            _buildSettingSwitch(
              'Push Notifications',
              'Receive alerts for upcoming sessions',
              _notificationsEnabled,
              (value) => setState(() => _notificationsEnabled = value),
              PhosphorIconsRegular.bell,
            ),
            const Gap(16),
            _buildSettingTile(
              'Language',
              _selectedLanguage,
              () => _showLanguageSelector(),
              PhosphorIconsRegular.globe,
            ),
            const Gap(32),
            _buildSectionHeader('Privacy & Security'),
            _buildSettingSwitch(
              'Biometric Authentication',
              'Use fingerprint or face ID to log in',
              _biometricEnabled,
              (value) => setState(() => _biometricEnabled = value),
              PhosphorIconsRegular.fingerprint,
            ),
            const Gap(16),
            _buildSettingSwitch(
              'Location Services',
              'Required for geolocation check-ins',
              _locationTracking,
              (value) => setState(() => _locationTracking = value),
              PhosphorIconsRegular.mapPin,
            ),
            const Gap(16),
            _buildSettingTile(
              'Change Password',
              'Update your account password',
              () {},
              PhosphorIconsRegular.lock,
            ),
            const Gap(32),
            _buildSectionHeader('About'),
            _buildSettingTile(
              'Terms of Service',
              null,
              () {},
              PhosphorIconsRegular.fileText,
            ),
            const Gap(16),
            _buildSettingTile(
              'Privacy Policy',
              null,
              () {},
              PhosphorIconsRegular.shieldCheck,
            ),
            const Gap(16),
            Center(
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingSwitch(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    return Container(
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Gap(2),
                Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String? value,
    VoidCallback onTap,
    IconData icon,
  ) {
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
            if (value != null)
              Text(
                value,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            const Gap(8),
            const Icon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Language', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Gap(16),
            _buildLanguageOption('English'),
            _buildLanguageOption('French'),
            _buildLanguageOption('Spanish'),
            const Gap(24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = _selectedLanguage == language;
    return ListTile(
      onTap: () {
        setState(() => _selectedLanguage = language);
        context.pop();
      },
      title: Text(language, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      trailing: isSelected ? const Icon(PhosphorIconsFill.checkCircle, color: AppColors.primary) : null,
      contentPadding: EdgeInsets.zero,
    );
  }
}
