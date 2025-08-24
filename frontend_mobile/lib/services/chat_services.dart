import 'package:web_socket_channel/web_socket_channel.dart';

class ChatServices {
  final WebSocketChannel _channel = WebSocketChannel.connect(
    Uri.parse("ws://192.168.100.95:4000"),
  );

  WebSocketChannel get channel => _channel;

  void sendMessage(String message) {
    if (message.isNotEmpty) {
      _channel.sink.add(message);
    }
  }

  void dispose() {
    _channel.sink.close();
  }
}
