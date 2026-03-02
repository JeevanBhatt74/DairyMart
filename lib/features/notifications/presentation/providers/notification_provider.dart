import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dairymart/features/notifications/domain/entities/notification_entity.dart';
import 'package:dairymart/features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'package:dairymart/features/notifications/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:dairymart/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:dairymart/features/notifications/data/models/notification_model.dart';
import 'package:dairymart/core/api/api_endpoints.dart';
import 'package:dairymart/core/usecases/usecase.dart';

// ========== USE CASE PROVIDERS ==========
final getNotificationsUseCaseProvider = Provider<GetNotificationsUseCase>((ref) {
  return GetNotificationsUseCase(ref.read(notificationRepositoryProvider));
});

final markNotificationAsReadUseCaseProvider = Provider<MarkNotificationAsReadUseCase>((ref) {
  return MarkNotificationAsReadUseCase(ref.read(notificationRepositoryProvider));
});

// ========== NOTIFIER ==========
class NotificationNotifier extends StateNotifier<List<NotificationEntity>> {
  final GetNotificationsUseCase _getNotificationsUseCase;
  final MarkNotificationAsReadUseCase _markNotificationAsReadUseCase;
  IO.Socket? socket;
  final String _socketUrl = "http://${ApiEndpoints.ipAddress}:5000";

  NotificationNotifier({
    required GetNotificationsUseCase getNotificationsUseCase,
    required MarkNotificationAsReadUseCase markNotificationAsReadUseCase,
  })  : _getNotificationsUseCase = getNotificationsUseCase,
        _markNotificationAsReadUseCase = markNotificationAsReadUseCase,
        super([]);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null) {
      fetchNotifications();

      socket = IO.io(_socketUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket!.connect();

      socket!.onConnect((_) {
        socket!.emit('join', userId);
      });

      socket!.on('notification', (data) {
        final newNotification = NotificationModel.fromJson(data);
        state = [newNotification, ...state];
      });
    }
  }

  Future<void> fetchNotifications() async {
    final result = await _getNotificationsUseCase(NoParams());
    
    result.fold(
      (failure) => print("Error fetching notifications mobile: ${failure.message}"),
      (notifications) => state = notifications,
    );
  }

  Future<void> markAsRead(String id) async {
    final result = await _markNotificationAsReadUseCase(id);

    result.fold(
      (failure) => print("Error marking notification read mobile: ${failure.message}"),
      (_) {
        state = [
          for (final n in state)
            if (n.id == id) 
              NotificationModel(
                id: n.id,
                title: n.title,
                message: n.message,
                type: n.type,
                isRead: true,
                createdAt: n.createdAt,
              ) 
            else n
        ];
      },
    );
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }
}

// ========== PROVIDERS ==========
final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationEntity>>((ref) {
  return NotificationNotifier(
    getNotificationsUseCase: ref.read(getNotificationsUseCaseProvider),
    markNotificationAsReadUseCase: ref.read(markNotificationAsReadUseCaseProvider),
  );
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).where((n) => !n.isRead).length;
});


