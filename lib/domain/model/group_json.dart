import 'package:communico_frontend/domain/model/message_json.dart';
import 'package:communico_frontend/domain/model/user_json.dart';
import 'package:communico_frontend/helpers/utils.dart';

import '../entities/group_entity.dart';
import '../entities/message_entity.dart';
import '../entities/user_entity.dart';
import 'base_model.dart';

class GroupJson implements BaseModel<GroupEntity> {
  int id;
  String name;
  List<GroupMemberEntity> members;
  List<MessageEntity> messages;

  GroupJson({
    required this.id,
    required this.members,
    required this.name,
    List<MessageEntity>? messages,
  }) : messages = messages ?? [];

  factory GroupJson.copyWith(GroupEntity entity) => GroupJson(
        id: entity.id,
        name: entity.name,
        members: entity.members,
        messages: entity.messages,
      );

  factory GroupJson.fromJson(Map<String, dynamic> json) => GroupJson(
        id: json["id"],
        name: json["name"],
        members: parseList(json["members"], GroupMemberJson.fromJson)
            .map((member) => member.toDomain())
            .toList(),
        messages: parseList(json["messages"], MessageJson.fromJson)
            .map((message) => message.toDomain())
            .toList(),
      );

  @override
  GroupEntity toDomain() => GroupEntity(
        id: id,
        name: name,
        members: members,
        messages: messages,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "members": members.map((member) => member.toJson()).toList(),
        "messages": messages.map((message) => message.toGroupJson()).toList(),
      };
}

class GroupMemberJson {
  int id;
  GroupEntity? group;
  UserEntity? user;
  int userId;
  int groupId;

  GroupMemberJson({
    required this.id,
    required this.groupId,
    required this.userId,
    this.group,
    this.user,
  });

  factory GroupMemberJson.copyWith(GroupMemberEntity entity) => GroupMemberJson(
        id: entity.id,
        groupId: entity.groupId,
        userId: entity.userId,
        user: entity.user,
        group: entity.group,
      );

  factory GroupMemberJson.fromJson(Map<String, dynamic> json) =>
      GroupMemberJson(
        id: json["id"],
        groupId: json["groupId"],
        userId: json["userId"],
        user: json["user"] != null
            ? UserJson.fromJson(json["user"]).toDomain()
            : null,
        group: json["group"] != null
            ? GroupJson.fromJson(json["group"]).toDomain()
            : null,
      );

  GroupMemberEntity toDomain() => GroupMemberEntity(
        id: id,
        groupId: groupId,
        userId: userId,
        group: group,
        user: user,
      );

  Map<String, dynamic> toJson() => {
        "groupId": groupId,
        "userId": userId,
      };
}
