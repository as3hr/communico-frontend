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
                  final isPlaying = value.playerState == PlayerState.playing;

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
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                            onPressed: () {
                              isPlaying
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
