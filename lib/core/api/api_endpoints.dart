
class ApiEndpoints {
  ApiEndpoints._();

  // ========== MULTI-ENVIRONMENT IP CONFIGURATION ==========
  // Your PC's WiFi IP (as of now)
  
  static String get ipAddress {
    return '10.169.186.216'; // Wi-Fi hotspot IP for physical device
  }

  static const String _port = '5000'; // Backend port from config/index.ts
  
  // Base URL: Matches your Backend 'index.ts' -> app.use('/api/v1/users', ...)
  static String get baseServerUrl => 'http://$ipAddress:$_port';
  static String get baseUrl => '$baseServerUrl/api/v1/users';
  static String get baseApiUrl => '$baseServerUrl/api';

  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // ========== AUTH ROUTES ==========
  static String get login => '$baseUrl/login';
  static String get register => '$baseUrl/register';
  static String get forgotPassword => '$baseUrl/forgot-password';
  static String get verifyOTP => '$baseUrl/verify-otp';
  static String get resetPassword => '$baseUrl/reset-password';

  // ========== PROFILE ROUTES ==========
  static String get updateProfile => '$baseUrl/update-profile';
  static String get uploadProfileImage => '$baseUrl/upload-profile-picture';
  static String get profile => '$baseUrl/profile';

  // ========== PRODUCT ROUTES ==========
  static String get products => '$baseApiUrl/products';

  // ========== CART ROUTES ==========
  static String get cart => '$baseApiUrl/cart';

  // ========== FAVORITE ROUTES ==========
  static String get favorites => '$baseApiUrl/favorites';

  // ========== ORDER ROUTES ==========
  static String get orders => '$baseApiUrl/orders';

  // ========== CHAT ROUTES ==========
  static String get chatMessages => '$baseApiUrl/chat/messages';
  static String get conversations => '$baseApiUrl/chat/conversations';
  static String get markAsRead => '$baseApiUrl/chat/read';

  // ========== LOYALTY ROUTES ==========
  static String get loyaltyPoints => '$baseApiUrl/loyalty/points';
}
