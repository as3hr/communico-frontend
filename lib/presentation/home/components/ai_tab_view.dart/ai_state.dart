import 'dart:async';

import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';

class AiState {
  final controller = StreamController<String>.broadcast(sync: true);
  TextEditingController currentAiMessageController;
  List<MessageEntity> messages;
  bool aiMessageInitialized;
  bool isLoading;
  String prompt;

  AiState({
    required this.prompt,
    required this.currentAiMessageController,
    required this.messages,
    this.isLoading = false,
    this.aiMessageInitialized = false,
  });

  factory AiState.empty() => AiState(
        currentAiMessageController: TextEditingController(),
        messages: [],
        prompt: "",
      );

  copyWith({
    TextEditingController? currentAiMessageController,
    List<MessageEntity>? messages,
    bool? aiMessageInitialized,
    bool? isLoading,
    String? prompt,
  }) =>
      AiState(
        prompt: "",
        currentAiMessageController:
            currentAiMessageController ?? this.currentAiMessageController,
        messages: messages ?? this.messages,
        aiMessageInitialized: aiMessageInitialized ?? this.aiMessageInitialized,
        isLoading: isLoading ?? this.isLoading,
      );
}
