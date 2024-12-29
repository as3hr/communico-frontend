import 'package:flutter/material.dart';

import '../../../../domain/entities/message_entity.dart';

class ChatRoomQueryParams {
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function()? onSendMessage;
  final void Function()? onShareChat;
  final void Function() scrollAndCall;
  final void Function()? onEndDrawerChanged;
  final TextEditingController? textController;
  final bool isGroup;
  const ChatRoomQueryParams({
    required this.messages,
    required this.roomTitle,
    required this.scrollAndCall,
    this.onSendMessage,
    this.onEndDrawerChanged,
    this.textController,
    this.onShareChat,
    this.isGroup = false,
  });
}
