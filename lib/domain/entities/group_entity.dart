import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/domain/entities/user_entity.dart';
import 'package:communico_frontend/domain/model/group_json.dart';

import '../model/paginate.dart';

class GroupEntity {
  int id;
  String name;
  String? link;
  List<GroupMemberEntity> members;
  List<MessageEntity> messages;
  Paginate<MessageEntity> messagePagination;

  GroupEntity({
    this.id = 0,
    required this.members,
    required this.name,
    this.link,
    Paginate<MessageEntity>? messagePagination,
    List<MessageEntity>? messages,
  })  : messages = messages ?? [],
        messagePagination = messagePagination ?? Paginate.empty();

  factory GroupEntity.empty() => GroupEntity(
        id: 0,
        members: [],
        name: "",
      );

  GroupEntity copyWith({
    int? id,
    String? name,
    String? link,
    bool? seen,
    List<GroupMemberEntity>? members,
    List<MessageEntity>? messages,
    Paginate<MessageEntity>? messagePagination,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      link: link ?? this.link,
      name: name ?? this.name,
      members: members ?? this.members,
      messages: messages ?? this.messages,
      messagePagination: messagePagination ?? this.messagePagination,
    );
  }

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
