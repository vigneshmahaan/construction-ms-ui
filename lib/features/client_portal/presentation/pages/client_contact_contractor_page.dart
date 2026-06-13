import 'package:flutter/material.dart';
import 'package:construction_ms_ui/core/theme/app_colors.dart';
import 'package:construction_ms_ui/shared/presentation/widgets/chat_interface.dart';

class ClientContactContractorPage extends StatelessWidget {
  const ClientContactContractorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Contact Contractor',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: ChatInterface(
        title: 'Admin Support',
        subtitle: 'Usually replies in a few hours',
        initialMessages: [
          ChatMessage(
            senderId: 'admin',
            senderName: 'Admin',
            text: 'Hello! How can we help you today with your project?',
            timestamp: DateTime.now().subtract(const Duration(hours: 24)),
            isMe: false,
          ),
          ChatMessage(
            senderId: 'me',
            senderName: 'You',
            text: 'I had a question about the tiles for the bathroom.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            isMe: true,
          ),
        ],
      ),
    );
  }
}
