import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/auth/auth_navigator.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';

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
              } else {
                emit(state.copyWith(isLoading: false));
              }
              showToast(error.error);
            },
            (user) async {
              emit(state.copyWith(isLoading: false, user: user));
              navigator.goToHome();
            },
          ),
        );
  }
}
