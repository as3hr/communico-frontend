import 'package:communico_frontend/domain/entities/user_entity.dart';

class UserJson {
  String username;
  String? password;
  int id;

  UserJson({
    required this.id,
    required this.username,
    this.password,
  });

  factory UserJson.fromJson(Map<String, dynamic> json) {
    return UserJson(
      id: json["id"],
      username: json["username"],
      password: json["password"],
    );
  }

  UserEntity toDomain() => UserEntity(
        id: id,
        username: username,
        password: password,
      );

  factory UserJson.copyWith(UserEntity userEntity) => UserJson(
        id: userEntity.id,
        username: userEntity.username,
        password: userEntity.password,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
      };
}
