/// Recipe difficulty levels
enum RecipeDifficulty { easy, medium, hard }

extension RecipeDifficultyExtension on RecipeDifficulty {
  String get displayName {
    switch (this) {
      case RecipeDifficulty.easy:
        return 'Easy';
      case RecipeDifficulty.medium:
        return 'Medium';
      case RecipeDifficulty.hard:
        return 'Hard';
    }
  }

  String get value {
    switch (this) {
      case RecipeDifficulty.easy:
        return 'easy';
      case RecipeDifficulty.medium:
        return 'medium';
      case RecipeDifficulty.hard:
        return 'hard';
    }
  }

  static RecipeDifficulty fromString(String value) {
    switch (value.toLowerCase()) {
      case 'easy':
        return RecipeDifficulty.easy;
      case 'medium':
        return RecipeDifficulty.medium;
      case 'hard':
        return RecipeDifficulty.hard;
      default:
        return RecipeDifficulty.medium;
    }
  }
}
