import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class AiState {
  TextEditingController currentAiMessageController;
  List<MessageEntity> messages;
  bool aiMessageInitialized;
  bool isLoading;

  AiState({
    required this.currentAiMessageController,
    required this.messages,
    this.isLoading = false,
    this.aiMessageInitialized = false,
  });

  factory AiState.empty() => AiState(
        currentAiMessageController: TextEditingController(),
        messages: [],
      );

  copyWith({
    TextEditingController? currentAiMessageController,
    List<MessageEntity>? messages,
    bool? aiMessageInitialized,
    bool? isLoading,
  }) =>
      AiState(
        currentAiMessageController:
            currentAiMessageController ?? this.currentAiMessageController,
        messages: messages ?? this.messages,
        aiMessageInitialized: aiMessageInitialized ?? this.aiMessageInitialized,
        isLoading: isLoading ?? this.isLoading,
      );
}
