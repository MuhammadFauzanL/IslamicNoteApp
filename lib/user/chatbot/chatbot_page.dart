import 'package:flutter/material.dart';
import '../doa/models/doa.dart';
import 'chatbot_service.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final ChatbotService _service = ChatbotService();
  final TextEditingController _controller = TextEditingController();

  final List<_ChatMessage> messages = [];

  void _sendMessage() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    final Doa? doa = _service.findDoa(input);

    setState(() {
      messages.add(
        _ChatMessage(
          userText: input,
          botText: doa != null
              ? _service.buildResponse(doa)
              : _fallbackMessage(),
        ),
      );
      _controller.clear();
    });
  }

  String _fallbackMessage() {
    return 'Aku belum menemukan doa yang sesuai.\n\n'
        'Coba gunakan kata kunci seperti:\n'
        '• hujan\n'
        '• rumah\n'
        '• orang tua\n'
        '• tidur\n'
        '• kesehatan';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot Doa')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (_, index) {
                final msg = messages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bubble(msg.userText, true),
                    const SizedBox(height: 6),
                    _bubble(msg.botText, false),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
          ),
          _inputBar(),
        ],
      ),
    );
  }

  Widget _bubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _inputBar() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Tanyakan doa...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String userText;
  final String botText;

  _ChatMessage({required this.userText, required this.botText});
}
