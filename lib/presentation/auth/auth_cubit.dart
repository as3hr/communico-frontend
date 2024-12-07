import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.empty());

  void getIn() {
    emit(state.copyWith(isLoading: true));
    // TODO: implement getIn
    emit(state.copyWith(isLoading: false));
  }
}
