import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dairymart/features/chat/domain/repositories/chat_repository.dart';
import 'package:dairymart/features/chat/data/datasources/remote/chat_remote_data_source.dart';

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(Dio()); // Should ideally use a shared Dio client
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(ref.read(chatRemoteDataSourceProvider));
});

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getMessageHistory(String userId) async {
    try {
      final messages = await _remoteDataSource.getMessageHistory(userId);
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markAsRead(String userId) async {
    try {
      final result = await _remoteDataSource.markAsRead(userId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




