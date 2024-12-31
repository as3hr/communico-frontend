import 'package:communico_frontend/domain/repositories/chat_repository.dart';
import 'package:communico_frontend/presentation/shared_room/shared_chat/shared_chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/chat_entity.dart';
import '../../../domain/repositories/message_repository.dart';

class SharedChatCubit extends Cubit<SharedChatState> {
  final ChatRepository chatRepository;
  final MessageRepository messageRepository;
  SharedChatCubit(this.chatRepository, this.messageRepository)
      : super(SharedChatState.empty());

  void loadChat(String encryptedData) {
    emit(state.copyWith(isLoading: true, encryptedData: encryptedData));
    chatRepository
        .decryptChatId(encryptedData)
        .then((response) => response.fold(
              (failure) => emit(state.copyWith(isLoading: false)),
              (chat) {
                state.chat = chat;
                getChatMessages(state.chat);
              },
            ));
  }

  getChatMessages(ChatEntity chat) {
    messageRepository.getMessages(
      state.chat.messagePagination,
      "/messages/chats/dcrypt/${chat.id}",
      extraQuery: {
        "encryptedData": state.encryptedData,
      },
    ).then((response) => response.fold(
          (failure) => emit(state.copyWith(isLoading: false)),
          (messagePagination) {
            state.chat.messagePagination = messagePagination;
            emit(state.copyWith(chat: state.chat, isLoading: false));
          },
        ));
  }

  Future<void> scrollAndCallMessages() async {
    if (!state.messageLoading) {
      emit(state.copyWith(messageLoading: true));
      if (state.chat.messagePagination.next ||
          state.chat.messagePagination.data.isEmpty) {
        await getChatMessages(state.chat);
        emit(state.copyWith(messageLoading: false));
      }
    }
  }
}
