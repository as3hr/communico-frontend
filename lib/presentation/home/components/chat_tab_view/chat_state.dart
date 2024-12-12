import 'package:flutter/material.dart';

import '../../../../domain/entities/chat_entity.dart';
import '../../../../domain/model/paginate.dart';

class ChatState {
  Paginate<ChatEntity> chatPagination;
  ChatEntity currentChat;
  TextEditingController messageController;

  ChatState({
    required this.messageController,
    required this.chatPagination,
    required this.currentChat,
  });

  factory ChatState.empty() => ChatState(
        chatPagination: Paginate.empty(),
        currentChat: ChatEntity.empty(),
        messageController: TextEditingController(),
      );

  copyWith({
    Paginate<ChatEntity>? chatPagination,
    ChatEntity? currentChat,
    TextEditingController? messageController,
  }) =>
      ChatState(
        messageController: messageController ?? this.messageController,
        chatPagination: chatPagination ?? this.chatPagination,
        currentChat: currentChat ?? this.currentChat,
      );
}
