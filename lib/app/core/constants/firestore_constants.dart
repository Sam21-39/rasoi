/// Firestore collection names and field names
class FirestoreConstants {
  // Collections
  static const String usersCollection = 'users';
  static const String recipesCollection = 'recipes';
  static const String categoriesCollection = 'categories';
  static const String followersSubcollection = 'followers';
  static const String followingSubcollection = 'following';
  static const String userPreferencesSubcollection = 'userPreferences';

  // User Fields
  static const String userUid = 'uid';
  static const String userEmail = 'email';
  static const String userDisplayName = 'displayName';
  static const String userPhotoURL = 'photoURL';
  static const String userBio = 'bio';
  static const String userIsEmailVerified = 'isEmailVerified';
  static const String userFollowerCount = 'followerCount';
  static const String userFollowingCount = 'followingCount';
  static const String userRecipeCount = 'recipeCount';
  static const String userCreatedAt = 'createdAt';
  static const String userUpdatedAt = 'updatedAt';

  // Recipe Fields
  static const String recipeId = 'id';
  static const String recipeTitle = 'title';
  static const String recipeDescription = 'description';
  static const String recipeImageUrl = 'imageUrl';
  static const String recipeAuthorId = 'authorId';
  static const String recipeAuthorName = 'authorName';
  static const String recipeCategory = 'category';
  static const String recipeDifficulty = 'difficulty';
  static const String recipeCookTime = 'cookTime';
  static const String recipeIngredients = 'ingredients';
  static const String recipeInstructions = 'instructions';
  static const String recipeLikes = 'likes';
  static const String recipeCreatedAt = 'createdAt';

  // Preferences Fields
  static const String prefThemeMode = 'themeMode';
  static const String prefLanguage = 'language';
  static const String prefNotificationsEnabled = 'notificationsEnabled';

  // Private constructor
  FirestoreConstants._();
}
