import 'package:flutter/material.dart';

import '../../../../domain/entities/group_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/paginate.dart';

class GroupState {
  List<UserEntity> allUsers;
  List<UserEntity> filteredUsers;
  GroupEntity currentGroup;
  Paginate<GroupEntity> groupPagination;
  TextEditingController groupMessageController;

  GroupState({
    required this.currentGroup,
    required this.allUsers,
    required this.filteredUsers,
    required this.groupMessageController,
    required this.groupPagination,
  });

  factory GroupState.empty() => GroupState(
        allUsers: [],
        filteredUsers: [],
        currentGroup: GroupEntity.empty(),
        groupPagination: Paginate.empty(),
        groupMessageController: TextEditingController(),
      );

  copyWith({
    List<UserEntity>? allUsers,
    GroupEntity? currentGroup,
    List<UserEntity>? filteredUsers,
    Paginate<GroupEntity>? groupPagination,
    TextEditingController? groupMessageController,
  }) =>
      GroupState(
        groupMessageController:
            groupMessageController ?? this.groupMessageController,
        groupPagination: groupPagination ?? this.groupPagination,
        currentGroup: currentGroup ?? this.currentGroup,
        allUsers: allUsers ?? this.allUsers,
        filteredUsers: filteredUsers ?? this.filteredUsers,
      );
}
