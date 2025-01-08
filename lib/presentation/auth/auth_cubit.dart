import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/repositories/auth_repository.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart';
import '../../domain/repositories/user_repository.dart';
import '../../helpers/utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;
  final AuthRepository authRepository;
  AuthCubit(this.userRepository, this.authRepository)
      : super(AuthState.empty());

  void verifyToken() {
    emit(state.copyWith(isLoading: true));
    authRepository.verifyToken().then((response) => response.fold((error) {
          emit(state.copyWith(isAuthenticated: false, isLoading: false));
        }, (value) {
          emit(state.copyWith(isAuthenticated: value, isLoading: false));
        }));
  }

  void logOut() {
    window.localStorage['authToken'] = "";
    emit(state.copyWith(isAuthenticated: false));
  }

  void getIn({String? username}) {
    userRepository
        .getIn(username: username ?? state.username, password: state.password)
        .then(
          (response) => response.fold(
            (error) {
              if (error.error.trim() == "Password Protected!") {
                emit(state.copyWith(passwordProtected: true));
                showToast("This account is Password Protected!");
              } else {
                showToast(error.error);
              }
            },
            (user) async {
              emit(state.copyWith(
                isAuthenticated: true,
                user: user,
                username: "",
                password: "",
              ));
            },
          ),
        );
  }

  void updatePassword(BuildContext context) {
    emit(state.copyWith(isLoading: true));
    userRepository.updatePassword(password: state.password!).then(
          (response) => response.fold(
            (error) {
              emit(state.copyWith(isLoading: false));
              showToast(error.error);
              Navigator.pop(context);
            },
            (user) {
              emit(state.copyWith(isLoading: false));
              Navigator.pop(context);
              showToast(
                "Password Updated Successfully!",
                backgroundColor: Colors.blue,
              );
            },
          ),
        );
  }

  empty() => emit(AuthState.empty());
}
