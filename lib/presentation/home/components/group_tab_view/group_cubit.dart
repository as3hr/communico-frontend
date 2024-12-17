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
import '../../../../domain/stores/user_store.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/deboouncer.dart';

class GroupCubit extends Cubit<GroupState> {
  final MessageRepository messageRepository;
  final GroupRepository groupRepository;
  final Debouncer _debouncer;

  GroupCubit(this.messageRepository, this.groupRepository)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(GroupState.empty());

  Future<void> getGroups() async {
    if (state.groupPagination.next || state.groupPagination.data.isEmpty) {
      groupRepository.getMyGroups(state.groupPagination).then(
            (response) => response.fold(
              (error) {},
              (groupPagination) async {
                if (groupPagination.data.isNotEmpty) {
                  if (state.groupPagination.data.isEmpty) {
                    await updateCurrentGroup(groupPagination.data.first);
                  }
                  emit(state.copyWith(
                      groupPagination: groupPagination, isSearching: false));
                }
              },
            ),
          );
    }
  }

  empty() => emit(GroupState.empty());

  appendMessageToGroup(MessageEntity message) {
    state.currentGroup.messagePagination.data.insert(0, message);
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

  scrollAndCallGroup() {
    if (!state.groupLoading) {
      if (state.groupPagination.next || state.groupPagination.data.isEmpty) {
        emit(state.copyWith(groupLoading: true));
        getGroups().then((_) {
          emit(state.copyWith(groupLoading: false));
        });
      }
    }
  }

  scrollAndCallMessages(GroupEntity group) {
    if (!state.messageLoading) {
      if (group.messagePagination.next ||
          group.messagePagination.data.isEmpty) {
        emit(state.copyWith(messageLoading: true));
        getGroupMessages(group).then((_) {
          emit(state.copyWith(messageLoading: false));
        });
      }
    }
  }

  searchInGroupsList(String val) {
    if (val.isNotEmpty) {
      _debouncer.call(() {
        final updatedGroupList = state.groupPagination.data.where((group) {
          return group.name.toLowerCase().contains(val.toLowerCase());
        }).toList();
        if (!state.isSearching) {
          emit(state.copyWith(
              isSearching: true, groupSearchList: updatedGroupList));
        } else {
          emit(state.copyWith(groupSearchList: updatedGroupList));
        }
      });
    } else {
      _debouncer.cancel();
      emit(state.copyWith(isSearching: false));
    }
  }

  emitMessage(MessageEntity message) {
    socket.emit(
      'groupMessage',
      message.toGroupJson(),
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

  Future<void> createGroup(GroupEntity group) async {
    final response = await groupRepository.createGroup(group);
    response.fold((error) {}, (group) async {
      state.groupPagination.data.insert(0, group);
      await getGroupMessages(group);
      emit(state.copyWith(
          groupPagination: state.groupPagination, currentGroup: group));
    });
  }

  Future<void> getGroupMessages(GroupEntity group) async {
    if (group.messagePagination.next || group.messagePagination.data.isEmpty) {
      await messageRepository
          .getMessages(group.messagePagination, "/messages/groups", {
        "groupId": group.id,
      }).then((response) => response.fold((error) {}, (messagePagination) {
                group.messagePagination = messagePagination;
              }));
    }
    emit(state.copyWith(currentGroup: group));
  }

  Future<void> updateCurrentGroup(GroupEntity group) async {
    socket.emit("leaveGroup", {
      "groupId": state.currentGroup.id,
    });
    await getGroupMessages(group);
    socket.emit("groupJoin", {
      "groupId": state.currentGroup.id,
    });
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
