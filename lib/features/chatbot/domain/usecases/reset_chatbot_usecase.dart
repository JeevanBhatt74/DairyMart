import 'package:dairymart/core/usecases/usecase.dart';
import 'package:dairymart/features/chatbot/domain/repositories/chatbot_repository.dart';

class ResetChatbotUseCase {
  final ChatbotRepository repository;

  ResetChatbotUseCase(this.repository);

  void call() {
    repository.resetChat();
  }
}



