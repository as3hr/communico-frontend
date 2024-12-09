import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/message_json.dart';

import 'group_entity.dart';

class MessageEntity {
  int id;
  String text;
  DateTime timeStamp;
  int userId;
  UserEntity? sender;
  ChatEntity? chat;
  GroupEntity? group;
  int? chatId;
  int? groupId;
  bool isAi; // for identifying ai messages in room

  MessageEntity({
    this.id = 0,
    required this.text,
    this.isAi = false,
    DateTime? timeStamp,
    required this.userId,
    this.chat,
    this.group,
    this.groupId,
    this.chatId,
    this.sender,
  }) : timeStamp = timeStamp ?? DateTime.now();

  Map<String, dynamic> toChatJson() => MessageJson.copyWith(this).toChatJson();

  Map<String, dynamic> toGroupJson() =>
      MessageJson.copyWith(this).toGroupJson();
}
