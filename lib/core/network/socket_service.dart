import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:dairymart/core/api/api_endpoints.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? socket;

  void connect(String userId) {
    if (socket != null && socket!.connected) return;

    final String serverUrl = ApiEndpoints.baseServerUrl;
    log('Connecting to socket at $serverUrl');

    socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      log('Connected to socket server');
      socket!.emit('join', userId);
    });

    socket!.onDisconnect((_) => log('Disconnected from socket server'));
    socket!.onConnectError((data) => log('Socket connect error: $data'));
    socket!.onError((data) => log('Socket error: $data'));
  }

  void sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
    required String senderType,
  }) {
    if (socket == null || !socket!.connected) {
      log('Cannot send message: socket not connected');
      return;
    }

    socket!.emit('sendMessage', {
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'senderType': senderType,
    });
  }

  void onMessageReceived(Function(dynamic) callback) {
    socket?.on('receiveMessage', (data) {
      log('receiveMessage: $data');
      callback(data);
    });
  }

  void onMessageSent(Function(dynamic) callback) {
    socket?.on('messageSent', (data) {
      log('messageSent confirmation: $data');
      callback(data);
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
