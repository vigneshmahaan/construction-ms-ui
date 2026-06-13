import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';

class ChatMessage {
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatInterface extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<ChatMessage> initialMessages;
  final bool isReadOnly; // If false, user can type and send

  const ChatInterface({
    super.key,
    required this.title,
    this.subtitle = '',
    required this.initialMessages,
    this.isReadOnly = false,
  });

  @override
  State<ChatInterface> createState() => _ChatInterfaceState();
}

class _ChatInterfaceState extends State<ChatInterface> {
  late List<ChatMessage> _messages;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.initialMessages);
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          senderId: 'me',
          senderName: 'You',
          text: _controller.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
    });
    _controller.clear();
    
    // Scroll to bottom
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
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.title.isNotEmpty) _buildHeader(),
        Expanded(
          child: Container(
            color: const Color(0xFFF0F2F5), // WhatsApp-like background
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
        ),
        if (!widget.isReadOnly) _buildMessageInput(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.group, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (widget.subtitle.isNotEmpty)
                Text(
                  widget.subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final timeStr = "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}";
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFDCF8C6) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(msg.isMe ? 16 : 0),
            bottomRight: Radius.circular(msg.isMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!msg.isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  msg.senderName,
                  style: const TextStyle(
                    color: Color(0xFF075E54),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Text(
              msg.text,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                timeStr,
                style: const TextStyle(color: Colors.black45, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.black54),
              onPressed: () {}, // Mock attachment
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F2F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF128C7E),
              radius: 24,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
