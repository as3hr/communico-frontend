import 'package:communico_frontend/domain/entities/user_entity.dart';

class AuthState {
  String username;
  bool isLoading;
  UserEntity user;
  AuthState({
    required this.user,
    required this.username,
    this.isLoading = false,
  });

  factory AuthState.empty() => AuthState(
        username: "",
        user: UserEntity.empty(),
      );

  copyWith({String? username, bool? isLoading, UserEntity? user}) => AuthState(
        username: username ?? this.username,
        isLoading: isLoading ?? this.isLoading,
        user: user ?? this.user,
      );
}
