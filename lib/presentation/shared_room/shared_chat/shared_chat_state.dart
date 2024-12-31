import 'package:communico_frontend/domain/entities/chat_entity.dart';

class SharedChatState {
  ChatEntity chat;
  bool isLoading;
  bool messageLoading;
  String encryptedData;

  SharedChatState({
    required this.chat,
    this.isLoading = false,
    this.messageLoading = false,
    this.encryptedData = "",
  });

  factory SharedChatState.empty() => SharedChatState(
        chat: ChatEntity.empty(),
      );

  SharedChatState copyWith({
    ChatEntity? chat,
    bool? isLoading,
    bool? messageLoading,
    String? encryptedData,
  }) {
    return SharedChatState(
      chat: chat ?? this.chat,
      isLoading: isLoading ?? this.isLoading,
      messageLoading: messageLoading ?? this.messageLoading,
      encryptedData: encryptedData ?? this.encryptedData,
    );
  }
}
