import 'package:communico_frontend/domain/entities/user_entity.dart';

class AuthState {
  String username;
  String? password;
  bool isLoading;
  bool passwordProtected;
  UserEntity user;

  AuthState({
    required this.user,
    this.password,
    required this.username,
    this.isLoading = false,
    this.passwordProtected = false,
  });

  factory AuthState.empty() => AuthState(
        username: "",
        user: UserEntity.empty(),
      );

  copyWith({
    String? username,
    bool? isLoading,
    UserEntity? user,
    String? password,
    bool? passwordProtected,
  }) =>
      AuthState(
        username: username ?? this.username,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        password: password ?? this.password,
        passwordProtected: passwordProtected ?? this.passwordProtected,
      );
}
