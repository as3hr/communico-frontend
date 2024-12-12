import 'package:communico_frontend/domain/model/chat_json.dart';

import 'message_entity.dart';
import 'user_entity.dart';

class ChatEntity {
  int id;
  List<ChatParticipantsEntity> participants;
  List<MessageEntity> messages;

  ChatEntity({
    this.id = 0,
    required this.participants,
    required this.messages,
  });

  factory ChatEntity.empty() =>
      ChatEntity(id: 0, participants: [], messages: []);

  Map<String, dynamic> toJson() => ChatJson.copyWith(this).toJson();
}

class ChatParticipantsEntity {
  int id;
  int userId;
  int chatId;
  UserEntity? user;
  ChatEntity? chat;

  ChatParticipantsEntity({
    this.chatId = 0,
    this.id = 0,
    required this.userId,
    this.user,
    this.chat,
  });

  Map<String, dynamic> toJson() => ChatParticipantsJson.copyWith(this).toJson();
}
