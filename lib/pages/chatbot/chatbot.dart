import 'package:flutter/material.dart';
import '../../services/chat_api.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  late final String _sessionId;

  // PRIMARY COLORS (same for both themes)
  static const Color primaryColor = Color(0xFF00ADB5);
  static const Color orangeColor = Color(0xFFFF9800);

  final List<Map<String, dynamic>> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _sessionId = "session_${DateTime.now().millisecondsSinceEpoch}";
    _initGreeting();
  }

  void _initGreeting() {
    messages.clear();
    messages.add({
      "role": "bot",
      "text": "Wa'alaikumsalam 😊\n\nSaya Asisten Islami. Silakan tanyakan doa atau hadis yang kamu butuhkan.",
      "examples": [
        "doa sebelum makan",
        "hadis tentang sabar", 
        "doa naik kendaraan"
      ]
    });
  }

  void _handleQuickAction(String action) {
    if (isLoading) return;

    switch (action) {
      case "doa":
        _sendMessage(query: "lihat doa", label: "📖 Lihat Doa");
        break;
      case "hadis":
        _sendMessage(query: "lihat hadis", label: "📜 Lihat Hadis");
        break;
      case "mulai":
        _sendMessage(query: "halo", label: "👋 Mulai");
        break;
    }
  }

  void _handleExampleClick(String example) {
    if (isLoading) return;
    _sendMessage(query: example, label: example);
  }

  Future<void> _sendMessage({
    String? query,
    String? label,
  }) async {
    if (isLoading) return;

    final text = query ?? _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      isLoading = true;
      messages.add({
        "role": "user",
        "text": label ?? text,
      });
      _controller.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    try {
      final response = await ChatApi.sendMessage(text, _sessionId);

      setState(() {
        isLoading = false;

        final status = response["status"];
        final msg = response["message"] ?? "";
        final examples = response["examples"];
        final suggestions = response["suggestions"];

        if (status == "OK" && response["data"] != null) {
          final List results = response["data"];
          final summary = response["summary"];

          if (msg.isNotEmpty) {
            messages.add({
              "role": "bot",
              "text": msg,
              "type": "info"
            });
          }

          for (var item in results) {
            final d = item["data"];
            final sourceType = d["source_type"] ?? "";
            
            messages.add({
              "role": "bot",
              "type": "card",
              "sourceType": sourceType,
              "data": d,
            });
          }

          if (summary != null && results.length > 1) {
            final total = summary["total"] ?? 0;
            final doaCount = summary["doa_count"] ?? 0;
            final hadisCount = summary["hadis_count"] ?? 0;
            
            if (total > results.length) {
              messages.add({
                "role": "bot",
                "text": "Menampilkan ${results.length} dari $total hasil (${doaCount} doa, ${hadisCount} hadis)",
                "type": "info"
              });
            }
          }
        }
        else if (status == "ASK") {
          messages.add({
            "role": "bot",
            "text": msg,
            "examples": examples,
            "suggestions": suggestions,
          });
        }
        else {
          messages.add({
            "role": "bot",
            "text": msg.isNotEmpty ? msg : "Maaf, terjadi kesalahan.",
          });
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        messages.add({
          "role": "bot",
          "text": "Maaf, server tidak merespons. Pastikan koneksi internet stabil.",
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Dynamic colors based on theme
    final bgColor = isDark ? const Color(0xFF222831) : const Color(0xFFEEEEEE);
    final cardColor = isDark ? const Color(0xFF393E46) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtleTextColor = isDark ? Colors.grey : const Color(0xFF616161);
    final inputBgColor = isDark ? const Color(0xFF393E46) : const Color(0xFFF5F5F5);
    final borderColor = isDark ? const Color(0xFF4A5057) : const Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Asisten Islami"),
        backgroundColor: isDark ? const Color(0xFF393E46) : primaryColor,
        foregroundColor: Colors.white,
        elevation: isDark ? 0 : 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (_, i) => _buildMessage(messages[i], isDark, cardColor, textColor, subtleTextColor),
            ),
          ),
          if (isLoading)
            LinearProgressIndicator(
              color: primaryColor,
              minHeight: 3,
              backgroundColor: borderColor,
            ),
          _quickActions(isDark, cardColor),
          _inputBar(isDark, cardColor, textColor, inputBgColor, borderColor),
        ],
      ),
    );
  }

  Widget _buildMessage(Map<String, dynamic> message, bool isDark, Color cardColor, Color textColor, Color subtleTextColor) {
    final isUser = message["role"] == "user";
    final type = message["type"];

    if (type == "info") {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF393E46).withOpacity(0.5) : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            message["text"] ?? "",
            style: TextStyle(
              color: subtleTextColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (type == "card") {
      return _buildResultCard(message, isDark, cardColor, textColor, subtleTextColor);
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? primaryColor : cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message["text"] ?? "",
              style: TextStyle(
                color: isUser ? Colors.white : textColor,
                fontSize: 15,
              ),
            ),
            
            if (message["examples"] != null) ...[
              const SizedBox(height: 12),
              ...((message["examples"] as List).map((ex) => 
                _buildExampleChip(ex.toString(), isDark)
              ).toList()),
            ],
            
            if (message["suggestions"] != null) ...[
              const SizedBox(height: 8),
              ...((message["suggestions"] as List).map((sug) => 
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "💡 $sug",
                    style: TextStyle(
                      color: isUser ? Colors.white70 : subtleTextColor,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              ).toList()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> message, bool isDark, Color cardColor, Color textColor, Color subtleTextColor) {
    final data = message["data"];
    final sourceType = message["sourceType"];
    final isDoa = sourceType == "doa";

    final title = data["judul"] ?? data["tema"] ?? "";
    final arab = data["arab"] ?? "";
    final latin = data["latin"] ?? "";
    final arti = data["arti"] ?? "";
    final sumber = data["sumber"] ?? "";

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDoa ? primaryColor.withOpacity(isDark ? 0.5 : 0.3) : orangeColor.withOpacity(isDark ? 0.5 : 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (isDoa ? primaryColor : orangeColor).withOpacity(isDark ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isDoa ? "📖" : "📜",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDoa ? primaryColor : orangeColor,
                      ),
                    ),
                    if (sumber.isNotEmpty)
                      Text(
                        sumber,
                        style: TextStyle(
                          fontSize: 11,
                          color: subtleTextColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          Divider(height: 1, color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
          const SizedBox(height: 12),
          
          if (arab.isNotEmpty) ...[
            Text(
              arab,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                height: 1.8,
                color: textColor,
                fontFamily: 'Arabic',
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
          ],
          
          if (latin.isNotEmpty) ...[
            Text(
              latin,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: subtleTextColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
          
          if (arti.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF222831).withOpacity(0.5) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '"$arti"',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: textColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExampleChip(String example, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: InkWell(
        onTap: () => _handleExampleClick(example),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: primaryColor.withOpacity(isDark ? 0.5 : 0.3)),
          ),
          child: Text(
            example,
            style: const TextStyle(
              color: primaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _quickActions(bool isDark, Color cardColor) {
    return Container(
      color: cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _actionBtn("📖 Lihat Doa", "doa", isDark),
          const SizedBox(width: 8),
          _actionBtn("📜 Lihat Hadis", "hadis", isDark),
          const SizedBox(width: 8),
          _actionBtn("👋 Mulai", "mulai", isDark),
        ],
      ),
    );
  }

  Widget _actionBtn(String label, String action, bool isDark) {
    return Expanded(
      child: OutlinedButton(
        onPressed: isLoading ? null : () => _handleQuickAction(action),
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor.withOpacity(isDark ? 0.5 : 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _inputBar(bool isDark, Color cardColor, Color textColor, Color inputBgColor, Color borderColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                enabled: !isLoading,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  hintText: "Ketik pesan...",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey : const Color(0xFF9E9E9E),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: inputBgColor,
                ),
                onSubmitted: (_) => _sendMessage(),
                textInputAction: TextInputAction.send,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: isLoading ? null : () => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}