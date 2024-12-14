import 'package:communico_frontend/domain/model/chat_json.dart';
import 'package:communico_frontend/domain/model/paginate.dart';

import 'message_entity.dart';
import 'user_entity.dart';

class ChatEntity {
  int id;
  List<ChatParticipantsEntity> participants;
  List<MessageEntity> messages;
  Paginate<MessageEntity> messagePagination;

  ChatEntity({
    this.id = 0,
    required this.participants,
    required this.messages,
    Paginate<MessageEntity>? messagePagination,
  }) : messagePagination = messagePagination ?? Paginate.empty();

  ChatEntity copyWith({
    int? id,
    List<ChatParticipantsEntity>? participants,
    List<MessageEntity>? messages,
    Paginate<MessageEntity>? messagePagination,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      messages: messages ?? this.messages,
      messagePagination: messagePagination ?? this.messagePagination,
    );
  }

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
