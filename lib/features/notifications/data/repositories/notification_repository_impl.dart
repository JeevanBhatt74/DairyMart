import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/features/notifications/domain/entities/notification_entity.dart';
import 'package:dairymart/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dairymart/features/notifications/data/datasources/remote/notification_remote_data_source.dart';

final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  return NotificationRemoteDataSourceImpl(Dio());
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref.read(notificationRemoteDataSourceProvider));
});

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await _remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _remoteDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}




