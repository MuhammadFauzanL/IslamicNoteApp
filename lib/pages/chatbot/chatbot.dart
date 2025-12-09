import 'package:flutter/material.dart';
import '../doa/doa_data.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  Doa? cariDoa(String input) {
    input = input.toLowerCase();

    for (final doa in doaList) {
      for (final keyword in doa.keywords) {
        if (input.contains(keyword.toLowerCase())) {
          return doa;
        }
      }
    }
    return null;
  }

  void _sendMessage() {
    String input = _controller.text.trim();
    if (input.isEmpty) return;

    Doa? doa = cariDoa(input);
    String response;

    if (doa != null) {
      response = 'Judul: ${doa.judul}\n'
          'Arab: ${doa.arab}\n'
          'Latin: ${doa.latin}\n'
          'Arti: ${doa.arti}';
    } else {
      response = 'Maaf, aku belum yakin doa mana yang kamu maksud. '
          'Coba jelaskan lagi dengan konteks doa keseharian, misalnya: rumah, hujan, orang tua, dsb.';
    }

    setState(() {
      messages.add({'user': input, 'bot': response});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatbot Doa'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('You: ${msg['user']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Bot: ${msg['bot']}'),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Tanyakan sesuatu...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
