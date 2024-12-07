class AuthState {
  String username;
  bool isLoading;
  AuthState({
    required this.username,
    this.isLoading = false,
  });

  factory AuthState.empty() => AuthState(
        username: "",
      );

  copyWith({String? username, bool? isLoading}) => AuthState(
        username: username ?? this.username,
        isLoading: isLoading ?? this.isLoading,
      );
}
