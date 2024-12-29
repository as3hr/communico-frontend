import 'package:communico_frontend/domain/entities/chat_entity.dart';

class SharedChatState {
  ChatEntity chat;
  bool isLoading;
  bool messageLoading;

  SharedChatState({
    required this.chat,
    this.isLoading = false,
    this.messageLoading = false,
  });

  factory SharedChatState.empty() => SharedChatState(
        chat: ChatEntity.empty(),
      );

  SharedChatState copyWith({
    ChatEntity? chat,
    bool? isLoading,
    bool? messageLoading,
  }) {
    return SharedChatState(
      chat: chat ?? this.chat,
      isLoading: isLoading ?? this.isLoading,
      messageLoading: messageLoading ?? this.messageLoading,
    );
  }
}
