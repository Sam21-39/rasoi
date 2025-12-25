/// Rasoi App Strings
/// All user-facing text strings for easy localization
class AppStrings {
  AppStrings._();

  // ============================================
  // General
  // ============================================

  static const String appName = 'Rasoi';
  static const String tagline = 'Your pocket kitchen companion';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String back = 'Back';
  static const String skip = 'Skip';
  static const String submit = 'Submit';
  static const String confirm = 'Confirm';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String close = 'Close';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String apply = 'Apply';
  static const String clear = 'Clear';
  static const String clearAll = 'Clear All';
  static const String seeAll = 'See All';
  static const String viewAll = 'View All';

  // ============================================
  // Authentication
  // ============================================

  static const String welcomeTitle = 'Welcome to Rasoi';
  static const String welcomeSubtitle = 'Discover, cook, and share authentic Indian recipes';
  static const String signInWithGoogle = 'Sign in with Google';
  static const String signingIn = 'Signing in...';
  static const String signInFailed = 'Sign in failed. Please try again.';
  static const String logout = 'Logout';
  static const String logoutConfirm = 'Are you sure you want to logout?';
  static const String deleteAccount = 'Delete Account';
  static const String deleteAccountConfirm =
      'This action cannot be undone. All your recipes and data will be permanently deleted.';

  // ============================================
  // Onboarding
  // ============================================

  static const String selectDietaryPreference = 'Select your dietary preference';
  static const String dietaryPreferenceSubtitle = 'We\'ll personalize recipes for you';
  static const String getStarted = 'Get Started';

  // ============================================
  // Home
  // ============================================

  static const String home = 'Home';
  static const String discover = 'Discover';
  static const String discoverSubtitle = 'Find your next favorite recipe';
  static const String popularRecipes = 'Popular Recipes';
  static const String recentRecipes = 'Recent Recipes';
  static const String noRecipesFound = 'No recipes found';
  static const String tryDifferentSearch = 'Try a different search or filter';
  static const String pullToRefresh = 'Pull to refresh';

  // ============================================
  // Search
  // ============================================

  static const String searchHint = 'Search recipes or ingredients...';
  static const String recentSearches = 'Recent Searches';
  static const String clearSearchHistory = 'Clear Search History';
  static const String noResults = 'No results found';
  static const String searchSuggestion = 'Try searching for "dal" or "paneer"';

  // ============================================
  // Filters
  // ============================================

  static const String filters = 'Filters';
  static const String category = 'Category';
  static const String dietaryType = 'Dietary Type';
  static const String cookingTime = 'Cooking Time';
  static const String difficulty = 'Difficulty';
  static const String servingSize = 'Serving Size';
  static const String applyFilters = 'Apply Filters';
  static const String clearFilters = 'Clear Filters';

  // ============================================
  // Recipe Detail
  // ============================================

  static const String ingredients = 'Ingredients';
  static const String instructions = 'Instructions';
  static const String comments = 'Comments';
  static const String servings = 'Servings';
  static const String cookTime = 'Cook Time';
  static const String minutes = 'min';
  static const String likes = 'likes';
  static const String views = 'views';
  static const String share = 'Share';
  static const String saveRecipe = 'Save Recipe';
  static const String unsaveRecipe = 'Remove from Saved';
  static const String recipeSaved = 'Recipe saved!';
  static const String recipeUnsaved = 'Recipe removed from saved';

  // ============================================
  // Create Recipe
  // ============================================

  static const String createRecipe = 'Create Recipe';
  static const String addRecipe = 'Add Recipe';
  static const String basicInfo = 'Basic Info';
  static const String addIngredients = 'Add Ingredients';
  static const String addInstructions = 'Add Instructions';
  static const String reviewPublish = 'Review & Publish';

  static const String recipeTitle = 'Recipe Title';
  static const String recipeTitleHint = 'e.g., Butter Chicken';
  static const String recipeDescription = 'Description (optional)';
  static const String recipeDescriptionHint = 'Brief description of your recipe';
  static const String selectCategory = 'Select Category';
  static const String selectDietaryType = 'Select Dietary Type';
  static const String selectDifficulty = 'Select Difficulty';
  static const String enterCookingTime = 'Cooking Time (minutes)';
  static const String enterServings = 'Number of Servings';
  static const String uploadImage = 'Upload Recipe Image';
  static const String changeImage = 'Change Image';

  static const String ingredientName = 'Ingredient Name';
  static const String quantity = 'Quantity';
  static const String unit = 'Unit';
  static const String addIngredient = 'Add Ingredient';
  static const String minimumIngredients = 'Add at least 2 ingredients';

  static const String stepDescription = 'Step Description';
  static const String addStep = 'Add Step';
  static const String addStepImage = 'Add Image (optional)';
  static const String minimumSteps = 'Add at least 3 steps';

  static const String publishRecipe = 'Publish Recipe';
  static const String saveDraft = 'Save as Draft';
  static const String publishing = 'Publishing...';
  static const String recipePublished = 'Recipe published successfully!';
  static const String recipeUpdated = 'Recipe updated successfully!';
  static const String draftSaved = 'Draft saved';

  // ============================================
  // Comments
  // ============================================

  static const String addComment = 'Add a comment...';
  static const String postComment = 'Post';
  static const String noComments = 'No comments yet';
  static const String beFirstToComment = 'Be the first to share your thoughts!';
  static const String commentPosted = 'Comment posted!';
  static const String commentDeleted = 'Comment deleted';
  static const String deleteComment = 'Delete Comment';
  static const String deleteCommentConfirm = 'Are you sure you want to delete this comment?';

  // ============================================
  // Profile
  // ============================================

  static const String profile = 'Profile';
  static const String editProfile = 'Edit Profile';
  static const String myRecipes = 'My Recipes';
  static const String savedRecipes = 'Saved';
  static const String noMyRecipes = 'You haven\'t posted any recipes yet';
  static const String shareFirstRecipe = 'Share your first recipe!';
  static const String noSavedRecipes = 'No saved recipes';
  static const String startSavingRecipes = 'Save recipes you want to try!';
  static const String recipesCount = 'Recipes';
  static const String likesCount = 'Likes';
  static const String bio = 'Bio';
  static const String bioHint = 'Tell us about yourself...';
  static const String profileUpdated = 'Profile updated!';

  // ============================================
  // Settings
  // ============================================

  static const String settings = 'Settings';
  static const String dietaryPreferences = 'Dietary Preferences';
  static const String notifications = 'Notifications';
  static const String language = 'Language';
  static const String clearCache = 'Clear Cache';
  static const String cacheCleared = 'Cache cleared';
  static const String about = 'About Rasoi';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';
  static const String helpFeedback = 'Help & Feedback';
  static const String version = 'Version';

  // ============================================
  // Errors
  // ============================================

  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNoInternet = 'No internet connection';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorLoadingRecipes = 'Failed to load recipes';
  static const String errorUploadImage = 'Failed to upload image';
  static const String errorSaveRecipe = 'Failed to save recipe';
  static const String errorDeleteRecipe = 'Failed to delete recipe';
  static const String errorPostComment = 'Failed to post comment';

  // ============================================
  // Validation
  // ============================================

  static const String requiredField = 'This field is required';
  static const String titleTooShort = 'Title must be at least 3 characters';
  static const String titleTooLong = 'Title cannot exceed 100 characters';
  static const String descriptionTooLong = 'Description cannot exceed 200 characters';
  static const String commentTooLong = 'Comment cannot exceed 500 characters';
  static const String invalidNumber = 'Please enter a valid number';
  static const String selectImage = 'Please select an image';
  static const String imageTooLarge = 'Image size must be less than 5MB';

  // ============================================
  // Offline
  // ============================================

  static const String offline = 'You\'re offline';
  static const String offlineMessage = 'Some features may not be available';
  static const String syncPending = 'Changes will sync when online';
  static const String syncing = 'Syncing...';
  static const String syncComplete = 'All changes synced';

  // ============================================
  // Share
  // ============================================

  static const String shareRecipeTitle = 'Check out this recipe on Rasoi!';
  static const String shareAppText = 'Download Rasoi - Your pocket kitchen companion';
}
