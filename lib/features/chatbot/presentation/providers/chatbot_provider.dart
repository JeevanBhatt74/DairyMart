import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/chatbot/domain/entities/chat_message_entity.dart';
import 'package:dairymart/features/chatbot/domain/usecases/get_chatbot_response_usecase.dart';
import 'package:dairymart/features/chatbot/domain/usecases/reset_chatbot_usecase.dart';
import 'package:dairymart/features/chatbot/data/repositories/chatbot_repository_impl.dart';

// ========== USE CASE PROVIDERS ==========
final getChatbotResponseUseCaseProvider = Provider<GetChatbotResponseUseCase>((ref) {
  return GetChatbotResponseUseCase(ref.read(chatbotRepositoryProvider));
});

final resetChatbotUseCaseProvider = Provider<ResetChatbotUseCase>((ref) {
  return ResetChatbotUseCase(ref.read(chatbotRepositoryProvider));
});

// ========== STATE WRAPPER ==========
class ChatbotState {
  final List<ChatMessageEntity> messages;
  final bool isLoading;

  const ChatbotState({
    this.messages = const [],
    this.isLoading = false,
  });

  ChatbotState copyWith({
    List<ChatMessageEntity>? messages,
    bool? isLoading,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ========== NOTIFIER ==========
class ChatbotNotifier extends StateNotifier<ChatbotState> {
  final GetChatbotResponseUseCase _getChatbotResponseUseCase;
  final ResetChatbotUseCase _resetChatbotUseCase;

  ChatbotNotifier({
    required GetChatbotResponseUseCase getChatbotResponseUseCase,
    required ResetChatbotUseCase resetChatbotUseCase,
  })  : _getChatbotResponseUseCase = getChatbotResponseUseCase,
        _resetChatbotUseCase = resetChatbotUseCase,
        super(const ChatbotState());

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessageEntity(
      text: text.trim(), 
      isUser: true, 
      timestamp: DateTime.now(),
    );
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    final result = await _getChatbotResponseUseCase(text.trim());

    result.fold(
      (failure) {
        final errorMessage = ChatMessageEntity(
          text: "âš ï¸ ${failure.message}", 
          isUser: false, 
          timestamp: DateTime.now(),
        );
        state = state.copyWith(
          messages: [...state.messages, errorMessage],
          isLoading: false,
        );
      },
      (response) {
        final aiMessage = ChatMessageEntity(
          text: response, 
          isUser: false, 
          timestamp: DateTime.now(),
        );
        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isLoading: false,
        );
      },
    );
  }

  void clearChat() {
    _resetChatbotUseCase();
    state = const ChatbotState();
  }
}

// ========== PROVIDERS ==========
final chatbotProvider = StateNotifierProvider<ChatbotNotifier, ChatbotState>((ref) {
  return ChatbotNotifier(
    getChatbotResponseUseCase: ref.read(getChatbotResponseUseCaseProvider),
    resetChatbotUseCase: ref.read(resetChatbotUseCaseProvider),
  );
});


