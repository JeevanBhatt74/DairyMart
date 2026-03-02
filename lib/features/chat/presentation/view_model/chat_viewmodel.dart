import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/core/network/socket_service.dart';
import 'package:dairymart/features/chat/domain/usecases/get_message_history_usecase.dart';
import 'package:dairymart/features/chat/domain/usecases/mark_messages_as_read_usecase.dart';
import 'package:dairymart/features/chat/data/repositories/chat_repository.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// Message Model for UI (Can keep it or use entity directly, here we adapt entity)
class MessageModel {
  final String id;
  final String content;
  final String senderId;
  final String senderType;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderType,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['sender'] ?? '',
      senderType: json['senderType'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

// State class for Chat
class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// ========== USE CASE PROVIDERS ==========
final getMessageHistoryUseCaseProvider = Provider<GetMessageHistoryUseCase>((ref) {
  return GetMessageHistoryUseCase(ref.read(chatRepositoryProvider));
});

final markMessagesAsReadUseCaseProvider = Provider<MarkMessagesAsReadUseCase>((ref) {
  return MarkMessagesAsReadUseCase(ref.read(chatRepositoryProvider));
});

// ========== NOTIFIER ==========
class ChatNotifier extends StateNotifier<ChatState> {
  final GetMessageHistoryUseCase _getMessageHistoryUseCase;
  final MarkMessagesAsReadUseCase _markMessagesAsReadUseCase;
  final SocketService _socketService = SocketService();
  final String currentUserId;

  ChatNotifier({
    required GetMessageHistoryUseCase getMessageHistoryUseCase,
    required MarkMessagesAsReadUseCase markMessagesAsReadUseCase,
    required this.currentUserId,
  })  : _getMessageHistoryUseCase = getMessageHistoryUseCase,
        _markMessagesAsReadUseCase = markMessagesAsReadUseCase,
        super(ChatState()) {
    _init();
  }

  void _init() {
    _socketService.connect(currentUserId);

    _socketService.onMessageReceived((data) {
      log('receiveMessage event data: $data');
      final msg = MessageModel.fromJson(data);
      if (!state.messages.any((m) => m.id == msg.id) && msg.id.isNotEmpty) {
        state = state.copyWith(messages: [...state.messages, msg]);
      }
    });

    _socketService.onMessageSent((data) {
      log('messageSent event data: $data');
      final msg = MessageModel.fromJson(data);
      final updated = state.messages.map((m) {
        if (m.id.startsWith('temp_') && m.content == msg.content) {
          return msg;
        }
        return m;
      }).toList();
      state = state.copyWith(messages: updated);
    });

    fetchMessages();
  }

  Future<void> fetchMessages() async {
    state = state.copyWith(isLoading: true);
    final result = await _getMessageHistoryUseCase(currentUserId);
    
    result.fold(
      (failure) => state = state.copyWith(isLoading: false, error: failure.message),
      (entities) {
        final messages = entities.map((e) => MessageModel(
          id: e.id,
          content: e.message,
          senderId: e.senderId,
          senderType: e.senderId == currentUserId ? 'user' : 'admin',
          timestamp: e.timestamp,
        )).toList();
        state = state.copyWith(messages: messages, isLoading: false);
      },
    );
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;

    final tempMessage = MessageModel(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      content: content.trim(),
      senderId: currentUserId,
      senderType: 'user',
      timestamp: DateTime.now(),
    );
    state = state.copyWith(messages: [...state.messages, tempMessage]);

    _socketService.sendMessage(
      senderId: currentUserId,
      receiverId: 'admin',
      content: content.trim(),
      senderType: 'user',
    );
  }

  Future<void> markAsRead() async {
    await _markMessagesAsReadUseCase(currentUserId);
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}

// ========== PROVIDERS ==========
final chatProvider = StateNotifierProvider.family<ChatNotifier, ChatState, String>((ref, userId) {
  return ChatNotifier(
    getMessageHistoryUseCase: ref.read(getMessageHistoryUseCaseProvider),
    markMessagesAsReadUseCase: ref.read(markMessagesAsReadUseCaseProvider),
    currentUserId: userId,
  );
});


