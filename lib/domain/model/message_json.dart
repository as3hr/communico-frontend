import 'package:communico_frontend/domain/entities/group_entity.dart';
import 'package:communico_frontend/domain/model/chat_json.dart';
import 'package:communico_frontend/domain/model/group_json.dart';
import 'package:communico_frontend/domain/model/user_json.dart';

import '../entities/chat_entity.dart';
import '../entities/message_entity.dart';
import '../entities/user_entity.dart';
import 'base_model.dart';

class MessageJson implements BaseModel<MessageEntity> {
  int id;
  String text;
  DateTime timeStamp;
  int userId;
  UserEntity? sender;
  ChatEntity? chat;
  GroupEntity? group;
  int? chatId;
  int? groupId;

  MessageJson({
    required this.id,
    required this.text,
    required this.timeStamp,
    required this.userId,
    this.chat,
    this.group,
    this.groupId,
    this.chatId,
    this.sender,
  });

  factory MessageJson.fromJson(Map<String, dynamic> json) => MessageJson(
        id: json["id"],
        text: json["text"],
        timeStamp: DateTime.tryParse(json["timestamp"] ?? "") ?? DateTime.now(),
        userId: json["userId"],
        chatId: json["chatId"],
        sender: json["sender"] != null
            ? UserJson.fromJson(json["sender"]).toDomain()
            : null,
        chat: json["chat"] != null
            ? ChatJson.fromJson(json["chat"]).toDomain()
            : null,
        group: json["group"] != null
            ? GroupJson.fromJson(json["group"]).toDomain()
            : null,
        groupId: json["groupId"],
      );

  factory MessageJson.copyWith(MessageEntity entity) => MessageJson(
        id: entity.id,
        text: entity.text,
        timeStamp: entity.timeStamp,
        userId: entity.userId,
        chatId: entity.chatId,
        sender: entity.sender,
        chat: entity.chat,
        group: entity.group,
        groupId: entity.groupId,
      );

  @override
  MessageEntity toDomain() => MessageEntity(
        id: id,
        text: text,
        timeStamp: timeStamp,
        userId: userId,
        chatId: chatId,
        sender: sender,
        chat: chat,
        group: group,
        groupId: groupId,
      );

  Map<String, dynamic> toChatJson() => {
        "text": text,
        "timestamp": timeStamp.toIso8601String(),
        "userId": userId,
        "chatId": chatId,
      };

  Map<String, dynamic> toGroupJson() => {
        "text": text,
        "timestamp": timeStamp.toIso8601String(),
        "userId": userId,
        "groupId": groupId,
      };
}
