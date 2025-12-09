import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../routes/app_pages.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/language_controller.dart';
import '../../core/enums/app_theme_mode.dart';
import '../../core/enums/app_language.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Theme Section
          _buildSectionHeader('theme'.tr),
          Obx(
            () => ListTile(
              leading: Icon(themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode),
              title: Text('theme'.tr),
              subtitle: Text(themeController.themeMode.displayName),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showThemeDialog(context, themeController),
            ),
          ),

          const Divider(height: 32),

          // Language Section
          _buildSectionHeader('language'.tr),
          Obx(
            () => ListTile(
              leading: const Icon(Icons.language),
              title: Text('language'.tr),
              subtitle: Text(languageController.language.displayName),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLanguageDialog(context, languageController),
            ),
          ),

          const Divider(height: 32),

          // Notifications Section
          _buildSectionHeader('notifications'.tr),
          Obx(
            () => SwitchListTile(
              title: Text('enable_notifications'.tr),
              value: controller.pushNotificationsEnabled.value,
              onChanged: controller.togglePushNotifications,
              activeColor: AppColors.primary,
            ),
          ),

          const Divider(height: 32),

          // Premium
          ListTile(
            leading: const Icon(Icons.star, color: AppColors.primary),
            title: Text(
              "Go Premium",
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primary),
            onTap: () => Get.toNamed(Routes.PREMIUM),
          ),

          const Divider(height: 32),

          // Account Section
          _buildSectionHeader('about'.tr),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text('privacy_policy'.tr),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("Help & Support"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Rasoi"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),

          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('logout'.tr),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text("${'version'.tr} 1.0.0", style: const TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('theme'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppThemeMode>(
              title: Text('light_mode'.tr),
              value: AppThemeMode.light,
              groupValue: controller.themeMode,
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: Text('dark_mode'.tr),
              value: AppThemeMode.dark,
              groupValue: controller.themeMode,
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<AppThemeMode>(
              title: Text('system_default'.tr),
              value: AppThemeMode.system,
              groupValue: controller.themeMode,
              onChanged: (value) {
                if (value != null) {
                  controller.setThemeMode(value);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, LanguageController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('language'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<AppLanguage>(
              title: const Text('English'),
              value: AppLanguage.english,
              groupValue: controller.language,
              onChanged: (value) {
                if (value != null) {
                  controller.setLanguage(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<AppLanguage>(
              title: const Text('हिन्दी'),
              value: AppLanguage.hindi,
              groupValue: controller.language,
              onChanged: (value) {
                if (value != null) {
                  controller.setLanguage(value);
                  Get.back();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
