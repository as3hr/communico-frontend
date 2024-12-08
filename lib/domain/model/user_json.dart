import 'package:communico_frontend/domain/entities/user_entity.dart';

class UserJson {
  String username;
  int id;

  UserJson({
    required this.id,
    required this.username,
  });

  factory UserJson.fromJson(Map<String, dynamic> json) => UserJson(
        username: json["username"],
        id: json["id"],
      );

  UserEntity toDomain() => UserEntity(
        username: username,
        id: id,
      );
}
