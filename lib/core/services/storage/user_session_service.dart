import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final userSessionServiceProvider = Provider<UserSessionService>((ref) => UserSessionService());

class UserSessionService {
  final _secureStorage = const FlutterSecureStorage();
  static const String _keyToken = 'auth_token';
  static const String _keyRole = 'user_role';
  
  // Save Token & User Data
  Future<void> saveUserSession({required String token, required String role}) async {
    await _secureStorage.write(key: _keyToken, value: token);
    await _secureStorage.write(key: _keyRole, value: role);
  }

  // Get Token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: _keyToken);
  }

  // Get Role
  Future<String?> getRole() async {
    return await _secureStorage.read(key: _keyRole);
  }

  // Logout
  Future<void> clearSession() async {
    await _secureStorage.delete(key: _keyToken);
    await _secureStorage.delete(key: _keyRole);
  }
}