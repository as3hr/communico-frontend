import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class AiState {
  TextEditingController currentAiMessageController;
  List<MessageEntity> messages;
  bool aiMessageInitialized;
  bool isLoading;
  String prompt;
  ValueNotifier<String> aiResponse;

  AiState({
    required this.prompt,
    required this.aiResponse,
    required this.currentAiMessageController,
    required this.messages,
    this.isLoading = false,
    this.aiMessageInitialized = false,
  });

  factory AiState.empty() => AiState(
        currentAiMessageController: TextEditingController(),
        messages: [],
        prompt: "",
        aiResponse: ValueNotifier<String>(""),
      );

  copyWith({
    TextEditingController? currentAiMessageController,
    List<MessageEntity>? messages,
    bool? aiMessageInitialized,
    bool? isLoading,
    String? prompt,
    ValueNotifier<String>? aiResponse,
  }) =>
      AiState(
        prompt: "",
        currentAiMessageController:
            currentAiMessageController ?? this.currentAiMessageController,
        messages: messages ?? this.messages,
        aiMessageInitialized: aiMessageInitialized ?? this.aiMessageInitialized,
        isLoading: isLoading ?? this.isLoading,
        aiResponse: aiResponse ?? this.aiResponse,
      );
}
