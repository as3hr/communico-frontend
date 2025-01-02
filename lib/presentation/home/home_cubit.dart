import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:communico_frontend/helpers/constants.dart';
import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_cubit.dart';
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
import 'components/header/background.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState.empty());

  Future<void> fetchData() async {
    emit(state.copyWith(isLoading: true));
    socketInit();
    await Future.wait([
      sl<ChatCubit>().getChats(),
      sl<GroupCubit>().getGroups(),
    ]).then((_) {
      emit(state.copyWith(isLoading: false));
    });
  }

  socketInit() {
    socket.connect();
    socket.onConnect((_) {
      log('Connected to the Socket Server');
      socket.emit("joinApp", {
        "userId": user!.id,
      });
      sl<ChatCubit>().listenToChatEvents();
      sl<GroupCubit>().listenToGroupEvents();
      sl<AiCubit>().listenToAiResponse();
    });

    socket.onDisconnect((_) async {
      log('Disconnected from the Socket Server');
      socket.emit("leaveApp", {
        "userId": user!.id,
      });
    });

    socket.onError((error) {
      log('Socket Error: $error');
    });
  }

  void updateStation(Station station, BuildContext context,
      {bool disablePop = false}) {
    context.ytController.update(
      metaData: YoutubeMetaData(
        videoId: station.id,
        title: station.title,
      ),
      fullScreenOption: const FullScreenOption(enabled: false),
    );
    context.ytController.loadVideoById(videoId: station.id);
    emit(state.copyWith(currentStation: station));
  }

  bool isMyMessage(MessageEntity message) {
    return user != null && (user!.id == message.userId) ? true : false;
  }

  void closeStates() {
    emit(HomeState.empty());
    sl<ChatCubit>().empty();
    sl<GroupCubit>().empty();
    sl<AuthCubit>().empty();
    sl<AiCubit>().empty();
  }

  UserEntity? get user => sl<UserStore>().getUser();

  void startStation(BuildContext context) {
    if (state.currentStation == null) {
      context.ytController.loadVideoById(videoId: Station.stations.first.id);
      emit(state.copyWith(currentStation: Station.stations.first));
    }
  }

  void playNext(BuildContext context) {
    if (state.currentStation == null) {
      // just start with first station if there is no station currently being played
      startStation(context);
    } else {
      final currentStationIndex = Station.stations
          .indexWhere((station) => station.id == state.currentStation?.id);
      if (currentStationIndex == Station.stations.length - 1) {
        // if the station is the last one then play the first one at the list
        final station = Station.stations.first;
        updateStation(station, context);
      } else {
        // play the next station according to the index of the list.
        final station = Station.stations[currentStationIndex + 1];
        updateStation(station, context);
      }
    }
  }

  void updateBackground(Background background) {
    emit(state.copyWith(currentBackground: background));
  }

  void removeBg() {
    emit(state.copyWith(currentBackground: Background.empty()));
  }
}
