import 'package:flutter/material.dart';

import '../services/chat_services.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatServices _chatServices = ChatServices();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _message = [];

  @override
  void initState() {
    super.initState();
    _chatServices.channel.stream.listen((data) {
      String message = data is List<int>
          ? String.fromCharCodes(data)
          : data.toString();
      setState(() {
        _message.add({"message": message, "isSent": false});
      });
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _message.add({"message": _controller.text, "isSent": true});
      });
      _chatServices.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _chatServices.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat now")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _message.length,
              itemBuilder: (context, index) {
                bool isSentByUser = _message[index]["isSent"] ?? false;
                return Align(
                  alignment: isSentByUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSentByUser
                          ? Colors.blueAccent
                          : Colors.yellowAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _message[index]["message"] ?? "",
                      style: TextStyle(
                        color: isSentByUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.grey.shade200),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _sendMessage,
                    icon: const Icon(Icons.send),
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
