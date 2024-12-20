import 'package:communico_frontend/domain/model/user_json.dart';

class UserEntity {
  String username;
  String? password;
  int id;
  bool isSelected;

  UserEntity({
    this.isSelected = false,
    required this.id,
    this.password,
    required this.username,
  });

  factory UserEntity.empty() => UserEntity(id: 0, username: "", password: "");

  Map<String, dynamic> toJson() => UserJson.copyWith(this).toJson();
}
