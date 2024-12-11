import 'package:bloc/bloc.dart';
import 'package:communico_frontend/main.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/ai_stream_event.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import '../../../../di/service_locator.dart';
import '../../../../domain/entities/message_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/stores/user_store.dart';

class AiCubit extends Cubit<AiState> {
  AiCubit() : super(AiState.empty());

  void sendMessage() {
    if (state.currentAiMessageController.text.isNotEmpty) {
      final message = MessageEntity(
        text: state.currentAiMessageController.text,
        userId: user!.id,
      );
      state.currentAiMessageController.clear();
      appendMessageToAiChat(message);
      generateAiResponse(message.text);
    }
  }

  void generateAiResponse(String text) {
    String aiResponse = "";
    emit(state.copyWith(isLoading: true));
    Future.delayed(const Duration(seconds: 1), () {});
    Gemini.instance.promptStream(parts: [
      Part.text(text),
    ]).listen(
      (value) {
        dynamic output = value?.content?.parts?.first;
        if (!state.aiMessageInitialized) {
          emit(state.copyWith(aiMessageInitialized: true, isLoading: false));
        }
        aiResponse += output.text;
        eventBus.fire(AiStreamEvent(response: aiResponse));
      },
      onDone: () {
        final message = MessageEntity(text: aiResponse, userId: 0, isAi: true);
        appendMessageToAiChat(message);
        eventBus.fire(AiStreamEvent(response: ""));
        emit(state.copyWith(
          aiMessageInitialized: false,
          messages: state.messages,
        ));
      },
    );
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
