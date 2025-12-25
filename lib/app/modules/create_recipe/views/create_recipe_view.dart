import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/create_recipe_controller.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/rasoi_button.dart';
import '../../../../core/widgets/rasoi_text_field.dart';
import '../../../../core/widgets/rasoi_chip.dart';

/// Create Recipe View
/// Multi-step form for creating new recipes
class CreateRecipeView extends GetView<CreateRecipeController> {
  const CreateRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditing ? 'Edit Recipe' : AppStrings.createRecipe)),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showExitConfirmation(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.isEditing) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            // Step Indicator
            _buildStepIndicator(),

            // Form Content
            Expanded(child: _buildStepContent()),

            // Navigation Buttons
            _buildNavigationButtons(),
          ],
        );
      }),
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      AppStrings.basicInfo,
      AppStrings.addIngredients,
      AppStrings.addInstructions,
      AppStrings.reviewPublish,
    ];

    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: List.generate(steps.length, (index) {
            final isActive = controller.currentStep.value >= index;
            final isCurrent = controller.currentStep.value == index;

            return Expanded(
              child: GestureDetector(
                onTap: index < controller.currentStep.value
                    ? () => controller.goToStep(index)
                    : null,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : AppColors.surface,
                        shape: BoxShape.circle,
                        border: isCurrent ? Border.all(color: AppColors.primary, width: 2) : null,
                      ),
                      child: Center(
                        child: isActive && !isCurrent
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isActive ? Colors.white : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          color: controller.currentStep.value > index
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return _buildBasicInfoStep();
        case 1:
          return _buildIngredientsStep();
        case 2:
          return _buildInstructionsStep();
        case 3:
          return _buildReviewStep();
        default:
          return const SizedBox.shrink();
      }
    });
  }

  // ============================================
  // Step 1: Basic Info
  // ============================================

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Picker
          _buildImagePicker(),
          const SizedBox(height: 24),

          // Title
          RasoiTextField(
            label: 'Recipe Title *',
            hint: 'e.g., Butter Chicken',
            controller: TextEditingController(text: controller.title.value),
            onChanged: (value) => controller.title.value = value,
            maxLength: 100,
          ),
          const SizedBox(height: 16),

          // Description
          RasoiTextField(
            label: 'Description',
            hint: 'Tell us about your recipe...',
            controller: TextEditingController(text: controller.description.value),
            onChanged: (value) => controller.description.value = value,
            maxLines: 3,
            maxLength: 500,
          ),
          const SizedBox(height: 24),

          // Category
          const Text('Category *', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.categories.map((cat) {
                return RasoiChip(
                  label: cat,
                  isSelected: controller.category.value == cat,
                  onTap: () => controller.category.value = cat,
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Dietary Types
          const Text('Dietary Type', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.dietaryTypes.map((type) {
                final isSelected = controller.dietaryTypes.contains(type);
                return RasoiChip(
                  label: type,
                  isSelected: isSelected,
                  showCheckIcon: isSelected,
                  onTap: () {
                    if (isSelected) {
                      controller.dietaryTypes.remove(type);
                    } else {
                      controller.dietaryTypes.add(type);
                    }
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Cooking Time & Difficulty Row
          Row(
            children: [
              Expanded(child: _buildCookingTimeSelector()),
              const SizedBox(width: 16),
              Expanded(child: _buildDifficultySelector()),
            ],
          ),
          const SizedBox(height: 24),

          // Servings
          _buildServingsSelector(),
        ],
      ),
    );
  }

  Widget _buildImagePicker() {
    return Obx(() {
      final hasImage = controller.mainImage.value != null;

      return GestureDetector(
        onTap: () => _showImagePickerOptions(),
        child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border, style: BorderStyle.solid),
            image: hasImage
                ? DecorationImage(image: FileImage(controller.mainImage.value!), fit: BoxFit.cover)
                : null,
          ),
          child: hasImage
              ? Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        onPressed: () => controller.mainImage.value = null,
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 48, color: AppColors.textSecondary),
                    const SizedBox(height: 8),
                    Text('Add Recipe Photo *', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
        ),
      );
    });
  }

  void _showImagePickerOptions() {
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
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                controller.pickMainImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Get.back();
                controller.takePhoto();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCookingTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cooking Time', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (controller.cookingTime.value > 5) {
                      controller.cookingTime.value -= 5;
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    '${controller.cookingTime.value} min',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    controller.cookingTime.value += 5;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.difficulty.value,
                isExpanded: true,
                items: AppConstants.difficultyLevels.map((level) {
                  return DropdownMenuItem(value: level, child: Text(level));
                }).toList(),
                onChanged: (value) {
                  if (value != null) controller.difficulty.value = value;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildServingsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Servings', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Obx(
          () => Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (controller.servings.value > 1) {
                    controller.servings.value--;
                  }
                },
                color: AppColors.primary,
              ),
              Text(
                '${controller.servings.value}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => controller.servings.value++,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Text('people'),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================
  // Step 2: Ingredients
  // ============================================

  Widget _buildIngredientsStep() {
    return Column(
      children: [
        // Add ingredient button
        Padding(
          padding: const EdgeInsets.all(16),
          child: RasoiButton.secondary(
            text: 'Add Ingredient',
            icon: Icons.add,
            isFullWidth: true,
            onPressed: () => _showAddIngredientDialog(),
          ),
        ),

        // Ingredients list
        Expanded(
          child: Obx(() {
            if (controller.ingredients.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text(
                      'No ingredients added yet',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.ingredients.length,
              onReorder: controller.reorderIngredients,
              itemBuilder: (context, index) {
                final ingredient = controller.ingredients[index];
                return _buildIngredientTile(ingredient, index);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildIngredientTile(ingredient, int index) {
    return Dismissible(
      key: Key('ingredient_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.removeIngredient(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.drag_handle),
          title: Text(ingredient.name),
          subtitle: Text('${ingredient.quantity} ${ingredient.unit}'),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditIngredientDialog(index, ingredient),
          ),
        ),
      ),
    );
  }

  void _showAddIngredientDialog() {
    final nameController = TextEditingController();
    final quantityController = TextEditingController();
    String selectedUnit = AppConstants.units.first;

    Get.dialog(
      AlertDialog(
        title: const Text('Add Ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Ingredient Name',
                hintText: 'e.g., Onion',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity', hintText: 'e.g., 2'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: const InputDecoration(labelText: 'Unit'),
                        items: AppConstants.units.map((unit) {
                          return DropdownMenuItem(value: unit, child: Text(unit));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => selectedUnit = value);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.addIngredient(nameController.text, quantityController.text, selectedUnit);
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditIngredientDialog(int index, ingredient) {
    final nameController = TextEditingController(text: ingredient.name);
    final quantityController = TextEditingController(text: ingredient.quantity);
    String selectedUnit = ingredient.unit.isEmpty ? AppConstants.units.first : ingredient.unit;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ingredient Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return DropdownButtonFormField<String>(
                        value: selectedUnit,
                        decoration: const InputDecoration(labelText: 'Unit'),
                        items: AppConstants.units.map((unit) {
                          return DropdownMenuItem(value: unit, child: Text(unit));
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => selectedUnit = value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateIngredient(
                index,
                nameController.text,
                quantityController.text,
                selectedUnit,
              );
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Step 3: Instructions
  // ============================================

  Widget _buildInstructionsStep() {
    return Column(
      children: [
        // Add instruction button
        Padding(
          padding: const EdgeInsets.all(16),
          child: RasoiButton.secondary(
            text: 'Add Step',
            icon: Icons.add,
            isFullWidth: true,
            onPressed: () => _showAddInstructionDialog(),
          ),
        ),

        // Instructions list
        Expanded(
          child: Obx(() {
            if (controller.instructions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.format_list_numbered, size: 64, color: AppColors.textSecondary),
                    const SizedBox(height: 16),
                    Text('No steps added yet', style: TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              );
            }

            return ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.instructions.length,
              onReorder: controller.reorderInstructions,
              itemBuilder: (context, index) {
                final instruction = controller.instructions[index];
                return _buildInstructionTile(instruction, index);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildInstructionTile(instruction, int index) {
    return Dismissible(
      key: Key('instruction_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.removeInstruction(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary,
            child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
          ),
          title: Text(instruction.description, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.drag_handle),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditInstructionDialog(index, instruction),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddInstructionDialog() {
    final textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Step ${controller.instructions.length + 1}'),
        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Describe this step...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.addInstruction(textController.text);
              Get.back();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditInstructionDialog(int index, instruction) {
    final textController = TextEditingController(text: instruction.description);

    Get.dialog(
      AlertDialog(
        title: Text('Edit Step ${index + 1}'),
        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              controller.updateInstruction(index, textController.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Step 4: Review
  // ============================================

  Widget _buildReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview Image
            if (controller.mainImage.value != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  controller.mainImage.value!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // Title & Description
            Text(
              controller.title.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (controller.description.value.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(controller.description.value),
            ],
            const SizedBox(height: 16),

            // Details chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(controller.category.value)),
                Chip(label: Text('${controller.cookingTime.value} min')),
                Chip(label: Text(controller.difficulty.value)),
                Chip(label: Text('${controller.servings.value} servings')),
                ...controller.dietaryTypes.map((t) => Chip(label: Text(t))),
              ],
            ),
            const SizedBox(height: 24),

            // Ingredients Summary
            Text(
              '${AppStrings.ingredients} (${controller.ingredients.length})',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...controller.ingredients.map(
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('• ${i.displayText}'),
              ),
            ),
            const SizedBox(height: 24),

            // Instructions Summary
            Text(
              '${AppStrings.instructions} (${controller.instructions.length} steps)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...controller.instructions.asMap().entries.map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text('${e.key + 1}. ${e.value.description}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Navigation
  // ============================================

  Widget _buildNavigationButtons() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              if (controller.currentStep.value > 0)
                Expanded(
                  child: RasoiButton.secondary(text: 'Back', onPressed: controller.previousStep),
                ),
              if (controller.currentStep.value > 0) const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: controller.currentStep.value == 3
                    ? RasoiButton.primary(
                        text: controller.isEditing ? 'Update Recipe' : AppStrings.publishRecipe,
                        isLoading: controller.isLoading.value,
                        onPressed: controller.publishRecipe,
                      )
                    : RasoiButton.primary(text: 'Continue', onPressed: controller.nextStep),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text(
          'Your recipe will be saved as a draft. You can continue editing later.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Keep Editing')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('Save & Exit'),
          ),
        ],
      ),
    );
  }
}
