import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/message_json.dart';
import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/domain/repositories/group_repository.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
import 'package:communico_frontend/helpers/constants.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../di/service_locator.dart';
import '../../domain/stores/user_store.dart';

class HomeCubit extends Cubit<HomeState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final GroupRepository groupRepository;
  HomeCubit(
    this.chatRepository,
    this.groupRepository,
    this.messageRepository,
  ) : super(HomeState.empty());

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));
    await Future.wait([
      getChats(),
      getGroups(),
    ]);
    socketInit();
    emit(state.copyWith(isLoading: false));
  }

  socketInit() {
    socket.connect();
    socket.onConnect((_) {
      log('Connected to the Socket Server');
    });
    listenToDirectMessage();
    listenToGroupMessage();
    socket.onDisconnect((_) {
      log('Disconnected from the Socket Server');
    });
  }

// only append the incoming message if it is from someone else
  listenToDirectMessage() {
    socket.on('newMessage', (data) {
      log("NEW MESSAGE ARRIVED: $data");
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        appendMessageToChat(message);
      }
    });
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

  appendMessageToGroup(MessageEntity message) {
    final group = state.groupPagination.data
        .firstWhere((group) => group.id == message.groupId);
    group.messages.insert(0, message);
    emit(state.copyWith(groupPagination: state.groupPagination));
  }

  appendMessageToChat(MessageEntity message) {
    final chat = state.chatPagination.data
        .firstWhere((chat) => chat.id == message.chatId);
    chat.messages?.insert(0, message);
    emit(state.copyWith(chatPagination: state.chatPagination));
  }

  // index 0 == directMessages && index 1 == groupMessages
  sendMessage(int index) {
    if (index == 0) {
      if (state.currentMessageController.text.isNotEmpty) {
        MessageEntity message = MessageEntity(
          text: state.currentMessageController.text,
          userId: user!.id,
        );
        message.chatId = state.currentChat.id;
        appendMessageToChat(message);
        emitMessage(index, message);
        state.currentMessageController.text = "";
      }
    } else if (index == 1) {
      if (state.currentGroupMessageController.text.isNotEmpty) {
        MessageEntity message = MessageEntity(
          text: state.currentGroupMessageController.text,
          userId: user!.id,
        );
        message.groupId = state.currentGroup.id;
        appendMessageToGroup(message);
        emitMessage(index, message);
        state.currentGroupMessageController.text = "";
      }
    }
  }

  emitMessage(int index, MessageEntity message) {
    if (index == 0) {
      socket.emit(
        'message',
        message.toChatJson(),
      );
    } else if (index == 1) {
      socket.emit(
        'groupMessage',
        message.toGroupJson(),
      );
    }
  }

  Future<void> getChats() async {
    chatRepository.getMyChats().then(
          (response) => response.fold(
            (error) {},
            (chatPagination) {
              emit(state.copyWith(
                chatPagination: chatPagination,
                currentChat: chatPagination.data.first,
              ));
              updateCurrentChat(state.currentChat);
            },
          ),
        );
  }

  Future<void> getGroups() async {
    groupRepository.getMyGroups().then(
          (response) => response.fold(
            (error) {},
            (groupPagination) {
              emit(state.copyWith(
                groupPagination: groupPagination,
                currentGroup: groupPagination.data.first,
              ));
              updateCurrentGroup(state.currentGroup);
            },
          ),
        );
  }

  getChatMessages() {
    messageRepository.getMessages("/messages/", {
      "chatId": state.currentChat.id,
    });
  }

  getGroupMessages() {
    messageRepository.getMessages("/messages/", {
      "groupId": state.currentGroup.id,
    });
  }

  void updateCurrentChat(ChatEntity chat) {
    socket.emit("leaveRoom", {
      "chatId": state.currentChat.id,
    });
    emit(state.copyWith(currentChat: chat));
    socket.emit("roomJoin", {
      "chatId": state.currentChat.id,
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

  bool isMyMessage(MessageEntity message) {
    return user != null && (user!.id == message.userId) ? true : false;
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
