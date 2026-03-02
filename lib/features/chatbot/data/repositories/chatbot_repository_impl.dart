import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:dairymart/features/chatbot/data/datasources/remote/chatbot_remote_data_source.dart';

final chatbotRemoteDataSourceProvider = Provider<ChatbotRemoteDataSource>((ref) {
  return ChatbotRemoteDataSourceImpl(Dio());
});

final chatbotRepositoryProvider = Provider<ChatbotRepository>((ref) {
  return ChatbotRepositoryImpl(ref.read(chatbotRemoteDataSourceProvider));
});

class ChatbotRepositoryImpl implements ChatbotRepository {
  final ChatbotRemoteDataSource _remoteDataSource;

  ChatbotRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> sendMessage(String message) async {
    try {
      final response = await _remoteDataSource.sendMessage(message);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  void resetChat() {
    _remoteDataSource.resetChat();
  }
}





