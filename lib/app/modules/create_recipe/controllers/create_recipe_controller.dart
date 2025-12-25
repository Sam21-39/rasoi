import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/recipe_model.dart';
import '../../../data/models/ingredient_model.dart';
import '../../../data/models/instruction_model.dart';
import '../../../data/repositories/recipe_repository.dart';
import '../../../services/database_service.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';

/// Create Recipe Controller
/// Manages recipe creation flow with 4 steps
class CreateRecipeController extends GetxController {
  static CreateRecipeController get to => Get.find<CreateRecipeController>();

  // Dependencies
  final RecipeRepository _recipeRepository = RecipeRepository();
  final DatabaseService _databaseService = DatabaseService();
  final ImagePicker _imagePicker = ImagePicker();

  // Step tracking
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Step 1: Basic Info
  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final RxString category = ''.obs;
  final RxList<String> dietaryTypes = <String>[].obs;
  final RxInt cookingTime = 30.obs;
  final RxString difficulty = 'Easy'.obs;
  final RxInt servings = 2.obs;
  final Rx<File?> mainImage = Rx<File?>(null);

  // Step 2: Ingredients
  final RxList<IngredientModel> ingredients = <IngredientModel>[].obs;

  // Step 3: Instructions
  final RxList<InstructionModel> instructions = <InstructionModel>[].obs;

  // Edit mode
  String? editingRecipeId;
  bool get isEditing => editingRecipeId != null;

  @override
  void onInit() {
    super.onInit();

    // Check if editing existing recipe
    editingRecipeId = Get.parameters['id'];
    if (isEditing) {
      _loadExistingRecipe();
    } else {
      // Load draft if exists
      _loadDraft();
    }
  }

  @override
  void onClose() {
    // Save draft on close if not published
    if (!isEditing && title.value.isNotEmpty) {
      _saveDraft();
    }
    super.onClose();
  }

  // ============================================
  // Navigation
  // ============================================

  void nextStep() {
    if (!_validateCurrentStep()) return;

    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 3) {
      currentStep.value = step;
    }
  }

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        if (title.value.trim().isEmpty) {
          Get.snackbar('Error', 'Please enter a title');
          return false;
        }
        if (category.value.isEmpty) {
          Get.snackbar('Error', 'Please select a category');
          return false;
        }
        if (mainImage.value == null && !isEditing) {
          Get.snackbar('Error', 'Please add a recipe image');
          return false;
        }
        return true;
      case 1:
        if (ingredients.isEmpty) {
          Get.snackbar('Error', 'Please add at least one ingredient');
          return false;
        }
        return true;
      case 2:
        if (instructions.isEmpty) {
          Get.snackbar('Error', 'Please add at least one instruction');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  // ============================================
  // Image Handling
  // ============================================

  Future<void> pickMainImage() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        mainImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<void> takePhoto() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        mainImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to take photo');
    }
  }

  // ============================================
  // Ingredients Management
  // ============================================

  void addIngredient(String name, String quantity, String unit) {
    if (name.trim().isEmpty) return;

    ingredients.add(
      IngredientModel(name: name.trim(), quantity: quantity.trim(), unit: unit.trim()),
    );
  }

  void updateIngredient(int index, String name, String quantity, String unit) {
    if (index < 0 || index >= ingredients.length) return;

    ingredients[index] = IngredientModel(
      name: name.trim(),
      quantity: quantity.trim(),
      unit: unit.trim(),
    );
  }

  void removeIngredient(int index) {
    if (index >= 0 && index < ingredients.length) {
      ingredients.removeAt(index);
    }
  }

  void reorderIngredients(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = ingredients.removeAt(oldIndex);
    ingredients.insert(newIndex, item);
  }

  // ============================================
  // Instructions Management
  // ============================================

  void addInstruction(String description) {
    if (description.trim().isEmpty) return;

    instructions.add(
      InstructionModel(stepNumber: instructions.length + 1, description: description.trim()),
    );
  }

  void updateInstruction(int index, String description) {
    if (index < 0 || index >= instructions.length) return;

    instructions[index] = instructions[index].copyWith(description: description.trim());
  }

  void removeInstruction(int index) {
    if (index >= 0 && index < instructions.length) {
      instructions.removeAt(index);
      // Renumber remaining steps
      for (int i = 0; i < instructions.length; i++) {
        instructions[i] = instructions[i].copyWith(stepNumber: i + 1);
      }
    }
  }

  void reorderInstructions(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = instructions.removeAt(oldIndex);
    instructions.insert(newIndex, item);
    // Renumber all steps
    for (int i = 0; i < instructions.length; i++) {
      instructions[i] = instructions[i].copyWith(stepNumber: i + 1);
    }
  }

  // ============================================
  // Publishing
  // ============================================

  Future<void> publishRecipe() async {
    if (!_validateCurrentStep()) return;

    final authController = Get.find<AuthController>();
    if (!authController.isLoggedIn) {
      Get.snackbar('Error', 'Please sign in to publish');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final recipe = RecipeModel(
        recipeId: editingRecipeId ?? '',
        authorId: authController.userId,
        authorName: authController.currentUser.value.displayName,
        authorPhotoUrl: authController.currentUser.value.photoUrl,
        title: title.value.trim(),
        description: description.value.trim(),
        category: category.value,
        dietaryTypes: dietaryTypes.toList(),
        cookingTime: cookingTime.value,
        difficulty: difficulty.value,
        servings: servings.value,
        imageUrl: '', // Will be set by repository after upload
        ingredients: ingredients.toList(),
        instructions: instructions.toList(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (isEditing) {
        await _recipeRepository.updateRecipe(
          editingRecipeId!,
          recipe.toJson(),
          newImage: mainImage.value,
        );
      } else {
        await _recipeRepository.createRecipe(recipe, mainImage.value!);
      }

      // Delete draft
      await _databaseService.deleteDraft('recipe_draft');

      isLoading.value = false;

      Get.snackbar(
        'Success',
        isEditing ? 'Recipe updated!' : 'Recipe published!',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate back to home
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to publish recipe');
    }
  }

  // ============================================
  // Draft Management
  // ============================================

  Future<void> _saveDraft() async {
    final draft = {
      'title': title.value,
      'description': description.value,
      'category': category.value,
      'dietaryTypes': dietaryTypes.toList(),
      'cookingTime': cookingTime.value,
      'difficulty': difficulty.value,
      'servings': servings.value,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'instructions': instructions.map((i) => i.toJson()).toList(),
    };
    await _databaseService.saveDraft('recipe_draft', draft);
  }

  Future<void> _loadDraft() async {
    final draft = await _databaseService.getDraft('recipe_draft');
    if (draft != null && draft.isNotEmpty) {
      // Show dialog to restore draft
      Get.dialog(
        AlertDialog(
          title: const Text('Restore Draft?'),
          content: const Text('You have an unsaved recipe. Would you like to continue editing it?'),
          actions: [
            TextButton(
              onPressed: () {
                _databaseService.deleteDraft('recipe_draft');
                Get.back();
              },
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () {
                _applyDraft(draft);
                Get.back();
              },
              child: const Text('Restore'),
            ),
          ],
        ),
      );
    }
  }

  void _applyDraft(Map<String, dynamic> draft) {
    title.value = draft['title'] ?? '';
    description.value = draft['description'] ?? '';
    category.value = draft['category'] ?? '';
    dietaryTypes.value = List<String>.from(draft['dietaryTypes'] ?? []);
    cookingTime.value = draft['cookingTime'] ?? 30;
    difficulty.value = draft['difficulty'] ?? 'Easy';
    servings.value = draft['servings'] ?? 2;

    if (draft['ingredients'] != null) {
      ingredients.value = (draft['ingredients'] as List)
          .map((i) => IngredientModel.fromJson(i))
          .toList();
    }

    if (draft['instructions'] != null) {
      instructions.value = (draft['instructions'] as List)
          .map((i) => InstructionModel.fromJson(i))
          .toList();
    }
  }

  Future<void> _loadExistingRecipe() async {
    try {
      isLoading.value = true;
      final recipe = await _recipeRepository.getRecipeDetails(editingRecipeId!);

      if (recipe != null) {
        title.value = recipe.title;
        description.value = recipe.description;
        category.value = recipe.category;
        dietaryTypes.value = recipe.dietaryTypes;
        cookingTime.value = recipe.cookingTime;
        difficulty.value = recipe.difficulty;
        servings.value = recipe.servings;
        ingredients.value = recipe.ingredients;
        instructions.value = recipe.instructions;
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to load recipe');
    }
  }

  // ============================================
  // Cleanup
  // ============================================

  void clearForm() {
    title.value = '';
    description.value = '';
    category.value = '';
    dietaryTypes.clear();
    cookingTime.value = 30;
    difficulty.value = 'Easy';
    servings.value = 2;
    mainImage.value = null;
    ingredients.clear();
    instructions.clear();
    currentStep.value = 0;
  }
}
