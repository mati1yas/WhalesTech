import 'package:flutter/material.dart';
import 'package:flutter_chat_app/controllers/chat_controller.dart';
import 'package:get/get.dart';

class MessageComposer extends StatefulWidget {
  const MessageComposer({super.key});

  @override
  State<MessageComposer> createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController _textEditingController = TextEditingController();

  ChatController get chatController => Get.find();
  bool isComposingMessage = false;

  @override
  Widget build(BuildContext context) {
    final repliedMessage = chatController.repliedMessage.value;

    return Column(
      children: [
        Obx(() {
          final repliedMessage = chatController.repliedMessage.value;
          if (repliedMessage != null) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(repliedMessage.text),
                  IconButton(
                    onPressed: () {
                      chatController.cancelReplying();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ],
              ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Row(
            children: [
              const SizedBox(width: 18.0),
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  onChanged: (value) {
                    setState(() {
                      isComposingMessage = value.isNotEmpty;
                    });
                  },
                  decoration: const InputDecoration.collapsed(
                    hintText: "Send a message",
                  ),
                ),
              ),
              IconButton(
                onPressed: isComposingMessage
                    ? () {
                        chatController.sendMessage(_textEditingController.text);
                        _textEditingController.clear();
                        setState(() {
                          isComposingMessage = false;
                        });
                      }
                    : null,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
