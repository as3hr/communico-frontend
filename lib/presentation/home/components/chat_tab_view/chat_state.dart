import 'package:flutter/material.dart';

import '../../../../domain/entities/chat_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/paginate.dart';

class ChatState {
  List<UserEntity> allUsers;
  List<UserEntity> filteredUsers;
  Paginate<ChatEntity> chatPagination;
  ChatEntity currentChat;
  TextEditingController messageController;

  ChatState({
    required this.allUsers,
    required this.filteredUsers,
    required this.messageController,
    required this.chatPagination,
    required this.currentChat,
  });

  factory ChatState.empty() => ChatState(
        chatPagination: Paginate.empty(),
        currentChat: ChatEntity.empty(),
        messageController: TextEditingController(),
        allUsers: [],
        filteredUsers: [],
      );

  copyWith({
    List<UserEntity>? allUsers,
    Paginate<ChatEntity>? chatPagination,
    ChatEntity? currentChat,
    TextEditingController? messageController,
    List<UserEntity>? filteredUsers,
  }) =>
      ChatState(
        messageController: messageController ?? this.messageController,
        chatPagination: chatPagination ?? this.chatPagination,
        currentChat: currentChat ?? this.currentChat,
        allUsers: allUsers ?? this.allUsers,
        filteredUsers: filteredUsers ?? this.filteredUsers,
      );
}
