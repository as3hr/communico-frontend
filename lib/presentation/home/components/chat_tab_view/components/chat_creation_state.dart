import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/user_entity.dart';

class ChatCreationState {
  List<UserEntity> allUsers;
  List<UserEntity> filteredUsers;
  UserEntity selectedUser;
  PageController pageController;
  List<Widget> formPages;
  String message;
  bool isLoading;

  ChatCreationState({
    required this.allUsers,
    required this.filteredUsers,
    required this.pageController,
    required this.formPages,
    required this.message,
    required this.selectedUser,
    this.isLoading = false,
  });

  factory ChatCreationState.empty() => ChatCreationState(
        allUsers: [],
        message: "",
        filteredUsers: [],
        formPages: [
          const ChatCreationMemberSelection(),
          const MessageCreation()
        ],
        selectedUser: UserEntity.empty(),
        pageController: PageController(),
      );

  copyWith({
    bool? isLoading,
    List<UserEntity>? allUsers,
    List<UserEntity>? filteredUsers,
    List<Widget>? formPages,
    PageController? pageController,
    UserEntity? selectedUser,
    String? message,
  }) =>
      ChatCreationState(
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        selectedUser: selectedUser ?? this.selectedUser,
        allUsers: allUsers ?? this.allUsers,
        filteredUsers: filteredUsers ?? this.filteredUsers,
        formPages: formPages ?? this.formPages,
        pageController: pageController ?? this.pageController,
      );
}
