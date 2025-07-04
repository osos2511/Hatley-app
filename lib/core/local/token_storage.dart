import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token, String expiration);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isTokenExpired();
  Future<String?> getExpiration();
  Future<void> saveEmail(String email);
  Future<String?> getEmail();
  Future<void> clearDeliveryOffersBox();
}

class TokenStorageImpl implements TokenStorage {
  final SharedPreferences prefs;

  TokenStorageImpl(this.prefs);

  static const _tokenKey = 'auth_token';
  static const _expirationKey = 'token_expiration';
  static const _emailKey = 'user_email';

  @override
  Future<void> saveToken(String token, String expiration) async {
    print("🔐 Saving token...");
    print("📥 Token: $token");
    print("📅 Expiration: $expiration");
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expirationKey, expiration);
    print("✅ Token and expiration saved.");
  }

  @override
  Future<String?> getToken() async {
    final token = prefs.getString(_tokenKey);
    print("🔍 Retrieved token: $token");
    return token;
  }

  @override
  Future<void> clearToken() async {
    print("🧹 Clearing token and expiration...");
    await prefs.remove(_tokenKey);
    await prefs.remove(_expirationKey);
    print("✅ Token and expiration cleared.");
  }

  @override
  Future<bool> isTokenExpired() async {
    final expirationStr = prefs.getString(_expirationKey);
    print("📦 Stored expiration string: $expirationStr");

    if (expirationStr == null) {
      print("⚠️ No expiration date found. Token considered expired.");
      return true;
    }

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null) {
      print("⚠️ Expiration date format is invalid. Token considered expired.");
      return true;
    }

    final now = DateTime.now().toUtc();
    print("🕒 Current UTC time: $now");
    print("📆 Token expires at: $expiration");

    final isExpired = now.isAfter(expiration);
    print(isExpired ? "⛔ Token is expired." : "✅ Token is still valid.");

    return isExpired;
  }

  Future<String?> getExpiration() async {
    final expiration = prefs.getString(_expirationKey);
    print("📦 Retrieved expiration from storage: $expiration");
    return expiration;
  }

  @override
  Future<void> saveEmail(String email) async {
    print("📧 Saving email: $email");
    await prefs.setString(_emailKey, email);
  }

  @override
  Future<String?> getEmail() async {
    final email = prefs.getString(_emailKey);
    print("📨 Retrieved email: $email");
    return email;
  }

  @override
  Future<void> clearDeliveryOffersBox() async {
    // **3. أضف تنفيذ الدالة هنا**
    try {
      final box = await Hive.openBox('delivery_offers');
      await box.clear();
      print("🧹 DEBUG: Hive 'delivery_offers' box cleared successfully.");
    } catch (e) {
      print("❌ DEBUG: Error clearing 'delivery_offers' box: $e");
    }
  }
}
