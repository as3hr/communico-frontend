import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class AiState {
  TextEditingController currentAiMessageController;
  List<MessageEntity> messages;
  AiState({
    required this.currentAiMessageController,
    required this.messages,
  });

  factory AiState.empty() => AiState(
        currentAiMessageController: TextEditingController(),
        messages: [],
      );

  copyWith({
    TextEditingController? currentAiMessageController,
    List<MessageEntity>? messages,
  }) =>
      AiState(
          currentAiMessageController:
              currentAiMessageController ?? this.currentAiMessageController,
          messages: messages ?? this.messages);
}
