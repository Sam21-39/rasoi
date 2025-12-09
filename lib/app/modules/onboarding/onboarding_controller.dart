import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;

  final List<OnboardingItem> items = [
    OnboardingItem(
      title: "Welcome to Rasoi",
      description: "Discover generic recipes from a community of food lovers.",
      imageAsset: "assets/images/onboarding_1.png", // Placeholder
      icon: Icons.restaurant_menu,
    ),
    OnboardingItem(
      title: "Share Your Creations",
      description: "Post your detailed recipes and get feedback from others.",
      imageAsset: "assets/images/onboarding_2.png",
      icon: Icons.camera_alt,
    ),
    OnboardingItem(
      title: "Become a Chef",
      description: "Climb the ranks and build your culinary profile.",
      imageAsset: "assets/images/onboarding_3.png",
      icon: Icons.star,
    ),
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void next() {
    if (currentPage.value < items.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      finishOnboarding();
    }
  }

  void skip() {
    finishOnboarding();
  }

  void finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    Get.offAllNamed(Routes.LOGIN);
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final String imageAsset;
  final IconData icon;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imageAsset,
    required this.icon,
  });
}
