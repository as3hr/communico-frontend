import 'package:bloc/bloc.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.empty());

  fetchData() {}
}
