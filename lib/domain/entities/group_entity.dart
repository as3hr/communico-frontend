import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/group_json.dart';

import '../model/paginate.dart';

class GroupEntity {
  int id;
  String name;
  List<GroupMemberEntity> members;
  List<MessageEntity> messages;
  Paginate<MessageEntity> messagePagination;

  GroupEntity({
    this.id = 0,
    required this.members,
    required this.name,
    Paginate<MessageEntity>? messagePagination,
    List<MessageEntity>? messages,
  })  : messages = messages ?? [],
        messagePagination = messagePagination ?? Paginate.empty();

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
    this.id = 0,
    this.groupId = 0,
    required this.userId,
    this.group,
    this.user,
  });

  Map<String, dynamic> toJson() => GroupMemberJson.copyWith(this).toJson();
}
