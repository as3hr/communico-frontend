import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/auth/auth_navigator.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';

import '../../domain/repositories/user_repository.dart';
import '../../helpers/utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;
  final AuthNavigator navigator;
  AuthCubit(this.userRepository, this.navigator) : super(AuthState.empty());

  void getIn() {
    emit(state.copyWith(isLoading: true));
    userRepository
        .getIn(username: state.username, password: state.password)
        .then(
          (response) => response.fold(
            (error) {
              if (error.error.trim() == "Password Protected!") {
                emit(state.copyWith(isLoading: false, passwordProtected: true));
                showToast("This account is Password Protected!");
              } else {
                emit(state.copyWith(isLoading: false));
                showToast(error.error);
              }
            },
            (user) async {
              navigator.goToHome();
              emit(state.copyWith(
                isLoading: false,
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
