import 'package:dio/dio.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/features/chat/data/models/chat_message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatMessageModel>> getMessageHistory(String userId);
  Future<bool> markAsRead(String userId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ChatMessageModel>> getMessageHistory(String userId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.chatMessages}/$userId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ChatMessageModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> markAsRead(String userId) async {
    try {
      final response = await _dio.put('${ApiEndpoints.markAsRead}/$userId');
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}



