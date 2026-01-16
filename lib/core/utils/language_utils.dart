/// Utility class for language-related conversions
class LanguageUtils {
  /// Converts language codes to native language names (in their own script)
  /// Supports both short codes (en, si, ta) and full names
  static String getLanguageName(String languageCode) {
    switch (languageCode.toLowerCase().trim()) {
      case 'en':
      case 'english':
        return 'English';
      case 'si':
      case 'sinhala':
        return 'සිංහල';  // Sinhala in Sinhala script
      case 'ta':
      case 'tamil':
        return 'தமிழ்';  // Tamil in Tamil script
      case 'ar':
      case 'arabic':
        return 'العربية';  // Arabic in Arabic script
      default:
        // Return the original if unknown, but capitalize first letter
        if (languageCode.isEmpty) return languageCode;
        return languageCode[0].toUpperCase() +
               languageCode.substring(1).toLowerCase();
    }
  }

  /// Gets the language code from full language name
  static String getLanguageCode(String languageName) {
    switch (languageName.toLowerCase().trim()) {
      case 'english':
        return 'en';
      case 'sinhala':
        return 'si';
      case 'tamil':
        return 'ta';
      case 'arabic':
        return 'ar';
      default:
        return languageName.toLowerCase();
    }
  }
}
