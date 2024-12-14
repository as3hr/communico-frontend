import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/auth/auth_navigator.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:universal_html/html.dart';

import '../../domain/repositories/user_repository.dart';
import '../../helpers/utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;
  final AuthNavigator navigator;
  AuthCubit(this.userRepository, this.navigator) : super(AuthState.empty());

  void getIn() {
    emit(state.copyWith(isLoading: true));
    userRepository.getIn(state.username).then(
          (response) => response.fold(
            (error) {
              emit(state.copyWith(isLoading: false));
              showToast(error.error);
            },
            (user) async {
              emit(state.copyWith(isLoading: false, user: user));
              window.localStorage["user"] = jsonEncode(user);
              navigator.goToHome();
            },
          ),
        );
  }
}
