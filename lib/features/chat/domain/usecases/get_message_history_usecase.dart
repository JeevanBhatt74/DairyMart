import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/chat/domain/entities/chat_message_entity.dart';
import 'package:dairymart/features/chat/domain/repositories/chat_repository.dart';

class GetMessageHistoryUseCase extends UseCase<List<ChatMessageEntity>, String> {
  final ChatRepository repository;

  GetMessageHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> call(String userId) async {
    return await repository.getMessageHistory(userId);
  }
}


