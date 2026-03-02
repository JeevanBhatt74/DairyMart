import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dairymart/features/notifications/presentation/providers/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: isDark ? Colors.grey[600] : Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: isDark ? Colors.white12 : null),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  tileColor: notification.isRead
                      ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                      : (isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.withOpacity(0.05)),
                  leading: CircleAvatar(
                    backgroundColor: isDark ? Colors.blue[900] : Colors.blue[100],
                    child: Icon(
                      notification.type == 'order' ? Icons.shopping_bag : Icons.notifications,
                      color: Colors.blue,
                    ),
                  ),
                  title: Text(
                    notification.title,
                    style: TextStyle(
                      fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.message, style: TextStyle(color: isDark ? Colors.grey[400] : null)),
                      const SizedBox(height: 4),
                      Text(
                        '${notification.createdAt.day}/${notification.createdAt.month}/${notification.createdAt.year}',
                        style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[600] : Colors.grey),
                      ),
                    ],
                  ),
                  onTap: () {
                    if (!notification.isRead) {
                      ref.read(notificationProvider.notifier).markAsRead(notification.id);
                    }
                  },
                );
              },
            ),
    );
  }
}

