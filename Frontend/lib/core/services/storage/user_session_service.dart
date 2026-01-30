import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userSessionServiceProvider = Provider<UserSessionService>((ref) => UserSessionService());

class UserSessionService {
  final _secureStorage = const FlutterSecureStorage();
  static const String _keyToken = 'auth_token';
  
  // Save Token & User Data
  Future<void> saveUserSession({required String token}) async {
    await _secureStorage.write(key: _keyToken, value: token);
  }

  // Get Token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  // Logout
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _keyToken);
  }
}