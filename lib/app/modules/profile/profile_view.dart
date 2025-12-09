import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../routes/app_pages.dart';
import 'profile_controller.dart';
import '../../core/theme/app_theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.user.value?.displayName ?? 'Profile')),
        actions: [
          if (controller.isOwnProfile)
            IconButton(
              onPressed: () => Get.toNamed(Routes.SETTINGS),
              icon: const Icon(Icons.settings),
            ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());

        final user = controller.user.value;
        if (user == null) return const Center(child: Text("User not found"));

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar
              CircleAvatar(
                radius: 50,
                backgroundImage: (user.photoURL != null && user.photoURL!.isNotEmpty)
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: (user.photoURL == null || user.photoURL!.isEmpty)
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
              const SizedBox(height: 16),

              // Name & Bio
              Text(
                user.displayName ?? 'No Name',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              if (user.bio != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text(
                    user.bio!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

              const SizedBox(height: 16),

              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat("Recipes", controller.userRecipes.length.toString()),
                  const SizedBox(width: 24),
                  _buildStat("Followers", user.followerCount.toString()),
                  const SizedBox(width: 24),
                  _buildStat("Following", user.followingCount.toString()),
                ],
              ),

              const SizedBox(height: 24),

              // Follow / Edit Button
              if (!controller.isOwnProfile)
                ElevatedButton(
                  onPressed: controller.toggleFollow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.isFollowing.value ? Colors.grey : AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                  ),
                  child: Text(
                    controller.isFollowing.value ? "Unfollow" : "Follow",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),

              const SizedBox(height: 24),
              const Divider(),

              // Recipe Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: controller.userRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = controller.userRecipes[index];
                  return GestureDetector(
                    onTap: () => controller.openRecipe(recipe),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(imageUrl: recipe.imageURL, fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
