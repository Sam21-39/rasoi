import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Rasoi Chip Widget
/// A styled chip for categories and filters
class RasoiChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;
  final Color? backgroundColor;
  final IconData? icon;
  final bool showCheckIcon;

  const RasoiChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
    this.backgroundColor,
    this.icon,
    this.showCheckIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveSelectedColor = selectedColor ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? AppColors.surface;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? effectiveSelectedColor.withOpacity(0.15) : effectiveBackgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? effectiveSelectedColor : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? effectiveSelectedColor : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            if (showCheckIcon && isSelected) ...[
              Icon(Icons.check, size: 16, color: effectiveSelectedColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? effectiveSelectedColor : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rasoi Filter Chip Group
/// A horizontal scrollable list of filter chips
class RasoiChipGroup extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final List<String>? selectedItems;
  final ValueChanged<String>? onSelected;
  final bool multiSelect;
  final EdgeInsetsGeometry padding;
  final bool showCheckIcon;

  const RasoiChipGroup({
    super.key,
    required this.items,
    this.selectedItem,
    this.selectedItems,
    this.onSelected,
    this.multiSelect = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.showCheckIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: items.map((item) {
          final isSelected = multiSelect
              ? (selectedItems?.contains(item) ?? false)
              : selectedItem == item;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: RasoiChip(
              label: item,
              isSelected: isSelected,
              showCheckIcon: showCheckIcon && isSelected,
              onTap: () => onSelected?.call(item),
            ),
          );
        }).toList(),
      ),
    );
  }
}
