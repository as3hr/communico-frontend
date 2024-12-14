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
import '../../../../domain/stores/user_store.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/deboouncer.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final Debouncer _debouncer;

  ChatCubit(this.chatRepository, this.messageRepository)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(ChatState.empty());

  Future<void> getChats() async {
    if (state.chatPagination.next || state.chatPagination.data.isEmpty) {
      chatRepository.getMyChats(state.chatPagination).then(
            (response) => response.fold(
              (error) {},
              (chatPagination) async {
                if (chatPagination.data.isNotEmpty) {
                  emit(state.copyWith(
                    chatPagination: chatPagination,
                    currentChat: chatPagination.data.first,
                  ));
                  await getChatMessages(chatPagination.data.first);
                }
                updateCurrentChat(state.currentChat);
              },
            ),
          );
    }
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
    chat.messages.insert(0, message);
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
    response.fold((error) {}, (chat) {
      state.chatPagination.data.insert(0, chat);
      emit(state.copyWith(
          chatPagination: state.chatPagination, currentChat: chat));
    });
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}