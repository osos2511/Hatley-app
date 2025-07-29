import 'package:shared_preferences/shared_preferences.dart';

class LanguageStorage {
  static const String _languageKey = 'selected_language';

  // حفظ اللغة المختارة
  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  // استرجاع اللغة المحفوظة
  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey);
  }

  // حذف اللغة المحفوظة (إعادة تعيين)
  static Future<void> clearLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageKey);
  }
}
