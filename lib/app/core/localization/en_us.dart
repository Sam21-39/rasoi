import 'package:get/get.dart';

/// English translations
class EnglishTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Common
      'app_name': 'Rasoi',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'retry': 'Retry',
      'search': 'Search',

      // Authentication
      'welcome_to_rasoi': 'Welcome to Rasoi',
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'display_name': 'Display Name',
      'forgot_password': 'Forgot Password?',
      'reset_password': 'Reset Password',
      'send_reset_link': 'Send Reset Link',
      'email_required': 'Email is required',
      'password_required': 'Password is required',
      'passwords_dont_match': 'Passwords don\'t match',
      'invalid_email': 'Please enter a valid email',
      'weak_password': 'Password is too weak',
      'sign_in_with_google': 'Sign in with Google',
      'or_continue_with': 'Or continue with',
      'already_have_account': 'Already have an account?',
      'dont_have_account': 'Don\'t have an account?',
      'create_account': 'Create Account',
      'verify_email': 'Verify Email',
      'verification_email_sent': 'Verification email sent',

      // Onboarding
      'onboarding_title_1': 'Welcome to Rasoi',
      'onboarding_desc_1': 'Discover amazing recipes from a community of food lovers.',
      'onboarding_title_2': 'Share Your Creations',
      'onboarding_desc_2': 'Post your detailed recipes and get feedback from others.',
      'onboarding_title_3': 'Become a Chef',
      'onboarding_desc_3': 'Climb the ranks and build your culinary profile.',
      'skip': 'Skip',
      'next': 'Next',
      'get_started': 'Get Started',

      // Home
      'home': 'Home',
      'recipes': 'Recipes',
      'no_recipes_found': 'No recipes found',
      'no_recipes_yet': 'No recipes yet',
      'start_creating': 'Start creating your first recipe!',

      // Recipe
      'create_recipe': 'Create Recipe',
      'recipe_title': 'Recipe Title',
      'description': 'Description',
      'ingredients': 'Ingredients',
      'instructions': 'Instructions',
      'add_ingredient': 'Add Ingredient',
      'add_instruction': 'Add Instruction',
      'category': 'Category',
      'difficulty': 'Difficulty',
      'cook_time': 'Cook Time',
      'easy': 'Easy',
      'medium': 'Medium',
      'hard': 'Hard',
      'under_15_min': 'Under 15 min',
      '15_30_min': '15-30 min',
      '30_60_min': '30-60 min',
      'over_60_min': 'Over 60 min',
      'pick_image': 'Pick Image',
      'recipe_created': 'Recipe created successfully',
      'recipe_updated': 'Recipe updated successfully',
      'recipe_deleted': 'Recipe deleted successfully',

      // Profile
      'profile': 'Profile',
      'edit_profile': 'Edit Profile',
      'bio': 'Bio',
      'followers': 'Followers',
      'following': 'Following',
      'follow': 'Follow',
      'unfollow': 'Unfollow',

      // Settings
      'settings': 'Settings',
      'theme': 'Theme',
      'language': 'Language',
      'light_mode': 'Light Mode',
      'dark_mode': 'Dark Mode',
      'system_default': 'System Default',
      'notifications': 'Notifications',
      'enable_notifications': 'Enable Notifications',
      'about': 'About',
      'version': 'Version',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',

      // Errors
      'error_occurred': 'An error occurred',
      'network_error': 'Network error. Please check your connection.',
      'try_again': 'Please try again',
      'something_went_wrong': 'Something went wrong',
    },
  };
}
