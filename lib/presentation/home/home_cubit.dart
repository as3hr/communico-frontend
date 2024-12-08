import 'package:bloc/bloc.dart';
import 'package:communico_frontend/domain/repositories/user_repository.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserRepository userRepository;
  HomeCubit(this.userRepository) : super(HomeState.empty());

  Future<void> fetchPosts() async {
    emit(state.copyWith(isLoading: true));
    userRepository.getIn("").then(
          (response) => response.fold(
            (error) {
              emit(state.copyWith(isLoading: false));
              showToast(error.error);
            },
            (posts) {
              emit(state.copyWith(isLoading: false));
            },
          ),
        );
  }
}
