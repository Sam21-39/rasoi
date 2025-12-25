import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../controllers/recipe_detail_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_button.dart';

/// Recipe Detail View
/// Displays full recipe details with ingredients, instructions, and comments
class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        if (controller.recipe.value.isEmpty) {
          return const Center(child: Text('Recipe not found'));
        }

        return _buildContent(context);
      }),
      bottomNavigationBar: Obx(() {
        if (controller.recipe.value.isEmpty) return const SizedBox.shrink();
        return _buildBottomBar();
      }),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(controller.errorMessage.value),
          const SizedBox(height: 16),
          RasoiButton.primary(text: 'Retry', onPressed: controller.loadRecipe),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final recipe = controller.recipe.value;

    return CustomScrollView(
      slivers: [
        // Hero Image with AppBar
        _buildSliverAppBar(recipe),

        // Recipe Info
        SliverToBoxAdapter(child: _buildRecipeInfo(recipe)),

        // Ingredients Section
        SliverToBoxAdapter(child: _buildIngredientsSection(recipe)),

        // Instructions Section
        SliverToBoxAdapter(child: _buildInstructionsSection(recipe)),

        // Comments Section
        SliverToBoxAdapter(child: _buildCommentsSection()),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildSliverAppBar(recipe) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.share, color: Colors.white),
          ),
          onPressed: () => Share.share('Check out this recipe: ${recipe.title}'),
        ),
        Obx(
          () => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                controller.recipe.value.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
            ),
            onPressed: controller.toggleSave,
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            recipe.imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.surface),
                    errorWidget: (_, __, ___) => _buildImagePlaceholder(),
                  )
                : _buildImagePlaceholder(),

            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                ),
              ),
            ),

            // Dietary badge
            Positioned(
              bottom: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${recipe.dietaryIcon} ${recipe.dietaryTypes.isNotEmpty ? recipe.dietaryTypes.first : ""}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.surface,
      child: const Center(child: Icon(Icons.restaurant, size: 64, color: AppColors.textSecondary)),
    );
  }

  Widget _buildRecipeInfo(recipe) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            recipe.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Author
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surface,
                backgroundImage: recipe.authorPhotoUrl.isNotEmpty
                    ? CachedNetworkImageProvider(recipe.authorPhotoUrl)
                    : null,
                child: recipe.authorPhotoUrl.isEmpty ? const Icon(Icons.person, size: 16) : null,
              ),
              const SizedBox(width: 8),
              Text(
                'by ${recipe.authorName}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const Spacer(),
              Text(
                timeago.format(recipe.createdAt),
                style: const TextStyle(color: AppColors.textHint, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats row
          Row(
            children: [
              _buildStatItem(Icons.schedule, recipe.formattedCookingTime),
              const SizedBox(width: 24),
              _buildStatItem(
                Icons.signal_cellular_alt,
                recipe.difficulty,
                color: _getDifficultyColor(recipe.difficulty),
              ),
              const SizedBox(width: 24),
              Obx(
                () => _buildStatItem(Icons.people, '${controller.currentServings.value} servings'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Description
          if (recipe.description.isNotEmpty) ...[
            Text(
              recipe.description,
              style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 16),
          ],

          // Engagement row
          Row(
            children: [
              Obx(
                () => _buildEngagementItem(
                  controller.recipe.value.isLiked ? Icons.favorite : Icons.favorite_border,
                  '${controller.recipe.value.likesCount}',
                  controller.recipe.value.isLiked ? AppColors.error : null,
                  controller.toggleLike,
                ),
              ),
              const SizedBox(width: 24),
              _buildEngagementItem(Icons.comment_outlined, '${recipe.commentsCount}', null, () {}),
              const SizedBox(width: 24),
              _buildEngagementItem(Icons.visibility_outlined, '${recipe.viewsCount}', null, null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color ?? AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEngagementItem(IconData icon, String text, Color? color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color ?? AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(color: color ?? AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsSection(recipe) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with servings adjuster
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.ingredients,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              // Servings adjuster
              Obx(
                () => Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: () =>
                          controller.updateServings(controller.currentServings.value - 1),
                      color: AppColors.primary,
                    ),
                    Text(
                      '${controller.currentServings.value}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () =>
                          controller.updateServings(controller.currentServings.value + 1),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),

          // Ingredients list
          ...recipe.ingredients.map<Widget>((ingredient) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(
                    () => Text(
                      controller.getScaledQuantity(ingredient.quantity),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(ingredient.unit),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingredient.name)),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection(recipe) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.instructions,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Instructions list
          ...recipe.instructions.asMap().entries.map<Widget>((entry) {
            final index = entry.key;
            final instruction = entry.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step number
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Instruction text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(instruction.description, style: const TextStyle(height: 1.5)),
                        if (instruction.hasImage) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: instruction.imageUrl!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppStrings.comments} (${controller.recipe.value.commentsCount})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextButton(onPressed: () => _showCommentSheet(), child: const Text('Add Comment')),
            ],
          ),
          const SizedBox(height: 8),

          Obx(() {
            if (controller.isLoadingComments.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.comments.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No comments yet. Be the first to comment!',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              );
            }

            return Column(
              children: controller.comments
                  .take(3)
                  .map((comment) => _buildCommentItem(comment))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommentItem(comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.surface,
            backgroundImage: comment.userPhotoUrl.isNotEmpty
                ? CachedNetworkImageProvider(comment.userPhotoUrl)
                : null,
            child: comment.userPhotoUrl.isEmpty ? const Icon(Icons.person, size: 18) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comment.userName, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text(
                      timeago.format(comment.createdAt),
                      style: const TextStyle(color: AppColors.textHint, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment.text),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Like button
            Obx(
              () => IconButton(
                onPressed: controller.toggleLike,
                icon: Icon(
                  controller.recipe.value.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: controller.recipe.value.isLiked
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              ),
            ),

            // Save button
            Obx(
              () => IconButton(
                onPressed: controller.toggleSave,
                icon: Icon(
                  controller.recipe.value.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: controller.recipe.value.isSaved
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Start Cooking button
            Expanded(
              child: RasoiButton.primary(
                text: AppStrings.startCooking,
                icon: Icons.restaurant,
                onPressed: () {
                  // TODO: Navigate to cooking mode
                  Get.snackbar('Coming Soon', 'Cooking mode coming soon!');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommentSheet() {
    final textController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your comment...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => RasoiButton.primary(
                text: 'Post Comment',
                isFullWidth: true,
                isLoading: controller.isSubmittingComment.value,
                onPressed: () async {
                  final success = await controller.addComment(textController.text);
                  if (success) {
                    Get.back();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.easy;
      case 'medium':
        return AppColors.medium;
      case 'hard':
        return AppColors.hard;
      default:
        return AppColors.textSecondary;
    }
  }
}
