import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_button.dart';

/// Dietary Preference View
/// Onboarding screen for selecting dietary preferences
class DietaryPreferenceView extends GetView<AuthController> {
  const DietaryPreferenceView({super.key});

  @override
  Widget build(BuildContext context) {
    final RxList<String> selectedPreferences = <String>[].obs;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header
              const Text(
                AppStrings.selectDietaryPreference,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                AppStrings.dietaryPreferenceSubtitle,
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),

              // Dietary Options
              Expanded(child: Obx(() => _buildDietaryOptions(selectedPreferences))),

              // Continue Button
              Obx(
                () => RasoiButton.primary(
                  text: AppStrings.getStarted,
                  isLoading: controller.isLoading.value,
                  isFullWidth: true,
                  onPressed: selectedPreferences.isEmpty
                      ? null
                      : () => controller.saveDietaryPreferences(selectedPreferences),
                ),
              ),

              const SizedBox(height: 16),

              // Skip option
              Center(
                child: TextButton(
                  onPressed: () => controller.saveDietaryPreferences([]),
                  child: const Text(
                    AppStrings.skip,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDietaryOptions(RxList<String> selectedPreferences) {
    return ListView.separated(
      itemCount: AppConstants.dietaryTypes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final type = AppConstants.dietaryTypes[index];
        final isSelected = selectedPreferences.contains(type);

        return _DietaryOptionCard(
          type: type,
          isSelected: isSelected,
          onTap: () {
            if (isSelected) {
              selectedPreferences.remove(type);
            } else {
              selectedPreferences.add(type);
            }
          },
        );
      },
    );
  }
}

class _DietaryOptionCard extends StatelessWidget {
  final String type;
  final bool isSelected;
  final VoidCallback onTap;

  const _DietaryOptionCard({required this.type, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getIconColor(type).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(_getTypeEmoji(type), style: const TextStyle(fontSize: 24))),
            ),
            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getTypeDescription(type),
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeEmoji(String type) {
    switch (type) {
      case 'Vegetarian':
        return '🥗';
      case 'Non-Vegetarian':
        return '🍖';
      case 'Vegan':
        return '🌱';
      case 'Eggetarian':
        return '🥚';
      default:
        return '🍽️';
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'Vegetarian':
        return AppColors.vegetarian;
      case 'Non-Vegetarian':
        return AppColors.nonVegetarian;
      case 'Vegan':
        return AppColors.vegan;
      case 'Eggetarian':
        return AppColors.eggetarian;
      default:
        return AppColors.primary;
    }
  }

  String _getTypeDescription(String type) {
    switch (type) {
      case 'Vegetarian':
        return 'Plant-based foods with dairy';
      case 'Non-Vegetarian':
        return 'Includes meat, fish, and poultry';
      case 'Vegan':
        return 'Strictly plant-based foods';
      case 'Eggetarian':
        return 'Vegetarian with eggs';
      default:
        return '';
    }
  }
}
