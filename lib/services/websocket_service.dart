import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// This provider is now defined in providers.dart

class WebSocketService {
  final Ref ref;
  WebSocketChannel? _channel;
  int _reconnectAttempts = 0;

  Function(String)? onMessage;
  Function(String)? onStatus;

  WebSocketService(this.ref);

  void connect() {
    print('WebSocketService: Attempting to connect...');
    _setStatus("Connecting");
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.150.74:8080/ws'));
      print('WebSocketService: WebSocket channel created');

      _channel!.stream.listen(
        (data) {
          print('WebSocketService: Received data: ${data.toString().substring(0, 50)}...');
          _setStatus("Connected");
          _reconnectAttempts = 0;
          onMessage?.call(data);
        },
        onError: (error) {
          print('WebSocketService: Error: $error');
          _handleDisconnect();
        },
        onDone: () {
          print('WebSocketService: Connection closed');
          _handleDisconnect();
        },
        cancelOnError: true,
      );
      print('WebSocketService: Stream listener set up');
    } catch (error) {
      print('WebSocketService: Failed to connect: $error');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    print('WebSocketService: Handling disconnect, reconnect attempts: $_reconnectAttempts');
    _setStatus("Disconnected");
    reconnect();
  }

  void reconnect() {
    _reconnectAttempts++;
    final waitTime = min(30, pow(2, _reconnectAttempts).toInt());
    _setStatus("Reconnecting in $waitTime sec...");
    Future.delayed(Duration(seconds: waitTime), () => connect());
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _setStatus("Disconnected");
  }

  void _setStatus(String status) => onStatus?.call(status);
}
