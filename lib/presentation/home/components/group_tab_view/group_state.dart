import 'package:flutter/material.dart';

import '../../../../domain/entities/group_entity.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/paginate.dart';

class GroupState {
  // Users to search for, when creating a group
  List<UserEntity> allUsers;

  // Filtered users after being searched among allUsers
  List<UserEntity> filteredUsers;

  // All those users who are chosen by a User to be the group members
  List<UserEntity> selectedUsers;

  // Current displayed group in chat room
  GroupEntity currentGroup;

  // List of groups displayed in search section while searching
  List<GroupEntity> groupSearchList;

  // Pagination entity coming from API
  Paginate<GroupEntity> groupPagination;

  // Text controller for handling chatRoom text messages
  TextEditingController groupMessageController;

  // For tracking searching and to control UI display for searching
  bool isSearching;

  // For pagination of messages
  bool messageLoading;

  // For pagination of groups list
  bool groupLoading;

  // For toggling group detail page name field
  bool groupFieldEnabled;

  // For updating group name in group detail page
  String groupNameField;

  // A reply can be given once at a time, therefore this is for maintaining if a reply is being given by a current user and to whome it is being given to
  MessageEntity? currentReplyTo;

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
    this.currentReplyTo,
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
    MessageEntity? currentReplyTo,
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
        currentReplyTo: currentReplyTo ?? this.currentReplyTo,
      );
}
