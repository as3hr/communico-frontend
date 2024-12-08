import 'package:communico_frontend/domain/model/chat_json.dart';

import 'message_entity.dart';
import 'user_entity.dart';

class ChatEntity {
  int id;
  List<ChatParticipantsEntity> participants;
  List<MessageEntity>? messages;

  ChatEntity({
    required this.id,
    required this.participants,
    this.messages,
  });

  factory ChatEntity.empty() => ChatEntity(id: 0, participants: []);

  Map<String, dynamic> toJson() => ChatJson.copyWith(this).toJson();
}

class ChatParticipantsEntity {
  int id;
  int userId;
  int chatId;
  UserEntity? user;
  ChatEntity? chat;

  ChatParticipantsEntity({
    required this.chatId,
    required this.id,
    required this.userId,
    this.user,
    this.chat,
  });

  Map<String, dynamic> toJson() => ChatParticipantsJson.copyWith(this).toJson();
}
