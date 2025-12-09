import 'failures.dart';

/// Recipe-specific failures
class RecipeFailure extends Failure {
  const RecipeFailure(String message) : super(message);

  factory RecipeFailure.notFound() {
    return const RecipeFailure('Recipe not found');
  }

  factory RecipeFailure.createFailed() {
    return const RecipeFailure('Failed to create recipe');
  }

  factory RecipeFailure.updateFailed() {
    return const RecipeFailure('Failed to update recipe');
  }

  factory RecipeFailure.deleteFailed() {
    return const RecipeFailure('Failed to delete recipe');
  }

  factory RecipeFailure.fetchFailed() {
    return const RecipeFailure('Failed to fetch recipes');
  }
}

/// Storage-specific failures
class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message);

  factory StorageFailure.uploadFailed() {
    return const StorageFailure('Failed to upload image');
  }

  factory StorageFailure.deleteFailed() {
    return const StorageFailure('Failed to delete image');
  }

  factory StorageFailure.invalidFile() {
    return const StorageFailure('Invalid file format');
  }

  factory StorageFailure.fileTooLarge() {
    return const StorageFailure('File size exceeds limit');
  }
}
