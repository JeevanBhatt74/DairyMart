import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/api/api_client.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/services/storage/user_session_service.dart';
import 'package:dairymart/features/auth/data/models/auth_api_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    sessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _sessionService;

  AuthRemoteDataSource({
    required ApiClient apiClient,
    required UserSessionService sessionService,
  })  : _apiClient = apiClient,
        _sessionService = sessionService;

  // --- LOGIN ---
  Future<AuthApiModel> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        // Backend Response: { success: true, token: "...", data: { ...user... } }
        final token = response.data['token']; 
        final userData = response.data['data']; 
        final role = userData['role'] ?? 'user';
        
        await _sessionService.saveUserSession(token: token, role: role);
        return AuthApiModel.fromJson(userData);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // --- REGISTER ---
  Future<AuthApiModel> register(AuthApiModel user) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: user.toJson(),
      );

      if (response.statusCode == 201) {
        final token = response.data['token'];
        final userData = response.data['data'];
        final role = userData['role'] ?? 'user';

        if (token != null) {
          await _sessionService.saveUserSession(token: token, role: role);
        }
        return AuthApiModel.fromJson(userData);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
  // --- FORGOT PASSWORD ---
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // --- VERIFY OTP ---
  Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.verifyOTP,
        data: {'email': email, 'otp': otp},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }

  // --- RESET PASSWORD ---
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}


