import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/helpers/constants.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_cubit.dart';
import 'package:communico_frontend/presentation/home/components/radio/station.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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
    ]).then((_) {
      emit(state.copyWith(isLoading: false));
    });
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

  void updateStation(Station station, BuildContext context) {
    context.ytController.stopVideo();
    context.ytController.update(
      metaData: YoutubeMetaData(
        videoId: station.id,
        title: station.title,
      ),
      fullScreenOption: const FullScreenOption(enabled: false),
    );
    context.ytController.loadVideoById(videoId: station.id);
    context.ytController.playVideo();
    emit(state.copyWith(currentStation: station));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  bool isMyMessage(MessageEntity message) {
    return user != null && (user!.id == message.userId) ? true : false;
  }

  void closeStates() {
    emit(HomeState.empty());
    getIt<ChatCubit>().empty();
    getIt<GroupCubit>().empty();
  }

  UserEntity? get user => getIt<UserStore>().getUser();
}
