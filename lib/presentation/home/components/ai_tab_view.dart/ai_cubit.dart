import 'dart:async';
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
      generateAiResponse(message.text);
    }
  }

  StreamSubscription? subscription;

  void generateAiResponse(String text) {
    emit(state.copyWith(isLoading: true));
    String aiResponse = "";
    final aiResponseStream = messageRepository.getAiResponse(text);
    subscription = aiResponseStream.listen(
        (response) => response.fold((error) {}, (resp) {
              log("AI MESSAGE IS: $resp");
              if (!state.aiMessageInitialized) {
                emit(state.copyWith(
                    aiMessageInitialized: true, isLoading: false));
              }
              aiResponse += resp;
              emit(state.copyWith(aiResponse: aiResponse));
            }), onDone: () {
      log("AI MESSAGE Completed: ${state.aiResponse}");
      final message = MessageEntity(text: aiResponse, userId: 0, isAi: true);
      appendMessageToAiChat(message);
      emit(state.copyWith(aiResponse: ""));
      emit(state.copyWith(
        aiResponse: "",
        isLoading: false,
        aiMessageInitialized: false,
      ));
      subscription?.cancel();
    }, onError: (error) {
      log("ERROR IS: ${error.toString()}");
      emit(state.copyWith(
        aiResponse: "",
        aiMessageInitialized: false,
        isLoading: false,
      ));
    });
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
