import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Storage Provider
/// Handles Firebase Storage operations for image uploads
class StorageProvider {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  // ============================================
  // Profile Picture Operations
  // ============================================

  /// Upload profile picture
  Future<String> uploadProfilePicture(File file, String userId) async {
    final compressedFile = await _compressImage(file);
    final ref = _storage.ref().child('profile_pictures/$userId/profile.jpg');

    await ref.putFile(compressedFile);
    return await ref.getDownloadURL();
  }

  /// Delete profile picture
  Future<void> deleteProfilePicture(String userId) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId/profile.jpg');
      await ref.delete();
    } catch (e) {
      // File might not exist, ignore error
    }
  }

  // ============================================
  // Recipe Image Operations
  // ============================================

  /// Upload recipe main image
  Future<String> uploadRecipeImage(File file, String recipeId) async {
    final compressedFile = await _compressImage(file);
    final ref = _storage.ref().child('recipe_images/$recipeId/main.jpg');

    await ref.putFile(compressedFile);
    return await ref.getDownloadURL();
  }

  /// Upload recipe step image
  Future<String> uploadStepImage(File file, String recipeId, int stepNumber) async {
    final compressedFile = await _compressImage(file);
    final ref = _storage.ref().child('recipe_images/$recipeId/steps/step_$stepNumber.jpg');

    await ref.putFile(compressedFile);
    return await ref.getDownloadURL();
  }

  /// Delete all images for a recipe
  Future<void> deleteRecipeImages(String recipeId) async {
    try {
      final mainRef = _storage.ref().child('recipe_images/$recipeId');
      final listResult = await mainRef.listAll();

      for (final item in listResult.items) {
        await item.delete();
      }

      // Delete step images
      for (final prefix in listResult.prefixes) {
        final stepItems = await prefix.listAll();
        for (final item in stepItems.items) {
          await item.delete();
        }
      }
    } catch (e) {
      // Handle deletion errors gracefully
    }
  }

  // ============================================
  // Generic Upload
  // ============================================

  /// Upload a generic image with custom path
  Future<String> uploadImage(File file, String path) async {
    final compressedFile = await _compressImage(file);
    final ref = _storage.ref().child(path);

    await ref.putFile(compressedFile);
    return await ref.getDownloadURL();
  }

  /// Generate a unique filename
  String generateFileName(String extension) {
    return '${_uuid.v4()}.$extension';
  }

  // ============================================
  // Image Compression
  // ============================================

  /// Compress image to reduce file size
  Future<File> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = '${dir.path}/${_uuid.v4()}.jpg';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1024,
      minHeight: 1024,
    );

    return result != null ? File(result.path) : file;
  }

  /// Get file size in MB
  double getFileSizeInMB(File file) {
    final bytes = file.lengthSync();
    return bytes / (1024 * 1024);
  }

  /// Check if file is valid image
  bool isValidImage(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  /// Check if file size is within limit (5MB)
  bool isWithinSizeLimit(File file, {double maxMB = 5.0}) {
    return getFileSizeInMB(file) <= maxMB;
  }
}
