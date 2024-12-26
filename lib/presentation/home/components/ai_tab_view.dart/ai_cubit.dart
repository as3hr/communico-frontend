import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
import 'package:communico_frontend/helpers/constants.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';

import '../../../../di/service_locator.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/stores/user_store.dart';

class AiCubit extends Cubit<AiState> {
  final MessageRepository messageRepository;
  AiCubit(this.messageRepository) : super(AiState.empty());

  void sendMessage() {
    if (state.currentAiMessageController.text.isNotEmpty) {
      final message = MessageEntity(
        text: state.currentAiMessageController.text,
        userId: user!.id,
      );
      state.currentAiMessageController.clear();
      appendMessageToAiChat(message);
      final aiStreamMessage =
          MessageEntity(aiStream: true, text: "", userId: 0);
      appendMessageToAiChat(aiStreamMessage);
      emit(state.copyWith(isLoading: true));
      socket.emit("aiPrompt", {"prompt": message.text});
    }
  }

  listenToAiResponse() {
    String aiResponse = "";

    socket.on("aiResponse", (data) {
      final chunk = data.toString();
      aiResponse += chunk;
      handleResponse(aiResponse);
    });

    socket.on("streamEnded", (data) {
      if (data == true) {
        state.controller.close();
        final message = MessageEntity(text: aiResponse, userId: 0, isAi: true);
        removeAiStreamMessage();
        appendMessageToAiChat(message);
        aiResponse = "";
        emit(state.copyWith(
          isLoading: false,
          prompt: "",
          aiMessageInitialized: false,
        ));
      }
    });
  }

  handleResponse(String response) {
    state.controller.add(response);
    if (!state.aiMessageInitialized) {
      emit(state.copyWith(aiMessageInitialized: true, isLoading: false));
    }
  }

  removeAiStreamMessage() {
    state.messages.removeWhere((message) => message.aiStream);
    emit(state.copyWith(messages: state.messages));
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
