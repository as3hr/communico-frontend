import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/scroll_shader_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/styles/styles.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import 'station.dart';

class RadioBanner extends StatelessWidget {
  const RadioBanner({super.key, required this.controller});
  final YoutubePlayerController controller;

  static final cubit = sl<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return YoutubePlayerControllerProvider(
          controller: controller,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: 0.5.sw,
            height: 0.4.sh,
            child: Column(
              children: [
                Text(
                  'Radio Stations',
                  style: Styles.boldStyle(
                    fontSize: 28,
                    color: AppColor.white,
                    family: FontFamily.kanit,
                  ),
                ),
                Expanded(
                  child: ScrollShaderMask(
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: Station.stations.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          color: Colors.white54,
                          thickness: 0.5,
                        );
                      },
                      itemBuilder: (context, index) {
                        final station = Station.stations[index];
                        return YoutubeValueBuilder(
                          controller: controller,
                          builder: (context, value) {
                            bool sameStation =
                                station.id == state.currentStation?.id;
                            return InkWell(
                              onTap: () {
                                if (sameStation &&
                                    value.playerState == PlayerState.playing) {
                                  context.ytController.pauseVideo();
                                } else if (station.id ==
                                        state.currentStation?.id &&
                                    value.playerState == PlayerState.paused) {
                                  context.ytController.playVideo();
                                } else {
                                  cubit.updateStation(station, context);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        station.title,
                                        style: Styles.boldStyle(
                                          fontSize: 22,
                                          color: AppColor.white,
                                          family: FontFamily.kanit,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (sameStation &&
                                            value.playerState ==
                                                PlayerState.playing) {
                                          context.ytController.pauseVideo();
                                        } else if (station.id ==
                                                state.currentStation?.id &&
                                            value.playerState ==
                                                PlayerState.paused) {
                                          context.ytController.playVideo();
                                        } else {
                                          cubit.updateStation(station, context);
                                        }
                                      },
                                      iconSize: 30,
                                      color: AppColor.white,
                                      icon: Icon(
                                        (sameStation &&
                                                value.playerState ==
                                                    PlayerState.playing)
                                            ? Icons.pause_circle_filled
                                            : (sameStation &&
                                                    value.playerState ==
                                                        PlayerState.paused)
                                                ? Icons.play_circle_filled
                                                : (sameStation)
                                                    ? Icons.pause_circle_filled
                                                    : Icons.play_circle_filled,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
