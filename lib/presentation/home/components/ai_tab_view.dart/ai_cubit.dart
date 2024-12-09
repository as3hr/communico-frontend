import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_state.dart';
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
      appendMessageToAiChat(message);
    }
  }

  void aiResponse() {
    Gemini.instance.promptStream(parts: [
      Part.text(state.currentAiMessageController.text),
    ]).listen((value) {});
  }

  appendMessageToAiChat(MessageEntity message) {
    state.messages.insert(0, message);
    emit(state.copyWith(messages: state.messages));
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
