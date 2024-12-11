import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/helpers/constants.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_cubit.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../di/service_locator.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/stores/user_store.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.empty());

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));
    socketInit();
    await Future.wait([
      getIt<ChatCubit>().getChats(),
      getIt<GroupCubit>().getGroups(),
    ]);
    emit(state.copyWith(isLoading: false));
  }

  socketInit() {
    socket.connect();
    socket.onConnect((_) {
      log('Connected to the Socket Server');
    });
    getIt<ChatCubit>().listenToDirectMessage();
    getIt<GroupCubit>().listenToGroupMessage();
    socket.onDisconnect((_) {
      log('Disconnected from the Socket Server');
    });
  }

  bool isMyMessage(MessageEntity message) {
    return user != null && (user!.id == message.userId) ? true : false;
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
