import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/zemen_theme.dart';
import '../services/ai_engine_service.dart';
import '../utils/glass_effect.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    final prompt = _controller.text;
    _controller.clear();
    
    // Call the offline brain
    Provider.of<AIEngineService>(context, listen: false).askUltimateBrain(prompt);
    
    // Auto-scroll to bottom after a delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiEngine = Provider.of<AIEngineService>(context);

    return Scaffold(
      backgroundColor: ZemenTheme.obsidian,
      appBar: _buildAppBar(context, aiEngine),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(25),
              itemCount: aiEngine.messages.length + (aiEngine.status == EngineStatus.thinking ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < aiEngine.messages.length) {
                  final msg = aiEngine.messages[index];
                  return _buildMessageBubble(msg.text, msg.isUser);
                } else {
                  // Thinking Bubble
                  return _buildMessageBubble(aiEngine.lastResponse.isEmpty ? "..." : aiEngine.lastResponse, false);
                }
              },
            ),
          ),
          _buildInputArea(aiEngine),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AIEngineService aiEngine) {
    return AppBar(
      backgroundColor: ZemenTheme.obsidian,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(LucideIcons.chevronLeft, color: ZemenTheme.satinGold),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Ultimate Professor', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Icon(
                aiEngine.isOnline ? LucideIcons.cloud : LucideIcons.wifiOff,
                size: 16,
                color: aiEngine.isOnline ? Colors.blueAccent : Colors.white54,
              ),
            ],
          ),
          Text(
            aiEngine.status == EngineStatus.thinking ? "AI is thinking..." : (aiEngine.isOnline ? "Online Cloud Engine" : "Offline Neural Engine"),
            style: TextStyle(
              fontSize: 11, 
              color: aiEngine.status == EngineStatus.thinking ? ZemenTheme.satinGold : Colors.white24
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: GlassEffect(
          opacity: isUser ? 0.15 : 0.05,
          borderRadius: 20,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              text,
              style: TextStyle(
                color: isUser ? ZemenTheme.satinGold : Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildInputArea(AIEngineService aiEngine) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: ZemenTheme.obsidian,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GlassEffect(
              borderRadius: 30,
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ask anything...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: aiEngine.status == EngineStatus.thinking ? null : _sendMessage,
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: ZemenTheme.satinGold,
                shape: BoxShape.circle,
                boxShadow: [
                  if (aiEngine.status == EngineStatus.thinking)
                    BoxShadow(color: ZemenTheme.satinGold.withOpacity(0.4), blurRadius: 20),
                ],
              ),
              child: Icon(
                aiEngine.status == EngineStatus.thinking ? LucideIcons.loader2 : LucideIcons.send,
                color: Colors.black,
              ),
            ),
          ).animate(target: aiEngine.status == EngineStatus.thinking ? 1 : 0)
           .shimmer(),
        ],
      ),
    );
  }
}
