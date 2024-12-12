import 'package:communico_frontend/presentation/home/components/group_tab_view/components/group_creation.dart/group_creation.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/entities/user_entity.dart';

class GroupCreationState {
  List<UserEntity> allUsers;
  List<UserEntity> filteredUsers;
  List<UserEntity> selectedUsers;
  PageController pageController;
  List<Widget> formPages;
  String name;
  bool isLoading;

  GroupCreationState({
    required this.allUsers,
    required this.filteredUsers,
    required this.pageController,
    required this.formPages,
    required this.selectedUsers,
    required this.name,
    this.isLoading = false,
  });

  factory GroupCreationState.empty() => GroupCreationState(
        allUsers: [],
        name: "",
        filteredUsers: [],
        formPages: [
          const GroupCreationMemberSelection(),
          const GroupCreationNaming(),
        ],
        selectedUsers: [],
        pageController: PageController(),
      );

  copyWith({
    String? name,
    List<UserEntity>? allUsers,
    List<UserEntity>? filteredUsers,
    List<Widget>? formPages,
    PageController? pageController,
    List<UserEntity>? selectedUsers,
    bool? isLoading,
  }) =>
      GroupCreationState(
        selectedUsers: selectedUsers ?? this.selectedUsers,
        allUsers: allUsers ?? this.allUsers,
        filteredUsers: filteredUsers ?? this.filteredUsers,
        formPages: formPages ?? this.formPages,
        pageController: pageController ?? this.pageController,
        name: name ?? this.name,
        isLoading: isLoading ?? this.isLoading,
      );
}
