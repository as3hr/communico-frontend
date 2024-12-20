import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';

class RadioPlayer extends StatelessWidget {
  const RadioPlayer({super.key, required this.controller});
  final YoutubePlayerController controller;

  static final cubit = getIt<HomeCubit>();
  static final isMuted = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
        controller: controller,
        builder: (context, player) {
          return YoutubePlayerControllerProvider(
            controller: controller,
            child: YoutubeValueBuilder(
                controller: controller,
                builder: (context, value) {
                  final playerState = value.playerState;
                  return Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                              top: -1000,
                              left: -1000,
                              child: SizedBox(
                                  width: 0000001,
                                  height: 0000001,
                                  child: player)),
                          (playerState == PlayerState.buffering)
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: AppColor.grey,
                                  ),
                                )
                              : IconButton(
                                  icon: Icon(
                                    playerState == PlayerState.playing
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                  onPressed: () {
                                    cubit.startStation(context);
                                    playerState == PlayerState.playing
                                        ? context.ytController.pauseVideo()
                                        : context.ytController.playVideo();
                                  },
                                ),
                        ],
                      ),
                      ValueListenableBuilder<bool>(
                          valueListenable: isMuted,
                          builder: (context, value, _) {
                            return IconButton(
                              icon: Icon(
                                  value ? Icons.volume_off : Icons.volume_up),
                              onPressed: () {
                                isMuted.value = !isMuted.value;
                                value
                                    ? context.ytController.unMute()
                                    : context.ytController.mute();
                              },
                            );
                          })
                    ],
                  );
                }),
          );
        });
  }
}
