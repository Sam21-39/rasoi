import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/errors/recipe_failures.dart';
import '../../core/services/logger_service.dart';
import '../../core/constants/app_constants.dart';

class StorageService {
  final LoggerService _logger = LoggerService();

  /// Upload image and return base64 string
  /// Note: This is a temporary solution. In production, use Firebase Storage
  Future<Either<StorageFailure, String>> uploadImage(File imageFile) async {
    try {
      _logger.info('Uploading image: ${imageFile.path}');

      // Check file size
      final fileSize = await imageFile.length();
      if (fileSize > AppConstants.maxImageSizeBytes) {
        _logger.warning('Image too large: ${fileSize / 1024 / 1024}MB');
        return Left(StorageFailure.fileTooLarge());
      }

      // Check file extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!AppConstants.allowedImageFormats.contains(extension)) {
        _logger.warning('Invalid image format: $extension');
        return Left(StorageFailure.invalidFile());
      }

      // Convert to base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);
      final dataUrl = 'data:image/$extension;base64,$base64String';

      _logger.info('Image uploaded successfully (${fileSize / 1024}KB)');
      return Right(dataUrl);
    } catch (e) {
      _logger.error('Failed to upload image', e);
      return Left(StorageFailure.uploadFailed());
    }
  }

  /// Delete image (placeholder for now)
  Future<Either<StorageFailure, void>> deleteImage(String imageUrl) async {
    try {
      _logger.info('Deleting image: $imageUrl');

      // For base64 images, nothing to delete
      // In production with Firebase Storage, implement actual deletion

      _logger.info('Image deleted successfully');
      return const Right(null);
    } catch (e) {
      _logger.error('Failed to delete image', e);
      return Left(StorageFailure.deleteFailed());
    }
  }

  /// Validate image file
  Either<StorageFailure, void> validateImage(File imageFile) {
    try {
      // Check if file exists
      if (!imageFile.existsSync()) {
        return Left(StorageFailure.invalidFile());
      }

      // Check extension
      final extension = imageFile.path.split('.').last.toLowerCase();
      if (!AppConstants.allowedImageFormats.contains(extension)) {
        return Left(StorageFailure.invalidFile());
      }

      return const Right(null);
    } catch (e) {
      _logger.error('Image validation failed', e);
      return Left(StorageFailure.invalidFile());
    }
  }

  /// Get file size in MB
  Future<Either<StorageFailure, double>> getFileSizeMB(File file) async {
    try {
      final bytes = await file.length();
      final mb = bytes / 1024 / 1024;
      return Right(mb);
    } catch (e) {
      _logger.error('Failed to get file size', e);
      return Left(StorageFailure.invalidFile());
    }
  }
}
