import 'dart:developer';

import 'package:communico_frontend/domain/model/chat_json.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
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
import '../../../../helpers/debouncer.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  final Debouncer _debouncer;

  ChatCubit(this.chatRepository, this.messageRepository)
      : _debouncer = Debouncer(delay: const Duration(milliseconds: 800)),
        super(ChatState.empty());

  // This function is used to get the chats of the user
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

  // This function is used to get the encrypted chat link that a user can share around with each other
  getEncryptedChatLink(ChatEntity chat) async {
    await chatRepository.encryptChatLink(chat.id).then(
          (response) => response.fold(
            (error) {},
            (link) {
              state.currentChat.link = link;
              emit(state.copyWith(currentChat: state.currentChat));
            },
          ),
        );
  }

  // This is called when logging out of the app
  empty() => emit(ChatState.empty());

  // chat messages listener
  listenToChatEvents() {
    // if the message is not already in the chat and the user of the message is not the current user, then only append it
    socket.on('newMessage', (data) {
      log("NEW MESSAGE ARRIVED: $data");
      final message = MessageJson.fromJson(data).toDomain();
      final messageExists = state.currentChat.messagePagination.data.any(
        (currentMessage) => currentMessage.id == message.id,
      );
      if (!messageExists) {
        appendMessageToChat(message);
      }
    });

    /// when user will create a new chat, this will be triggered, when new chat is created, the user will join the room, and
    /// the chat will be added to the chat list only if the user is not the creator of the chat. we will get chat messages, and
    /// the encrypted link also of the current chat.
    socket.on("newChat", (data) async {
      final chat = ChatJson.fromJson(data['chat']).toDomain();
      final exists = state.chatPagination.data
          .any((currentChat) => currentChat.id == chat.id);
      if (!exists && data['userId'] != user!.id) {
        state.chatPagination.data.insert(0, chat);
        await getChatMessages(chat);
        await getEncryptedChatLink(chat);
        socket.emit("roomJoin", {
          "chatId": chat.id,
        });
        emit(state.copyWith(chatPagination: state.chatPagination));
      }
    });

    // when a user will delete a message from the chat, this will be triggered
    // if the user is not the creator of the message, then the message will be deleted from the chat
    socket.on("messageDeletion", (data) {
      final message = MessageJson.fromJson(data).toDomain();
      if (message.userId != user!.id) {
        state.currentChat.messagePagination.data
            .removeWhere((currentMessage) => message.id == currentMessage.id);
        emit(state.copyWith(currentChat: state.currentChat));
      }
    });

    // when a user will update a message from the chat, this will be triggered,
    // if the user is not the creator of the message, then the message will be updated in the chat
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

  // This function is used to delete the message in the chat, the message is deleted by the current user, and the message is sent to the server
  Future<void> deleteMessage(MessageEntity entity) async {
    log("DELETED MESSAGE: ${entity.id}, ${entity.text}");
    state.currentChat.messagePagination.data
        .removeWhere((message) => message.id == entity.id);
    emit(state.copyWith(currentChat: state.currentChat));
    socket.emit(
      "messageDeleted",
      entity.toChatJson(),
    );
  }

  // This function is used to append the message to the chat
  appendMessageToChat(MessageEntity message) {
    state.currentChat.messagePagination.data.insert(0, message);
    emit(state.copyWith(chatPagination: state.chatPagination));
  }

  // This function is used to search the chats in the chat list, the search is happening by comparing
  // current field value by the username of the participants of the chat, state.isSearching is used to
  // check if the user is currently searching or not, this also controls the UI display in chat_tab_view.dart
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

  // This function is used to create a new message in the current chat,
  // the message creation is done by the current user, the message is sent to the server
  // and the server will broadcast the message to all the users in the chat
  // the message replyTo is managed by currentReplyTo field in the state
  // if the currentReplyTo is not null, then the message will be a reply to the currentReplyTo message
  sendMessage() {
    if (state.messageController.text.isNotEmpty) {
      MessageEntity message = MessageEntity(
        text: state.messageController.text,
        userId: user!.id,
        sender: user,
      );
      message.chatId = state.currentChat.id;
      if (state.currentReplyTo != null) {
        message.replyTo = state.currentReplyTo;
        message.replyToId = state.currentReplyTo!.id;
      }
      emitMessage(message);
      state.messageController.text = "";
      state.currentReplyTo = null;
    }
  }

  // This function is used to update the message in the chat, the message is updated by the current user, and the message is sent to the server
  // the server will broadcast the message to all the users in the chat
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

  // This function is used to trigger the reply to message, the reply to animated container message is shown in the chat via this function
  void triggerReplyTo(MessageEntity? entity, bool show) {
    if (show) {
      state.currentReplyTo = entity;
    } else {
      state.currentReplyTo = null;
    }
    emit(state.copyWith(currentReplyTo: entity));
  }

  // this is called when current user sends a new message in the chat
  emitMessage(MessageEntity message) {
    socket.emit(
      'message',
      message.toChatJson(),
    );
  }

  // This function is used to get the chat messages of the chat, the chat messages are paginated, and the next field is used to check if there are more messages
  Future<void> getChatMessages(ChatEntity chat) async {
    if (chat.messagePagination.next || chat.messagePagination.data.isEmpty) {
      await messageRepository
          .getMessages(chat.messagePagination, "/messages/chats/${chat.id}")
          .then(
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

  // This function is used to scroll and call the chat, if the chat is not loading and the next field is true, then the chat is fetched
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

  // This function is used to scroll and call the messages of the chat, if the messages are not loading and the next field is true, then the messages are fetched
  Future<void> scrollAndCallMessages(ChatEntity chat) async {
    if (!state.messageLoading) {
      emit(state.copyWith(messageLoading: true));
      if (chat.messagePagination.next || chat.messagePagination.data.isEmpty) {
        await getChatMessages(chat);
        emit(state.copyWith(messageLoading: false));
      }
    }
  }

  // This function is used to update the current chat, the chat messages and the encrypted chat link are fetched,
  // this function is called when the user clicks on the chat in the chat list
  Future<void> updateCurrentChat(ChatEntity chat) async {
    await getChatMessages(chat);
    await getEncryptedChatLink(chat);
    socket.emit("roomJoin", {
      "chatId": state.currentChat.id,
    });
  }

  // This function is used to create a new chat, the chat is created by the current user, the chat is sent to the server
  // the server will broadcast the chat to all the users in the chat, the chat messages and the encrypted chat link are fetched
  Future<void> createChat(ChatEntity chat) async {
    final response = await chatRepository.createChat(chat);
    response.fold((error) {}, (chat) async {
      state.chatPagination.data.insert(0, chat);
      socket.emit("chatCreation", {"userId": user!.id, "chatId": chat.id});
      await getChatMessages(chat);
      await getEncryptedChatLink(chat);
      socket.emit("roomJoin", {
        "chatId": chat.id,
      });
      emit(state.copyWith(
          chatPagination: state.chatPagination, currentChat: chat));
    });
  }

  // The current user of the app
  UserEntity? get user => sl<UserStore>().getUser();
}
