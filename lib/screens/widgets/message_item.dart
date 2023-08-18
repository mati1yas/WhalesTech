import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/chat_controller.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  const MessageItem({super.key, required this.message});
  bool get isMyMessage => message.authorId == Get.find<AuthController>().userId;

  @override
  Widget build(BuildContext context) {
    final chatController = Get.find<ChatController>();
    final repliedMessage = message.repliedMessage;

    return Dismissible(
      key: ValueKey(message.createdAt),
      direction: DismissDirection.endToStart, // Only swipe from right to left
      background: Container(
        color: Colors.blue,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Icon(
              Icons.reply,
              color: Colors.white,
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.reply,
              color: Colors.indigo,
            ),
          ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          chatController.startReplying(message);
          return false;
        }
        return true;
      },
      onDismissed: (direction) {},

      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: 6.0,
                ),
                child: Text(
                  message.authorName,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
            Row(
              mainAxisAlignment:
                  isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage ? Colors.indigo : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (repliedMessage != null) ...[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            color: Colors.indigo,
                            child: Row(
                              children: [
                                Container(
                                  width: 4.0,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        repliedMessage.authorName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        repliedMessage.text,
                                        maxLines:
                                            2, // Set the maximum number of lines
                                        overflow: TextOverflow
                                            .ellipsis, // Handle overflow with ellipsis
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isMyMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
