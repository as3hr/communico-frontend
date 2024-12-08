import 'package:communico_frontend/domain/model/user_json.dart';

class UserEntity {
  String username;
  int id;

  UserEntity({
    required this.id,
    required this.username,
  });

  factory UserEntity.empty() => UserEntity(id: 0, username: "");

  Map<String, dynamic> toJson() => UserJson.copyWith(this).toJson();
}
