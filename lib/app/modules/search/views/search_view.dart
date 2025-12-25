import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_text_field.dart';

/// Search View
class SearchView extends GetView<SearchViewController> {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Search'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            RasoiSearchField(
              hint: AppStrings.searchHint,
              autofocus: true,
              onChanged: controller.search,
              onClear: controller.clearSearch,
            ),
            const SizedBox(height: 24),

            // Recent Searches or Results
            Expanded(
              child: Obx(() {
                if (controller.query.value.isEmpty) {
                  return _buildRecentSearches();
                }
                return _buildSearchResults();
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.recentSearches,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text('No recent searches', style: TextStyle(color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildSearchResults() {
    return const Center(
      child: Text(
        'Search functionality coming soon...',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}
