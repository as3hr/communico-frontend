import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/group_json.dart';

class GroupEntity {
  int id;
  String name;
  List<GroupMemberEntity> members;
  List<MessageEntity> messages;

  GroupEntity({
    required this.id,
    required this.members,
    required this.name,
    List<MessageEntity>? messages,
  }) : messages = messages ?? [];

  factory GroupEntity.empty() => GroupEntity(
        id: 0,
        members: [],
        name: "",
      );

  Map<String, dynamic> toJson() => GroupJson.copyWith(this).toJson();
}

class GroupMemberEntity {
  int id;
  GroupEntity? group;
  UserEntity? user;
  int userId;
  int groupId;

  GroupMemberEntity({
    required this.id,
    required this.groupId,
    required this.userId,
    this.group,
    this.user,
  });

  Map<String, dynamic> toJson() => GroupMemberJson.copyWith(this).toJson();
}
