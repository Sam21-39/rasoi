import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/data/models/recipe_model.dart';
import '../constants/app_colors.dart';

/// Recipe Card Widget
/// Displays a recipe preview in the feed
class RecipeCard extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback? onTap;
  final VoidCallback? onLikeTap;
  final VoidCallback? onSaveTap;
  final VoidCallback? onLongPress;
  final bool showAuthor;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.onLikeTap,
    this.onSaveTap,
    this.onLongPress,
    this.showAuthor = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            _buildImage(),

            // Recipe Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Recipe details row
                  _buildDetailsRow(),

                  if (showAuthor) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1),
                    const SizedBox(height: 10),

                    // Author and likes row
                    _buildAuthorRow(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Recipe image
          recipe.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: recipe.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildImagePlaceholder(),
                  errorWidget: (context, url, error) => _buildImageError(),
                )
              : _buildImageError(),

          // Dietary type badge
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(recipe.dietaryIcon, style: const TextStyle(fontSize: 12)),
            ),
          ),

          // Save button
          if (onSaveTap != null)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: onSaveTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    recipe.isSaved ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: recipe.isSaved ? AppColors.primary : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(color: Colors.white),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: AppColors.surface,
      child: const Center(child: Icon(Icons.restaurant, size: 40, color: AppColors.textSecondary)),
    );
  }

  Widget _buildDetailsRow() {
    return Row(
      children: [
        // Cooking time
        _buildDetailItem(Icons.schedule, recipe.formattedCookingTime),
        const SizedBox(width: 12),

        // Difficulty
        _buildDetailItem(
          Icons.signal_cellular_alt,
          recipe.difficulty,
          color: _getDifficultyColor(recipe.difficulty),
        ),
        const SizedBox(width: 12),

        // Servings
        _buildDetailItem(Icons.people_outline, '${recipe.servings}'),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: color ?? AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildAuthorRow() {
    return Row(
      children: [
        // Author avatar
        CircleAvatar(
          radius: 12,
          backgroundColor: AppColors.surface,
          backgroundImage: recipe.authorPhotoUrl.isNotEmpty
              ? CachedNetworkImageProvider(recipe.authorPhotoUrl)
              : null,
          child: recipe.authorPhotoUrl.isEmpty
              ? const Icon(Icons.person, size: 14, color: AppColors.textSecondary)
              : null,
        ),
        const SizedBox(width: 8),

        // Author name
        Expanded(
          child: Text(
            recipe.authorName,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Like button
        if (onLikeTap != null)
          GestureDetector(
            onTap: onLikeTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  recipe.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: recipe.isLiked ? AppColors.error : AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  '${recipe.likesCount}',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
      ],
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

/// Recipe Card Shimmer
/// Loading placeholder for recipe cards
class RecipeCardShimmer extends StatelessWidget {
  const RecipeCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: double.infinity, height: 16, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(width: 100, height: 12, color: Colors.white),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(width: 80, height: 12, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
