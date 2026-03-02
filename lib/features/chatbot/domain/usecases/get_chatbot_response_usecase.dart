import 'package:dartz/dartz.dart';
import 'package:dairymart/core/error/failure.dart';
import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/chatbot/domain/repositories/chatbot_repository.dart';

class GetChatbotResponseUseCase extends UseCase<String, String> {
  final ChatbotRepository repository;

  GetChatbotResponseUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String message) async {
    return await repository.sendMessage(message);
  }
}



