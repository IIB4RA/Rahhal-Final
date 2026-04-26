import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/aiAssistant_model.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});
  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  Future<void> _sendMessage() async {
    final String userText = _controller.text.trim();
    if (userText.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final url = Uri.parse('https://rahhal-final-production.up.railway.app/api/planner/generate/');
      List<Map<String, String>> historyPayload = _messages
          .take(_messages.length - 1)
          .map((m) =>
              {"role": m.isUser ? "user" : "assistant", "content": m.text})
          .toList();
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'prompt': userText, 'history': historyPayload}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['success'] == true) {
          String aiResponse = data['plan']['chat_reply'] ?? "";
          List citations = data['plan']['citations'] ?? [];
          if (citations.isNotEmpty) {
            aiResponse += "\n\n---\n**Sources:**\n";
            for (var c in citations) {
              aiResponse += "* [${c['title']}](${c['url']})\n";
            }
          }
          setState(() {
            _messages.add(ChatMessage(text: aiResponse, isUser: false));
          });
        }
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(text: "⚠️ Connection Error", isUser: false));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
      }
    });
  }

  Future<void> _onLinkTap(String? url) async {
    if (url != null) {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri))
        await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back, color: Color(0xFF8B2323), size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Rahhal ChatBot",
          style: TextStyle(
            color: Color(0xFF8B2323),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  _buildChatBubble(_messages[index]),
            ),
          ),
          if (_isLoading)
            const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(color: Color(0xFF8B2323))),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message) {
    bool isUser = message.isUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF702632) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: isUser
            ? Text(message.text,
                style: const TextStyle(color: Colors.white, fontSize: 15))
            : MarkdownBody(
                data: message.text,
                onTapLink: (text, href, title) => _onLinkTap(href),
                styleSheet:
                    MarkdownStyleSheet(p: const TextStyle(fontSize: 15)),
              ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
              child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                      hintText: "Type...",
                      filled: true,
                      fillColor: Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none)))),
          IconButton(
              onPressed: _isLoading ? null : _sendMessage,
              icon: const Icon(Icons.send, color: Color(0xFF702632))),
        ],
      ),
    );
  }
}
