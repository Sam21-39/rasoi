import 'package:get/get.dart';

/// Hindi translations
class HindiTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'hi_IN': {
      // Common
      'app_name': 'रसोई',
      'ok': 'ठीक है',
      'cancel': 'रद्द करें',
      'save': 'सहेजें',
      'delete': 'हटाएं',
      'edit': 'संपादित करें',
      'done': 'हो गया',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि',
      'success': 'सफलता',
      'retry': 'पुनः प्रयास करें',
      'search': 'खोजें',

      // Authentication
      'welcome_to_rasoi': 'रसोई में आपका स्वागत है',
      'login': 'लॉगिन',
      'signup': 'साइन अप',
      'logout': 'लॉगआउट',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'confirm_password': 'पासवर्ड की पुष्टि करें',
      'display_name': 'नाम',
      'forgot_password': 'पासवर्ड भूल गए?',
      'reset_password': 'पासवर्ड रीसेट करें',
      'send_reset_link': 'रीसेट लिंक भेजें',
      'email_required': 'ईमेल आवश्यक है',
      'password_required': 'पासवर्ड आवश्यक है',
      'passwords_dont_match': 'पासवर्ड मेल नहीं खाते',
      'invalid_email': 'कृपया एक मान्य ईमेल दर्ज करें',
      'weak_password': 'पासवर्ड बहुत कमजोर है',
      'sign_in_with_google': 'Google से साइन इन करें',
      'or_continue_with': 'या जारी रखें',
      'already_have_account': 'पहले से खाता है?',
      'dont_have_account': 'खाता नहीं है?',
      'create_account': 'खाता बनाएं',
      'verify_email': 'ईमेल सत्यापित करें',
      'verification_email_sent': 'सत्यापन ईमेल भेजा गया',

      // Onboarding
      'onboarding_title_1': 'रसोई में आपका स्वागत है',
      'onboarding_desc_1': 'खाना प्रेमियों के समुदाय से अद्भुत व्यंजन खोजें।',
      'onboarding_title_2': 'अपनी रचनाएं साझा करें',
      'onboarding_desc_2': 'अपने विस्तृत व्यंजन पोस्ट करें और दूसरों से प्रतिक्रिया प्राप्त करें।',
      'onboarding_title_3': 'एक शेफ बनें',
      'onboarding_desc_3': 'रैंक चढ़ें और अपनी पाक प्रोफ़ाइल बनाएं।',
      'skip': 'छोड़ें',
      'next': 'अगला',
      'get_started': 'शुरू करें',

      // Home
      'home': 'होम',
      'recipes': 'व्यंजन',
      'no_recipes_found': 'कोई व्यंजन नहीं मिला',
      'no_recipes_yet': 'अभी तक कोई व्यंजन नहीं',
      'start_creating': 'अपना पहला व्यंजन बनाना शुरू करें!',

      // Recipe
      'create_recipe': 'व्यंजन बनाएं',
      'recipe_title': 'व्यंजन का शीर्षक',
      'description': 'विवरण',
      'ingredients': 'सामग्री',
      'instructions': 'निर्देश',
      'add_ingredient': 'सामग्री जोड़ें',
      'add_instruction': 'निर्देश जोड़ें',
      'category': 'श्रेणी',
      'difficulty': 'कठिनाई',
      'cook_time': 'पकाने का समय',
      'easy': 'आसान',
      'medium': 'मध्यम',
      'hard': 'कठिन',
      'under_15_min': '15 मिनट से कम',
      '15_30_min': '15-30 मिनट',
      '30_60_min': '30-60 मिनट',
      'over_60_min': '60 मिनट से अधिक',
      'pick_image': 'छवि चुनें',
      'recipe_created': 'व्यंजन सफलतापूर्वक बनाया गया',
      'recipe_updated': 'व्यंजन सफलतापूर्वक अपडेट किया गया',
      'recipe_deleted': 'व्यंजन सफलतापूर्वक हटाया गया',

      // Profile
      'profile': 'प्रोफ़ाइल',
      'edit_profile': 'प्रोफ़ाइल संपादित करें',
      'bio': 'बायो',
      'followers': 'फॉलोअर्स',
      'following': 'फॉलोइंग',
      'follow': 'फॉलो करें',
      'unfollow': 'अनफॉलो करें',

      // Settings
      'settings': 'सेटिंग्स',
      'theme': 'थीम',
      'language': 'भाषा',
      'light_mode': 'लाइट मोड',
      'dark_mode': 'डार्क मोड',
      'system_default': 'सिस्टम डिफ़ॉल्ट',
      'notifications': 'सूचनाएं',
      'enable_notifications': 'सूचनाएं सक्षम करें',
      'about': 'के बारे में',
      'version': 'संस्करण',
      'privacy_policy': 'गोपनीयता नीति',
      'terms_of_service': 'सेवा की शर्तें',

      // Errors
      'error_occurred': 'एक त्रुटि हुई',
      'network_error': 'नेटवर्क त्रुटि। कृपया अपना कनेक्शन जांचें।',
      'try_again': 'कृपया पुनः प्रयास करें',
      'something_went_wrong': 'कुछ गलत हो गया',
    },
  };
}
