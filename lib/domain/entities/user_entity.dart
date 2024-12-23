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

  UserEntity copyWith({
    String? username,
    String? password,
    int? id,
    bool? isSelected,
  }) =>
      UserEntity(
        id: id ?? this.id,
        password: password ?? this.password,
        username: username ?? this.username,
        isSelected: isSelected ?? this.isSelected,
      );

  factory UserEntity.empty() => UserEntity(id: 0, username: "", password: "");

  Map<String, dynamic> toJson() => UserJson.copyWith(this).toJson();
}
