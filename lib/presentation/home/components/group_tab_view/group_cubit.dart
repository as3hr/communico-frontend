import 'dart:developer';

import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:communico_frontend/presentation/home/home_navigator.dart';
import 'package:flutter/cupertino.dart';
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
  final HomeNavigator navigator;

  GroupCubit(this.messageRepository, this.groupRepository, this.navigator)
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

  toggleGroupField({required bool groupFieldEnabled}) {
    emit(state.copyWith(groupFieldEnabled: groupFieldEnabled));
  }

  void onCloseIconTap() {
    emit(state.copyWith(groupNameField: ""));
    toggleGroupField(groupFieldEnabled: false);
  }

  Future<void> deleteMessage(MessageEntity entity) async {
    state.currentGroup.messagePagination.data
        .removeWhere((message) => message.id == entity.id);
    emit(state.copyWith(currentGroup: state.currentGroup));
    socket.emit(
      "groupMessageDeleted",
      entity.toGroupJson(),
    );
  }

  void updateMessage(MessageEntity entity, BuildContext context) {
    state.currentGroup.messagePagination.data
        .firstWhere((message) => message.id == entity.id)
        .text = entity.text;
    emit(state.copyWith(currentGroup: state.currentGroup));
    socket.emit(
      "groupMessageUpdated",
      entity.toGroupJson(),
    );
    Navigator.pop(context);
  }

  void triggerReplyTo(MessageEntity? entity, bool show) {
    if (show) {
      state.currentReplyTo = entity;
    } else {
      state.currentReplyTo = null;
    }
    emit(state.copyWith(currentReplyTo: entity));
  }

  appendMessageToGroup(MessageEntity message) {
    state.currentGroup.messagePagination.data.insert(0, message);
    emit(state.copyWith(groupPagination: state.groupPagination));
  }

  sendMessage() {
    if (state.groupMessageController.text.isNotEmpty) {
      MessageEntity message = MessageEntity(
        text: state.groupMessageController.text,
        userId: user!.id,
        sender: user,
      );
      message.groupId = state.currentGroup.id;
      if (state.currentReplyTo != null) {
        message.replyTo = state.currentReplyTo;
        message.replyToId = state.currentReplyTo!.id;
      }
      appendMessageToGroup(message);
      emitMessage(message);
      state.groupMessageController.text = "";
      emit(state.copyWith(currentReplyTo: null));
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
      final messageExists = state.currentGroup.messagePagination.data.any(
        (currentMessage) => currentMessage.id == message.id,
      );
      if (!messageExists && message.userId != user!.id) {
        appendMessageToGroup(message);
      }
    });

    socket.on("groupMessageDeletion", (data) {
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        state.currentGroup.messagePagination.data
            .removeWhere((currentMessage) => currentMessage.id == message.id);
        emit(state.copyWith(currentGroup: state.currentGroup));
      }
    });

    socket.on("groupMessageUpdation", (data) {
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        state.currentGroup.messagePagination.data
            .firstWhere((currentMessage) => message.id == currentMessage.id)
            .text = message.text;
        emit(state.copyWith(currentGroup: state.currentGroup));
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
    await getEncryptedGroupLink(group);
    socket.emit("groupJoin", {
      "groupId": state.currentGroup.id,
    });
  }

  getEncryptedGroupLink(GroupEntity group) async {
    await groupRepository.encryptGroupLink(group.id).then(
          (response) => response.fold(
            (error) {},
            (link) {
              state.currentGroup.link = link;
              emit(state.copyWith(currentGroup: state.currentGroup));
            },
          ),
        );
  }

  UserEntity? get user => sl<UserStore>().getUser();

  List<UserEntity> get previousUsers => state.currentGroup.members
          .where((member) => member.user!.id != user!.id)
          .map((member) {
        final user =
            member.user?.copyWith(isSelected: true) ?? UserEntity.empty();
        return user;
      }).toList();

  void updateGroup(GroupEntity currentGroup) {
    groupRepository.updateGroup(currentGroup);
    emit(state.copyWith(currentGroup: currentGroup, groupFieldEnabled: false));
  }

  void selectGroupUser(UserEntity curentUser, List<UserEntity> allUsers) {
    allUsers.firstWhere((user) => user.id == curentUser.id).isSelected =
        !curentUser.isSelected;

    final selectedMembers = allUsers.where((user) => user.isSelected).toList();
    if (selectedMembers.isNotEmpty) {
      state.selectedUsers = selectedMembers;
    } else {
      state.selectedUsers = [];
    }

    emit(state.copyWith(
      filteredUsers: state.filteredUsers,
      selectedUsers: state.selectedUsers,
    ));
  }

  void finalizeGroupMembers(List<UserEntity> users) {
    final members = users
        .map((user) => GroupMemberEntity(userId: user.id, user: user))
        .toList();
    state.currentGroup.members = [
      ...members,
      GroupMemberEntity(userId: user!.id, user: user)
    ];
    updateGroup(state.currentGroup);
  }

  fetchMembers() {
    groupRepository
        .getMembers(state.currentGroup.id)
        .then((response) => response.fold((error) {}, (users) {
              state.allUsers = users;
            }));
  }

  closeDialog() {
    emit(state.copyWith(selectedUsers: [], filteredUsers: []));
  }

  void searchMembers(String val) {
    if (val.isNotEmpty) {
      final users = state.allUsers
          .where((user) =>
              (user.username).toLowerCase().contains(val.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredUsers: users));
    } else {
      emit(state.copyWith(filteredUsers: []));
    }
  }
}
