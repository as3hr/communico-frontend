import 'package:flutter/material.dart';

import '../../../../domain/entities/group_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/paginate.dart';

class GroupState {
  List<UserEntity> allUsers;
  List<UserEntity> filteredUsers;
  List<UserEntity> selectedUsers;
  GroupEntity currentGroup;
  List<GroupEntity> groupSearchList;
  Paginate<GroupEntity> groupPagination;
  TextEditingController groupMessageController;
  bool isSearching;
  bool messageLoading;
  bool groupLoading;
  bool groupFieldEnabled;
  String groupNameField;

  GroupState({
    this.groupNameField = "",
    this.messageLoading = false,
    this.groupLoading = false,
    this.groupFieldEnabled = false,
    required this.currentGroup,
    required this.allUsers,
    required this.selectedUsers,
    required this.filteredUsers,
    required this.groupMessageController,
    required this.groupPagination,
    this.isSearching = false,
    required this.groupSearchList,
  });

  factory GroupState.empty() => GroupState(
        allUsers: [],
        filteredUsers: [],
        groupSearchList: [],
        selectedUsers: [],
        currentGroup: GroupEntity.empty(),
        groupPagination: Paginate.empty(),
        groupMessageController: TextEditingController(),
      );

  copyWith({
    List<UserEntity>? allUsers,
    GroupEntity? currentGroup,
    List<UserEntity>? selectedUsers,
    List<UserEntity>? filteredUsers,
    Paginate<GroupEntity>? groupPagination,
    TextEditingController? groupMessageController,
    bool? isSearching,
    bool? groupLoading,
    bool? messageLoading,
    List<GroupEntity>? groupSearchList,
    bool? groupFieldEnabled,
    String? groupNameField,
  }) =>
      GroupState(
        groupSearchList: groupSearchList ?? this.groupSearchList,
        isSearching: isSearching ?? this.isSearching,
        groupMessageController:
            groupMessageController ?? this.groupMessageController,
        groupPagination: groupPagination ?? this.groupPagination,
        currentGroup: currentGroup ?? this.currentGroup,
        allUsers: allUsers ?? this.allUsers,
        filteredUsers: filteredUsers ?? this.filteredUsers,
        selectedUsers: selectedUsers ?? this.selectedUsers,
        messageLoading: messageLoading ?? this.messageLoading,
        groupLoading: groupLoading ?? this.groupLoading,
        groupFieldEnabled: groupFieldEnabled ?? this.groupFieldEnabled,
        groupNameField: groupNameField ?? this.groupNameField,
      );
}
