import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';

/// Settings View
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.settings),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSection(
            title: 'Account',
            items: [
              _SettingsItem(
                icon: Icons.person_outline,
                title: AppStrings.editProfile,
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.restaurant_menu,
                title: AppStrings.dietaryPreferences,
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            title: 'Preferences',
            items: [
              _SettingsItem(
                icon: Icons.notifications_outlined,
                title: AppStrings.notifications,
                trailing: Switch(value: true, onChanged: (v) {}, activeColor: AppColors.primary),
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.language_outlined,
                title: AppStrings.language,
                subtitle: 'English',
                onTap: () {},
              ),
            ],
          ),
          _buildSection(
            title: 'Storage',
            items: [
              _SettingsItem(
                icon: Icons.cleaning_services_outlined,
                title: AppStrings.clearCache,
                onTap: () {
                  Get.snackbar(
                    'Success',
                    AppStrings.cacheCleared,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
          _buildSection(
            title: 'About',
            items: [
              _SettingsItem(icon: Icons.info_outline, title: AppStrings.about, onTap: () {}),
              _SettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: AppStrings.privacyPolicy,
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                title: AppStrings.termsConditions,
                onTap: () {},
              ),
              _SettingsItem(icon: Icons.help_outline, title: AppStrings.helpFeedback, onTap: () {}),
            ],
          ),
          const SizedBox(height: 24),
          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text(AppStrings.logout, style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Version
          Center(
            child: Text(
              '${AppStrings.version} 1.0.0',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text(AppStrings.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<AuthController>().signOut();
            },
            child: const Text(AppStrings.logout, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }
}
