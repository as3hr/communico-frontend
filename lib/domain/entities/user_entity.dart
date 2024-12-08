class UserEntity {
  String username;
  int id;

  UserEntity({
    required this.id,
    required this.username,
  });

  factory UserEntity.empty() => UserEntity(id: 0, username: "");
}
