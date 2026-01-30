
class ApiEndpoints {
  ApiEndpoints._();

  // ========== MULTI-ENVIRONMENT IP CONFIGURATION ==========
  // Your PC's WiFi IP (as of now)
  
  static String get ipAddress {
    return '10.181.70.216'; // Your current WiFi IP
  }

  static const String _port = '5000'; // Backend port from config/index.ts
  
  // Base URL: Matches your Backend 'index.ts' -> app.use('/api/v1/users', ...)
  static String get baseUrl => 'http://$ipAddress:$_port/api/v1/users';

  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // ========== AUTH ROUTES ==========
  static String get login => '$baseUrl/login';
  static String get register => '$baseUrl/register';

  // ========== PROFILE ROUTES ==========
  static String get updateProfile => '$baseUrl/update-profile';
  static String get uploadProfileImage => '$baseUrl/upload-profile-picture';
}
