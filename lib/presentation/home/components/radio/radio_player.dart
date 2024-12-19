import 'dart:developer';

import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';
import '../../home_state.dart';

class RadioPlayer extends StatelessWidget {
  const RadioPlayer({super.key});

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        final controller = state.controller;
        final station = state.currentStation;
        final isMuted = station.isMuted;
        log("PLAYER LOG: ${controller.value.playerState}");
        return YoutubePlayerScaffold(
            controller: controller,
            builder: (context, player) {
              return YoutubePlayerControllerProvider(
                controller: controller,
                child: Row(
                  children: [
                    YoutubeValueBuilder(
                      controller: controller,
                      builder: (context, value) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                                left: -1000,
                                top: -1000,
                                child: SizedBox(
                                    width: 000001,
                                    height: 000001,
                                    child: player)),
                            IconButton(
                              icon: Icon(
                                value.playerState == PlayerState.playing
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                              onPressed: () {
                                value.playerState == PlayerState.playing
                                    ? context.ytController.pauseVideo()
                                    : context.ytController.playVideo();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    YoutubeValueBuilder(
                      builder: (context, value) {
                        return IconButton(
                          icon: Icon(
                              isMuted ? Icons.volume_off : Icons.volume_up),
                          onPressed: () {
                            cubit.toggleStationMute();
                            isMuted
                                ? context.ytController.unMute()
                                : context.ytController.mute();
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            });
      },
    );
  }
}
