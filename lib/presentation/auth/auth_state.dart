import 'package:communico_frontend/domain/entities/user_entity.dart';

class AuthState {
  String username;
  String? password;
  bool isLoading;
  bool isAuthenticated;
  bool passwordProtected;
  UserEntity user;

  AuthState({
    required this.user,
    this.password,
    this.isAuthenticated = false,
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
    bool? isAuthenticated,
    UserEntity? user,
    String? password,
    bool? passwordProtected,
  }) =>
      AuthState(
        username: username ?? this.username,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
        password: password ?? this.password,
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        passwordProtected: passwordProtected ?? this.passwordProtected,
      );
}
