import 'package:flutter/material.dart';

import '../../../../domain/entities/chat_entity.dart';
import '../../../../domain/model/paginate.dart';

class ChatState {
  Paginate<ChatEntity> chatPagination;
  ChatEntity currentChat;
  TextEditingController messageController;
  bool isSearching;
  List<ChatEntity> chatSearchList;
  bool messageLoading;
  bool chatLoading;

  ChatState({
    this.chatLoading = false,
    this.messageLoading = false,
    required this.messageController,
    required this.chatPagination,
    required this.chatSearchList,
    required this.currentChat,
    this.isSearching = false,
  });

  factory ChatState.empty() => ChatState(
        chatPagination: Paginate.empty(),
        currentChat: ChatEntity.empty(),
        messageController: TextEditingController(),
        chatSearchList: [],
      );

  copyWith({
    List<ChatEntity>? chatSearchList,
    Paginate<ChatEntity>? chatPagination,
    ChatEntity? currentChat,
    TextEditingController? messageController,
    bool? isSearching,
    bool? chatLoading,
    bool? messageLoading,
  }) =>
      ChatState(
        chatSearchList: chatSearchList ?? this.chatSearchList,
        isSearching: isSearching ?? this.isSearching,
        messageController: messageController ?? this.messageController,
        chatPagination: chatPagination ?? this.chatPagination,
        currentChat: currentChat ?? this.currentChat,
        chatLoading: chatLoading ?? this.chatLoading,
        messageLoading: messageLoading ?? this.messageLoading,
      );
}
