import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/notifications/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase extends UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await repository.markAsRead(id);
  }
}


