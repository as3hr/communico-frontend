import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:flutter/material.dart';

import '../../domain/model/paginate.dart';

class HomeState {
  bool isLoading;
  Paginate<ChatEntity> chatPagination;
  Paginate<GroupEntity> groupPagination;
  ChatEntity currentChat;
  GroupEntity currentGroup;
  TextEditingController currentMessageController;

  HomeState({
    this.isLoading = true,
    required this.currentMessageController,
    required this.chatPagination,
    required this.groupPagination,
    required this.currentChat,
    required this.currentGroup,
  });

  factory HomeState.empty() => HomeState(
      chatPagination: Paginate.empty(),
      groupPagination: Paginate.empty(),
      currentChat: ChatEntity.empty(),
      currentGroup: GroupEntity.empty(),
      currentMessageController: TextEditingController());

  copyWith({
    bool? isLoading,
    Paginate<ChatEntity>? chatPagination,
    Paginate<GroupEntity>? groupPagination,
    ChatEntity? currentChat,
    GroupEntity? currentGroup,
    TextEditingController? currentMessageController,
  }) =>
      HomeState(
        currentMessageController:
            currentMessageController ?? this.currentMessageController,
        isLoading: isLoading ?? this.isLoading,
        chatPagination: chatPagination ?? this.chatPagination,
        groupPagination: groupPagination ?? this.groupPagination,
        currentChat: currentChat ?? this.currentChat,
        currentGroup: currentGroup ?? this.currentGroup,
      );
}
