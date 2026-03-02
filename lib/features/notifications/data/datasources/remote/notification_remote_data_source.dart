import 'package:dio/dio.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/notifications/data/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio;
  final String _baseUrl = "http://${ApiEndpoints.ipAddress}:5000/api";

  NotificationRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) throw Exception("No token found");

    try {
      final response = await _dio.get(
        "$_baseUrl/notifications",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((n) => NotificationModel.fromJson(n)).toList();
      }
      throw Exception(response.data['message'] ?? "Failed to fetch notifications");
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    if (token == null) throw Exception("No token found");

    try {
      final response = await _dio.put(
        "$_baseUrl/notifications/$id/read",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data['success'] != true) {
        throw Exception(response.data['message'] ?? "Failed to mark as read");
      }
    } catch (e) {
      rethrow;
    }
  }
}



