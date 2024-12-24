import 'package:flutter/material.dart';

import '../../../../domain/entities/message_entity.dart';

class ChatRoomQueryParams {
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function() onSendMessage;
  final void Function() scrollAndCall;
  final TextEditingController textController;
  final ScrollController scrollController;
  final void Function()? onEndDrawerChanged;
  final bool isGroup;
  const ChatRoomQueryParams({
    required this.messages,
    required this.onSendMessage,
    this.onEndDrawerChanged,
    required this.roomTitle,
    required this.textController,
    required this.scrollAndCall,
    required this.scrollController,
    this.isGroup = false,
  });
}
