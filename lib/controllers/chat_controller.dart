// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_app/data_provider/messages_remote.dart';
import 'auth_controller.dart';

class ChatController extends GetxController
    with StateMixin<List<MessageModel>> {
  final MessageRemoteDataProvider messageRemoteDataProvider;

  StreamSubscription? _subscription;
  ChatController({
    required this.messageRemoteDataProvider,
  });

  @override
  void onInit() {
    super.onInit();
    initSubscription();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  void initSubscription() {
    _subscription = messageRemoteDataProvider.listenToMessages().listen(
      (messages) {
        if (messages.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(messages, status: RxStatus.success());
        }
      },
    );
  }

  Rx<MessageModel?> repliedMessage = Rx<MessageModel?>(null);

  void startReplying(MessageModel message) {
    repliedMessage.value = message;
  }

  void cancelReplying() {
    repliedMessage.value = null;
  }

  Future<void> sendMessage(String messageText) async {
    final myId = Get.find<AuthController>().userId;
    final now = DateTime.now();

    if (repliedMessage.value != null) {
      final repliedMessageData = repliedMessage.value!;
      final newMessageData = MessageModel(
        text: messageText,
        authorId: myId,
        authorName: myId.substring(0, 5),
        createdAt: now,
        repliedMessage: repliedMessageData,
      );

      await messageRemoteDataProvider.sendMessage(newMessageData);
      repliedMessage.value = null;
    } else {
      final messageData = MessageModel(
        text: messageText,
        authorId: myId,
        authorName: myId.substring(0, 5),
        createdAt: now,
      );

      await messageRemoteDataProvider.sendMessage(messageData);
    }
  }
}
