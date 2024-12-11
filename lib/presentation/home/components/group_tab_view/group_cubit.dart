import 'dart:developer';

import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../../../../domain/entities/group_entity.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/message_json.dart';
import '../../../../domain/repositories/group_repository.dart';
import '../../../../domain/repositories/message_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/deboouncer.dart';

class GroupCubit extends Cubit<GroupState> {
  final UserRepository userRepository;
  final MessageRepository messageRepository;
  final GroupRepository groupRepository;
  final Debouncer _debouncer;

  GroupCubit(this.userRepository, this.messageRepository, this.groupRepository)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(GroupState.empty());

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
    emit(state.copyWith(filteredUsers: state.filteredUsers));
  }

  fetchUsers() {
    userRepository
        .fetchUsers()
        .then((response) => response.fold((error) {}, (users) {
              state.allUsers = users;
            }));
  }

  appendMessageToGroup(MessageEntity message) {
    final group = state.groupPagination.data
        .firstWhere((group) => group.id == message.groupId);
    group.messages.insert(0, message);
    emit(state.copyWith(groupPagination: state.groupPagination));
  }

  sendMessage() {
    if (state.groupMessageController.text.isNotEmpty) {
      MessageEntity message = MessageEntity(
        text: state.groupMessageController.text,
        userId: user!.id,
      );
      message.groupId = state.currentGroup.id;
      appendMessageToGroup(message);
      emitMessage(message);
      state.groupMessageController.text = "";
    }
  }

  searchInGroupsList(String val) {
    if (val.isNotEmpty) {
      _debouncer.call(() {
        final updatedGroupList = state.groupPagination.data.where((group) {
          return group.name.toLowerCase().contains(val.toLowerCase());
        }).toList();
        final updatedPagination =
            state.groupPagination.copyWith(data: updatedGroupList);
        emit(state.copyWith(groupPagination: updatedPagination));
      });
    } else {
      _debouncer.cancel();
      getGroups();
    }
  }

  emitMessage(MessageEntity message) {
    socket.emit(
      'groupMessage',
      message.toGroupJson(),
    );
  }

  Future<void> getGroups() async {
    groupRepository.getMyGroups().then(
          (response) => response.fold(
            (error) {},
            (groupPagination) {
              emit(state.copyWith(
                groupPagination: groupPagination,
                currentGroup: groupPagination.data.firstOrNull,
              ));
              updateCurrentGroup(state.currentGroup);
            },
          ),
        );
  }

// only append the incoming message if it is from someone else
  listenToGroupMessage() {
    socket.on('newGroupMessage', (data) {
      log("NEW GROUP MESSAGE ARRIVED: $data");
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        appendMessageToGroup(message);
      }
    });
  }

  getGroupMessages() {
    messageRepository.getMessages("/messages/", {
      "groupId": state.currentGroup.id,
    });
  }

  void updateCurrentGroup(GroupEntity group) {
    socket.emit("leaveGroup", {
      "groupId": state.currentGroup.id,
    });
    emit(state.copyWith(currentGroup: group));
    socket.emit("groupJoin", {
      "groupId": state.currentGroup.id,
    });
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
