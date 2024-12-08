import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/group_entity.dart';

import '../../domain/model/paginate.dart';

class HomeState {
  bool isLoading;
  Paginate<ChatEntity> chatPagination;
  Paginate<GroupEntity> groupPagination;
  ChatEntity currentChat;
  GroupEntity currentGroup;

  HomeState({
    this.isLoading = true,
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
      );

  copyWith({
    bool? isLoading,
    Paginate<ChatEntity>? chatPagination,
    Paginate<GroupEntity>? groupPagination,
    ChatEntity? currentChat,
    GroupEntity? currentGroup,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        chatPagination: chatPagination ?? this.chatPagination,
        groupPagination: groupPagination ?? this.groupPagination,
        currentChat: currentChat ?? this.currentChat,
        currentGroup: currentGroup ?? this.currentGroup,
      );
}
