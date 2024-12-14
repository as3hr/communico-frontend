import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
      generateAiResponse(message.text);
    }
  }

  void generateAiResponse(String text) {
    emit(state.copyWith(isLoading: true));
    String aiResponse = "";
    messageRepository.getAiResponse(text).listen(
        (response) => response.fold((error) {}, (resp) {}),
        onDone: () {},
        onError: (error) {});
    try {
      // ignore: deprecated_member_use
      Gemini.instance.streamGenerateContent(text,
          modelName: "gemini-1.5-flash",
          safetySettings: [
            SafetySetting(
                category: SafetyCategory.sexuallyExplicit,
                threshold: SafetyThreshold.blockMediumAndAbove),
            SafetySetting(
                category: SafetyCategory.harassment,
                threshold: SafetyThreshold.blockMediumAndAbove),
            SafetySetting(
                category: SafetyCategory.hateSpeech,
                threshold: SafetyThreshold.blockMediumAndAbove),
            SafetySetting(
                category: SafetyCategory.dangerous,
                threshold: SafetyThreshold.blockMediumAndAbove),
          ]).listen(
        (value) {
          log("VALUE IS: $value");
          dynamic output = value.content?.parts?.first;
          if (!state.aiMessageInitialized) {
            emit(state.copyWith(aiMessageInitialized: true, isLoading: false));
          }
          aiResponse += output.text;
          emit(state.copyWith(aiResponse: aiResponse));
        },
        onError: (error) {
          log("ERROR IS: ${error.toString()}");
          emit(state.copyWith(
            aiResponse: "",
            aiMessageInitialized: false,
            isLoading: false,
          ));
        },
        onDone: () {
          final message =
              MessageEntity(text: aiResponse, userId: 0, isAi: true);
          appendMessageToAiChat(message);
          emit(state.copyWith(aiResponse: ""));
          emit(state.copyWith(
            aiResponse: "",
            aiMessageInitialized: false,
          ));
        },
      );
    } catch (exp) {
      log("EXP IS: ${exp.toString()}");
      emit(state.copyWith(
        aiResponse: "",
        aiMessageInitialized: false,
        isLoading: false,
      ));
    }
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
