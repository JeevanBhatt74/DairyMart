class ApiConstants {
  // For Android Emulator use: 10.0.2.2
  // For Real Device use your PC's IP: e.g., 192.168.1.10
  static const String baseUrl = "http://10.0.2.2:3000/api/v1"; 
  static const String login = "$baseUrl/users/login";
  static const String register = "$baseUrl/users/register";
}