import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/widgets/message_item.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import 'widgets/message_composer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController get chatController => Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.indigo,
      ),
      body: Column(
        children: [
          Expanded(
            child: chatController.obx(
              (state) => ListView.builder(
                itemCount: state?.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = state![index];
                  return MessageItem(message: message);
                },
              ),
              onEmpty: const Center(
                child: Text("No messages found"),
              ),
              onError: (error) => Center(
                child: Text("Error: $error"),
              ),
              onLoading: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          const MessageComposer()
        ],
      ),
    );
  }
}
