import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/notifications/domain/entities/notification_entity.dart';
import 'package:dairymart/features/notifications/domain/repositories/notification_repository.dart';

class GetNotificationsUseCase extends UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) async {
    return await repository.getNotifications();
  }
}


