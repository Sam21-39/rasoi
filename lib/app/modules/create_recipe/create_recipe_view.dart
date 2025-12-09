import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'package:get/get.dart';
import 'create_recipe_controller.dart';

class CreateRecipeView extends GetView<CreateRecipeController> {
  const CreateRecipeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Recipe', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      image: controller.imageFile.value != null
                          ? DecorationImage(
                              image: FileImage(controller.imageFile.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.imageFile.value == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                              SizedBox(height: 8),
                              Text("Add Recipe Photo", style: TextStyle(color: Colors.grey)),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 24),

                // Title
                TextFormField(
                  controller: controller.titleController,
                  decoration: const InputDecoration(
                    labelText: 'Recipe Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Title is required' : null,
                ),
                const SizedBox(height: 16),

                // Category & Difficulty Row
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: controller.selectedCategory.value,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: controller.categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c.capitalizeFirst!)))
                            .toList(),
                        onChanged: (v) => controller.selectedCategory.value = v!,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: controller.selectedDifficulty.value,
                        decoration: const InputDecoration(
                          labelText: 'Difficulty',
                          border: OutlineInputBorder(),
                        ),
                        items: controller.difficulties
                            .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                // Category
                DropdownButtonFormField<String>(
                  initialValue: controller.selectedCategory.value,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c.capitalizeFirst!)))
                      .toList(),
                  onChanged: (v) => controller.selectedCategory.value = v!,
                ),
                const SizedBox(height: 16),
                // Difficulty & Cook Time Row
                Row(
                  children: [
                    Flexible(
                      child: Obx(
                        () => OutlinedButton(
                          onPressed: () => _showDifficultyPicker(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 48),
                          ),
                          child: Text(
                            controller.selectedDifficulty.value,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: controller.cookTimeController,
                        decoration: const InputDecoration(
                          labelText: 'Cook Time (e.g., 30m)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v!.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Servings
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Servings:"),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (controller.servings.value > 1) controller.servings.value--;
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                                Text(
                                  "${controller.servings.value}",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () => controller.servings.value++,
                                  icon: const Icon(Icons.add_circle_outline),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Ingredients
                _buildDynamicList(
                  title: 'Ingredients',
                  items: controller.ingredients,
                  onAdd: (text) => controller.addIngredient(text),
                  onRemove: (index) => controller.removeIngredient(index),
                  hint: 'Add an ingredient',
                ),
                const SizedBox(height: 24),

                // Instructions
                _buildDynamicList(
                  title: 'Instructions',
                  items: controller.instructions,
                  onAdd: (text) => controller.addInstruction(text),
                  onRemove: (index) => controller.removeInstruction(index),
                  hint: 'Add a step',
                  isStep: true,
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.submitRecipe,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Post Recipe",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildDynamicList({
    required String title,
    required List<String> items,
    required Function(String) onAdd,
    required Function(int) onRemove,
    required String hint,
    bool isStep = false,
  }) {
    final TextEditingController textController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...items.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                if (isStep)
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      "${entry.key + 1}",
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  )
                else
                  const Icon(Icons.circle, size: 8, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(entry.value, style: const TextStyle(fontSize: 16))),
                IconButton(
                  onPressed: () => onRemove(entry.key),
                  icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                  hintText: hint,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) {
                    onAdd(val);
                    textController.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  onAdd(textController.text);
                  textController.clear();
                }
              },
              icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 30),
            ),
          ],
        ),
      ],
    );
  }
}
