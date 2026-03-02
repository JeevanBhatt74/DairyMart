import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dairymart/features/chat/presentation/view_model/chat_viewmodel.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showTail;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showTail = true,
  });

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: isMe ? 64 : 12,
        right: isMe ? 12 : 64,
        top: 2,
        bottom: showTail ? 8 : 2,
      ),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isMe
                  ? const LinearGradient(
                      colors: [Color(0xFF0084FF), Color(0xFF0099FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isMe
                  ? null
                  : (isDark ? Colors.white.withOpacity(0.08) : const Color(0xFFF0F0F0)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : (showTail ? 4 : 20)),
                bottomRight: Radius.circular(isMe ? (showTail ? 4 : 20) : 20),
              ),
            ),
            child: Text(
              message.content,
              style: GoogleFonts.inter(
                color: isMe ? Colors.white : theme.colorScheme.onSurface,
                fontSize: 15,
                height: 1.35,
              ),
            ),
          ),
          if (showTail)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8, right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(message.timestamp),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: theme.hintColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.id.startsWith('temp_')
                          ? Icons.access_time_rounded
                          : Icons.done_all_rounded,
                      size: 14,
                      color: message.id.startsWith('temp_')
                          ? theme.hintColor.withOpacity(0.5)
                          : const Color(0xFF0084FF),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}

