import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../routes/app_routes.dart';

import '../../../../core/widgets/bottom_nav_bar.dart';
import 'home_view.dart';
import '../../search/views/search_view.dart';
import '../../profile/views/saved_view.dart';
import '../../profile/views/profile_view.dart';

/// Main View
/// Container view with bottom navigation
class MainView extends GetView<HomeController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(
        () =>
            RasoiBottomNavBar(currentIndex: controller.currentNavIndex.value, onTap: _handleNavTap),
      ),
    );
  }

  Widget _buildBody() {
    switch (controller.currentNavIndex.value) {
      case 0:
        return const HomeView();
      case 1:
        return const SearchView();
      case 2:
        // Navigate to create recipe (handled in onTap)
        return const HomeView();
      case 3:
        return const SavedView();
      case 4:
        return const ProfileView();
      default:
        return const HomeView();
    }
  }

  void _handleNavTap(int index) {
    if (index == 2) {
      // Create Recipe - Navigate as modal
      Get.toNamed(AppRoutes.createRecipe);
    } else {
      controller.changeNavIndex(index);
    }
  }
}
