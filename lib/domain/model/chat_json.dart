import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/message_json.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:communico_frontend/helpers/utils.dart';

class ChatJson {
  int id;
  List<ChatParticipantsEntity> participants;
  List<MessageEntity>? messages;

  ChatJson({
    required this.id,
    required this.participants,
    this.messages,
  });

  factory ChatJson.fromJson(Map<String, dynamic> json) => ChatJson(
        id: json["id"],
        participants:
            parseList(json["participants"], ChatParticipantsJson.fromJson)
                .map((particiapnt) => particiapnt.toDomain())
                .toList(),
        messages: json["messages"] != null
            ? parseList(json["messages"], MessageJson.fromJson)
                .map((message) => message.toDomain())
                .toList()
            : [],
      );

  factory ChatJson.copyWith(ChatEntity entity) => ChatJson(
        id: entity.id,
        participants: entity.participants,
        messages: entity.messages,
      );

  ChatEntity toDomain() => ChatEntity(
        id: id,
        participants: participants,
        messages: messages,
      );

  Map<String, dynamic> toJson() => {
        "participants":
            participants.map((participant) => participant.toJson()).toList(),
        "messages": messages?.map((message) => message.toChatJson()).toList(),
      };
}

class ChatParticipantsJson {
  int id;
  int userId;
  int chatId;
  UserEntity? user;
  ChatEntity? chat;

  ChatParticipantsJson({
    required this.chatId,
    required this.id,
    required this.userId,
    this.user,
    this.chat,
  });

  factory ChatParticipantsJson.fromJson(Map<String, dynamic> json) =>
      ChatParticipantsJson(
        chatId: json["chatId"],
        id: json["id"],
        userId: json["userId"],
        chat: json["chat"] != null
            ? ChatJson.fromJson(json["chat"]).toDomain()
            : null,
        user: json["user"] != null
            ? UserJson.fromJson(json["user"]).toDomain()
            : null,
      );

  factory ChatParticipantsJson.copyWith(ChatParticipantsEntity entity) =>
      ChatParticipantsJson(
        chatId: entity.chatId,
        id: entity.id,
        userId: entity.userId,
        chat: entity.chat,
        user: entity.user,
      );

  ChatParticipantsEntity toDomain() => ChatParticipantsEntity(
        chatId: chatId,
        id: id,
        userId: userId,
        chat: chat,
        user: user,
      );

  Map<String, dynamic> toJson() => {
        "chatId": chatId,
        "userId": userId,
      };
}
