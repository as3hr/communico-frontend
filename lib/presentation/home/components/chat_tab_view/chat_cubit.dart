import 'dart:developer';

import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:communico_frontend/presentation/home/components/message/message_actions_params.dart';
import 'package:communico_frontend/presentation/home/home_navigator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../../../../domain/entities/chat_entity.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/model/message_json.dart';
import '../../../../domain/repositories/chat_repository.dart';
import '../../../../domain/repositories/message_repository.dart';
import '../../../../domain/stores/user_store.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/deboouncer.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final Debouncer _debouncer;
  final HomeNavigator navigator;

  ChatCubit(this.chatRepository, this.messageRepository, this.navigator)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(ChatState.empty());

  Future<void> getChats() async {
    if (state.chatPagination.next || state.chatPagination.data.isEmpty) {
      chatRepository.getMyChats(state.chatPagination).then(
            (response) => response.fold(
              (error) {},
              (chatPagination) async {
                if (chatPagination.data.isNotEmpty) {
                  if (state.chatPagination.data.isEmpty) {
                    await updateCurrentChat(chatPagination.data.first);
                  }
                  emit(state.copyWith(
                      chatPagination: chatPagination, isSearching: false));
                }
              },
            ),
          );
    }
  }

  openChatRoom(ChatEntity chat) {
    final chatUser = chat.participants.isNotEmpty
        ? chat.participants
            .firstWhere((participant) => participant.userId != user!.id)
            .user
        : null;

    final params = ChatRoomQueryParams(
      onSendMessage: () {
        sendMessage();
      },
      scrollController: chat.messagePagination.scrollController,
      scrollAndCall: () {
        scrollAndCallMessages(chat);
      },
      textController: state.messageController,
      roomTitle: chatUser?.username ?? "",
      messages: chat.messagePagination.data,
    );

    final messageActionsParams =
        MessageActionsParams(onDelete: (messageId) {}, onReply: (messageId) {});

    navigator.goToChatRoom(params, messageActionsParams);
  }

  empty() => emit(ChatState.empty());

// only append the incoming message if it is from someone else
  listenToDirectMessage() {
    socket.on('newMessage', (data) {
      log("NEW MESSAGE ARRIVED: $data");
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        appendMessageToChat(message);
      }
    });

    socket.on("messageDeletion", (data) {
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        state.currentChat.messagePagination.data
            .removeWhere((currentMessage) => message.id == currentMessage.id);
        emit(state.copyWith(currentChat: state.currentChat));
      }
    });

    socket.on("messageUpdation", (data) {
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        state.currentChat.messagePagination.data
            .firstWhere((currentMessage) => message.id == currentMessage.id)
            .text = message.text;
        emit(state.copyWith(currentChat: state.currentChat));
      }
    });
  }

  appendMessageToChat(MessageEntity message) {
    state.currentChat.messagePagination.data.insert(0, message);
    emit(state.copyWith(chatPagination: state.chatPagination));
  }

  searchInChatsList(String val) {
    if (val.isNotEmpty) {
      _debouncer.call(() {
        final updatedChatList = state.chatPagination.data.where((chat) {
          final particpants = chat.participants
              .where((participant) => participant.user!.username
                  .toLowerCase()
                  .contains(val.toLowerCase()))
              .toList();
          return particpants.isNotEmpty;
        }).toList();
        if (!state.isSearching) {
          emit(state.copyWith(
              chatSearchList: updatedChatList, isSearching: true));
        } else {
          emit(state.copyWith(chatSearchList: updatedChatList));
        }
      });
    } else {
      _debouncer.cancel();
      emit(state.copyWith(isSearching: false));
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

  Future<void> deleteMessage(MessageEntity entity) async {
    state.currentChat.messagePagination.data
        .removeWhere((message) => message.id == entity.id);
    emit(state.copyWith(currentChat: state.currentChat));
    socket.emit(
      "messageDeleted",
      entity.toChatJson(),
    );
  }

  void updateMessage(MessageEntity entity, BuildContext context) {
    state.currentChat.messagePagination.data
        .firstWhere((message) => message.id == entity.id)
        .text = entity.text;
    emit(state.copyWith(currentChat: state.currentChat));
    socket.emit(
      "messageUpdated",
      entity.toChatJson(),
    );
    Navigator.pop(context);
  }

  void generateReplyTo(MessageEntity entity) {}

  emitMessage(MessageEntity message) {
    socket.emit(
      'message',
      message.toChatJson(),
    );
  }

  Future<void> getChatMessages(ChatEntity chat) async {
    if (chat.messagePagination.next || chat.messagePagination.data.isEmpty) {
      await messageRepository
          .getMessages(chat.messagePagination, "/messages/chats", {
        "chatId": chat.id,
      }).then(
        (response) => response.fold(
          (error) {},
          (messagePagination) {
            chat.messagePagination = messagePagination;
          },
        ),
      );
    }
    emit(state.copyWith(currentChat: chat));
  }

  scrollAndCallChat() {
    if (!state.chatLoading) {
      if (state.chatPagination.next || state.chatPagination.data.isEmpty) {
        emit(state.copyWith(chatLoading: true));
        getChats().then((_) {
          emit(state.copyWith(chatLoading: false));
        });
      }
    }
  }

  Future<void> scrollAndCallMessages(ChatEntity chat) async {
    if (!state.messageLoading) {
      emit(state.copyWith(messageLoading: true));
      if (chat.messagePagination.next || chat.messagePagination.data.isEmpty) {
        await getChatMessages(chat);
        emit(state.copyWith(messageLoading: false));
      }
    }
  }

  Future<void> updateCurrentChat(ChatEntity chat) async {
    socket.emit("leaveRoom", {
      "chatId": state.currentChat.id,
    });
    await getChatMessages(chat);
    socket.emit("roomJoin", {
      "chatId": state.currentChat.id,
    });
  }

  Future<void> createChat(ChatEntity chat) async {
    final response = await chatRepository.createChat(chat);
    response.fold((error) {}, (chat) async {
      state.chatPagination.data.insert(0, chat);
      await getChatMessages(chat);
      emit(state.copyWith(
          chatPagination: state.chatPagination, currentChat: chat));
    });
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
