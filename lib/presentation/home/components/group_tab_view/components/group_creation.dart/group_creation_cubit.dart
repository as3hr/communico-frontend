import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../di/service_locator.dart';
import '../../../../../../domain/entities/user_entity.dart';
import '../../group_cubit.dart';
import 'group_creation_state.dart';

class GroupCreationCubit extends Cubit<GroupCreationState> {
  final UserRepository userRepository;
  GroupCreationCubit(this.userRepository) : super(GroupCreationState.empty());

  searchMembers(String value) {
    if (value.isNotEmpty) {
      final users = state.allUsers
          .where((user) =>
              user.username.toLowerCase().contains(value.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredUsers: users));
    } else {
      emit(state.copyWith(filteredUsers: []));
    }
  }

  void selectGroupUser(UserEntity currentUser) {
    state.filteredUsers
        .firstWhere((user) => user.id == currentUser.id)
        .isSelected = !currentUser.isSelected;

    final selectedUsers =
        state.filteredUsers.where((user) => user.isSelected).toList();
    if (selectedUsers.isNotEmpty) {
      state.selectedUsers = selectedUsers;
    } else {
      state.selectedUsers = [];
    }

    emit(state.copyWith(
      filteredUsers: state.filteredUsers,
      selectedUsers: state.selectedUsers,
    ));
  }

  fetchUsers() {
    userRepository
        .fetchUsers()
        .then((response) => response.fold((error) {}, (users) {
              state.allUsers = users;
            }));
  }

  closeDialog() {
    emit(state.copyWith(selectedUsers: [], filteredUsers: []));
  }

  void onGroupNameChanged(String val) {
    emit(state.copyWith(name: val));
  }

  Future<void> createGroup() async {
    emit(state.copyWith(isLoading: true));
    final group = GroupEntity(
      members: state.selectedUsers
          .map((user) => GroupMemberEntity(userId: user.id))
          .toList(),
      name: state.name,
    );
    await getIt<GroupCubit>().createGroup(group);
    emit(state.copyWith(isLoading: false));
  }
}
