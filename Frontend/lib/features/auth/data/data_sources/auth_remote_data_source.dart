import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../models/auth_api_model.dart';

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
        
        await _sessionService.saveUserSession(token: token);
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
        if (token != null) {
          await _sessionService.saveUserSession(token: token);
        }
        return AuthApiModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message);
    }
  }
}