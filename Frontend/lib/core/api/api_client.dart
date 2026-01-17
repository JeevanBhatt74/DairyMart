import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_endpoints.dart';
import '../services/storage/user_session_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(userSessionServiceProvider));
});

class ApiClient {
  late final Dio _dio;
  final UserSessionService _sessionService;

  ApiClient(this._sessionService) {
    _dio = Dio(
      BaseOptions(
        connectTimeout: ApiEndpoints.connectionTimeout,
        receiveTimeout: ApiEndpoints.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 1. Auth Interceptor: Adds Token to Header
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _sessionService.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          await _sessionService.clearSession();
        }
        return handler.next(e);
      },
    ));

    // 2. Logger: Helps you see errors in the Debug Console
    if (kDebugMode) {
      _dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
      ));
    }
  }

  // Exposed Methods
  Future<Response> post(String path, {dynamic data}) async => 
      _dio.post(path, data: data);

  // Test connectivity to backend
  Future<bool> testConnection() async {
    try {
      // Test the root endpoint which always returns 200
      final response = await _dio.get('http://${ApiEndpoints.ipAddress}:3000/');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}