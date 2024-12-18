import 'package:flutter/material.dart';

import '../../../../domain/entities/message_entity.dart';

class ChatRoomQueryParams {
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function() onSendMessage;
  final void Function() scrollAndCall;
  final TextEditingController textController;
  final ScrollController scrollController;
  const ChatRoomQueryParams({
    required this.messages,
    required this.onSendMessage,
    required this.roomTitle,
    required this.textController,
    required this.scrollAndCall,
    required this.scrollController,
  });
}
