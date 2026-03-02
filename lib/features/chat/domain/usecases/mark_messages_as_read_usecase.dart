import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/chat/domain/repositories/chat_repository.dart';

class MarkMessagesAsReadUseCase extends UseCase<bool, String> {
  final ChatRepository repository;

  MarkMessagesAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String userId) async {
    return await repository.markAsRead(userId);
  }
}


