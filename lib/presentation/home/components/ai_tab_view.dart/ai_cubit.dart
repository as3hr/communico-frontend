import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/repositories/message_repository.dart';
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
      generateAiResponse(text: message.text);
    }
  }

  void generateAiResponse({String? text}) {
    emit(state.copyWith(isLoading: true));
    final aiResponseStream = messageRepository.getAiResponse(text ?? "");
    String aiResponse = "";
    final subscription = aiResponseStream.listen(
        (response) => response.fold((error) {
              log("RESPONSE ERROR: ${error.error}");
            }, (resp) {
              log("AI MESSAGE IS: $resp");
              aiResponse += resp;
              state.controller.add(aiResponse);
              if (!state.aiMessageInitialized) {
                emit(state.copyWith(
                    aiMessageInitialized: true, isLoading: false));
              }
            }), onDone: () {
      log("STREAM IS IN DONE NOW");
      state.controller.close();
      final message = MessageEntity(text: aiResponse, userId: 0, isAi: true);
      appendMessageToAiChat(message);
      emit(state.copyWith(
        isLoading: false,
        prompt: "",
        aiMessageInitialized: false,
      ));
    }, onError: (error) {
      state.controller.close();
      log("ERROR IS: ${error.toString()}");
      emit(state.copyWith(
        prompt: "",
        aiMessageInitialized: false,
        isLoading: false,
      ));
    });

    state.controller.onCancel = () {
      subscription.cancel();
    };
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
