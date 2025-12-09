import 'dart:io';
import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../data/models/recipe_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/recipe_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/permission_service.dart';
import '../../routes/app_pages.dart';

class CreateRecipeController extends GetxController {
  final RecipeService _recipeService = Get.find<RecipeService>();
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Form Fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController(); // Bio/Desc
  final TextEditingController cookTimeController = TextEditingController(); // e.g., "30 mins"

  // Dropdowns
  final RxString selectedCategory = 'breakfast'.obs; // Default
  final RxString selectedDifficulty = 'Medium'.obs;
  final RxInt servings = 2.obs;

  // Lists
  final RxList<String> ingredients = <String>[].obs;
  final RxList<String> instructions = <String>[].obs;

  // Image
  final Rx<File?> imageFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  final RxBool isLoading = false.obs;

  // Categories list (in real app, fetch from seeding service/firestore)
  final List<String> categories = ['breakfast', 'lunch', 'dinner', 'snacks', 'desserts', 'drinks'];
  final List<String> difficulties = ['Easy', 'Medium', 'Hard'];

  void pickImage() async {
    // Check permission
    final PermissionService info = Get.find<PermissionService>();
    final hasPermission = await info.requestPhotosPermission();

    if (!hasPermission) {
      Get.snackbar("Permission Denied", "Photos permission is required to upload images.");
      // Optionally open settings using info.openSettings();
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _cropImage(pickedFile.path);
    }
  }

  Future<void> _cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: false,
        ),
      ],
      aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
    );

    if (croppedFile != null) {
      imageFile.value = File(croppedFile.path);
    }
  }

  void addIngredient(String ingredient) {
    if (ingredient.isNotEmpty) ingredients.add(ingredient);
  }

  void removeIngredient(int index) {
    ingredients.removeAt(index);
  }

  void addInstruction(String instruction) {
    if (instruction.isNotEmpty) instructions.add(instruction);
  }

  void removeInstruction(int index) {
    instructions.removeAt(index);
  }

  void submitRecipe() async {
    if (!formKey.currentState!.validate()) return;
    if (imageFile.value == null) {
      Get.snackbar("Error", "Please add a recipe image");
      return;
    }
    if (ingredients.isEmpty) {
      Get.snackbar("Error", "Please add at least one ingredient");
      return;
    }
    if (instructions.isEmpty) {
      Get.snackbar("Error", "Please add at least one instruction step");
      return;
    }

    try {
      isLoading.value = true;

      // 1. Upload Image
      final uploadResult = await _storageService.uploadImage(imageFile.value!);

      String imageUrl = '';
      uploadResult.fold(
        (failure) {
          Get.snackbar("Error", failure.message);
          return;
        },
        (url) {
          imageUrl = url;
        },
      );

      if (imageUrl.isEmpty) {
        isLoading.value = false;
        return;
      }

      // 2. Create Recipe Object
      final currentUser = _authService.appUser.value;
      if (currentUser == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      final recipe = RecipeModel(
        title: titleController.text.trim(),
        imageURL: imageUrl,
        authorId: currentUser.uid!,
        authorName: currentUser.displayName ?? 'Chef',
        authorPhoto: currentUser.photoURL ?? '',
        category: selectedCategory.value,
        ingredients: ingredients,
        instructions: instructions,
        cookTime: cookTimeController.text.trim(),
        difficulty: selectedDifficulty.value,
        servings: servings.value,
        likeCount: 0,
      );

      // 3. Save to Firestore
      await _recipeService.createRecipe(recipe);

      Get.snackbar("Success", "Recipe posted successfully!");
      Get.offAllNamed(Routes.HOME); // Go back to Home
    } catch (e) {
      Get.snackbar("Error", "Failed to post recipe: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
