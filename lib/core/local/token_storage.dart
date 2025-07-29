import 'package:shared_preferences/shared_preferences.dart';
import 'package:hatley/core/logger.dart';

abstract class TokenStorage {
  Future<void> saveToken(String token, String expiration);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> isTokenExpired();
  Future<String?> getExpiration();
  Future<void> saveEmail(String email);
  Future<String?> getEmail();
}

class TokenStorageImpl implements TokenStorage {
  final SharedPreferences prefs;

  TokenStorageImpl(this.prefs);

  static const _tokenKey = 'auth_token';
  static const _expirationKey = 'token_expiration';
  static const _emailKey = 'user_email';

  @override
  Future<void> saveToken(String token, String expiration) async {
    AppLogger.debug("Saving token...");
    AppLogger.debug("Token: ***");
    AppLogger.debug("Expiration: $expiration");
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_expirationKey, expiration);
    AppLogger.debug("Token and expiration saved.");
  }

  @override
  Future<String?> getToken() async {
    final token = prefs.getString(_tokenKey);
    AppLogger.debug("Retrieved token: ${token != null ? '***' : 'null'}");
    return token;
  }

  @override
  Future<void> clearToken() async {
    AppLogger.debug("Clearing token and expiration...");
    await prefs.remove(_tokenKey);
    await prefs.remove(_expirationKey);
    AppLogger.debug("Token and expiration cleared.");
  }

  @override
  Future<bool> isTokenExpired() async {
    final expirationStr = prefs.getString(_expirationKey);
    AppLogger.debug("Stored expiration string: $expirationStr");

    if (expirationStr == null) {
      AppLogger.warning("No expiration date found. Token considered expired.");
      return true;
    }

    final expiration = DateTime.tryParse(expirationStr);
    if (expiration == null) {
      AppLogger.warning(
        "Expiration date format is invalid. Token considered expired.",
      );
      return true;
    }

    final now = DateTime.now().toUtc();
    AppLogger.debug("Current UTC time: $now");
    AppLogger.debug("Token expires at: $expiration");

    final isExpired = now.isAfter(expiration);
    AppLogger.debug(isExpired ? "Token is expired." : "Token is still valid.");

    return isExpired;
  }

  @override
  Future<String?> getExpiration() async {
    final expiration = prefs.getString(_expirationKey);
    AppLogger.debug("Retrieved expiration from storage: $expiration");
    return expiration;
  }

  @override
  Future<void> saveEmail(String email) async {
    AppLogger.debug("Saving email: $email");
    await prefs.setString(_emailKey, email);
  }

  @override
  Future<String?> getEmail() async {
    final email = prefs.getString(_emailKey);
    AppLogger.debug("Retrieved email: $email");
    return email;
  }
}
