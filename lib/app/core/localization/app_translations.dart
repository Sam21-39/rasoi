import 'package:get/get.dart';
import 'en_us.dart';
import 'hi_in.dart';

/// App translations combining all languages
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    final Map<String, Map<String, String>> allTranslations = {};

    // Merge English translations
    final english = EnglishTranslations().keys;
    allTranslations.addAll(english);

    // Merge Hindi translations
    final hindi = HindiTranslations().keys;
    allTranslations.addAll(hindi);

    return allTranslations;
  }
}
