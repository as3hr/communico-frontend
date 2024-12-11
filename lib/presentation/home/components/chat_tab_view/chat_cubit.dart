import 'dart:developer';

import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../../../../domain/entities/chat_entity.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/message_json.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../../domain/repositories/message_repository.dart';
import '../../../../domain/repositories/user_repository.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/deboouncer.dart';

class ChatCubit extends Cubit<ChatState> {
  final UserRepository userRepository;
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final Debouncer _debouncer;

  ChatCubit(this.userRepository, this.chatRepository, this.messageRepository)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(ChatState.empty());

  Future<void> getChats() async {
    chatRepository.getMyChats().then(
          (response) => response.fold(
            (error) {},
            (chatPagination) {
              emit(state.copyWith(
                chatPagination: chatPagination,
                currentChat: chatPagination.data.firstOrNull,
              ));
              updateCurrentChat(state.currentChat);
            },
          ),
        );
  }

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

  void selectChatUser(UserEntity currentUser) {
    final users = state.filteredUsers.map((user) {
      if (user.id == currentUser.id) {
        user.isSelected = true;
      } else {
        user.isSelected = false;
      }
      return user;
    }).toList();
    emit(state.copyWith(filteredUsers: users));
  }

  fetchUsers() {
    userRepository
        .fetchUsers()
        .then((response) => response.fold((error) {}, (users) {
              state.allUsers = users;
            }));
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

  appendMessageToChat(MessageEntity message) {
    final chat = state.chatPagination.data
        .firstWhere((chat) => chat.id == message.chatId);
    chat.messages?.insert(0, message);
    emit(state.copyWith(chatPagination: state.chatPagination));
  }

  searchInChatsList(String val) {
    if (val.isNotEmpty) {
      _debouncer.call(() {
        final updatedChatList = state.chatPagination.data.where((chat) {
          final particpants = chat.participants
              .where((participant) =>
                  participant.userId != user!.id &&
                  participant.user!.username
                      .toLowerCase()
                      .contains(val.toLowerCase()))
              .toList();
          return particpants.isNotEmpty;
        }).toList();
        final updatedPagination =
            state.chatPagination.copyWith(data: updatedChatList);
        emit(state.copyWith(chatPagination: updatedPagination));
      });
    } else {
      _debouncer.cancel();
      getChats();
    }
  }

  sendMessage() {
    if (state.messageController.text.isNotEmpty) {
      MessageEntity message = MessageEntity(
        text: state.messageController.text,
        userId: user!.id,
      );
      message.chatId = state.currentChat.id;
      appendMessageToChat(message);
      emitMessage(message);
      state.messageController.text = "";
    }
  }

  emitMessage(MessageEntity message) {
    socket.emit(
      'message',
      message.toChatJson(),
    );
  }

  getChatMessages() {
    messageRepository.getMessages("/messages/", {
      "chatId": state.currentChat.id,
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

  UserEntity? get user => getIt<UserStore>().getUser();

  void createChat() {}
}
