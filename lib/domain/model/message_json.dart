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
  MessageEntity? replyTo;
  int? chatId;
  int? groupId;
  int? replyToId;
  String? replyToText;
  String? replyToSender;

  MessageJson({
    required this.id,
    required this.text,
    required this.timeStamp,
    required this.userId,
    this.chat,
    this.replyToSender,
    this.replyToText,
    this.replyTo,
    this.group,
    this.groupId,
    this.chatId,
    this.sender,
    this.replyToId,
  });

  factory MessageJson.fromJson(Map<String, dynamic> json) => MessageJson(
        id: json["id"],
        text: json["text"],
        replyTo: json["replyTo"] != null
            ? MessageJson.fromJson(json["replyTo"]).toDomain()
            : null,
        replyToText: json["replyToText"],
        replyToSender: json["replyToSender"],
        replyToId: json["replyToId"],
        timeStamp: DateTime.tryParse(json["timestamp"] ?? "")?.toLocal() ??
            DateTime.now().toLocal(),
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
        replyTo: entity.replyTo,
        replyToId: entity.replyToId,
        replyToSender: entity.replyToSender,
        replyToText: entity.replyToText,
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
        replyTo: replyTo,
        replyToId: replyToId,
        replyToSender: replyToSender,
        replyToText: replyToText,
      );

  Map<String, dynamic> toChatJson() => {
        "id": id,
        "text": text,
        "timestamp": timeStamp.toIso8601String(),
        "userId": userId,
        "chatId": chatId,
        "replyToId": replyToId,
      };

  Map<String, dynamic> toGroupJson() => {
        "id": id,
        "text": text,
        "timestamp": timeStamp.toIso8601String(),
        "userId": userId,
        "groupId": groupId,
        "replyToId": replyToId,
      };
}
