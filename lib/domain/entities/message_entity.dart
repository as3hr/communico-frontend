import 'package:communico_frontend/domain/entities/chat_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/message_json.dart';
import 'package:flutter/cupertino.dart';

import 'group_entity.dart';

class MessageEntity {
  int id;
  String text;
  DateTime timeStamp;
  int userId;
  UserEntity? sender;
  ChatEntity? chat;
  MessageEntity? replyTo;
  GroupEntity? group;
  int? chatId;
  int? groupId;
  int? replyToId;
  bool isAi; // for identifying ai messages in room
  ValueNotifier<bool> isHovered; // for identifying hoverState in chatRoom

  MessageEntity({
    this.id = 0,
    ValueNotifier<bool>? isHovered,
    required this.text,
    this.isAi = false,
    DateTime? timeStamp,
    required this.userId,
    this.chat,
    this.group,
    this.groupId,
    this.chatId,
    this.sender,
    this.replyTo,
    this.replyToId,
  })  : timeStamp = timeStamp ?? DateTime.now(),
        isHovered = isHovered ?? ValueNotifier<bool>(false);

  MessageEntity copyWith({
    int? id,
    String? text,
    DateTime? timeStamp,
    int? userId,
    UserEntity? sender,
    ChatEntity? chat,
    GroupEntity? group,
    int? chatId,
    int? groupId,
    int? replyToId,
    MessageEntity? replyTo,
    bool? isAi,
    ValueNotifier<bool>? isHovered,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      isAi: isAi ?? this.isAi,
      timeStamp: timeStamp ?? this.timeStamp,
      userId: userId ?? this.userId,
      chat: chat ?? this.chat,
      group: group ?? this.group,
      chatId: chatId ?? this.chatId,
      groupId: groupId ?? this.groupId,
      sender: sender ?? this.sender,
      isHovered: isHovered ?? this.isHovered,
      replyTo: replyTo ?? this.replyTo,
      replyToId: replyToId ?? this.replyToId,
    );
  }

  Map<String, dynamic> toChatJson() => MessageJson.copyWith(this).toChatJson();

  Map<String, dynamic> toGroupJson() =>
      MessageJson.copyWith(this).toGroupJson();
}
