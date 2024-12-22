import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/presentation/home/components/radio/station.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/styles.dart';
import '../../home_state.dart';

class RadioBanner extends StatelessWidget {
  const RadioBanner({super.key, required this.controller});
  final YoutubePlayerController controller;

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return YoutubePlayerControllerProvider(
          controller: controller,
          child: Container(
            color: Colors.transparent,
            width: 0.5.sw,
            height: 0.4.sh,
            child: ListView.separated(
              itemCount: Station.stations.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: AppColor.white,
                  thickness: 0.3,
                );
              },
              itemBuilder: (context, index) {
                final station = Station.stations[index];
                return YoutubeValueBuilder(
                    controller: controller,
                    builder: (context, value) {
                      return InkWell(
                        onTap: () {
                          cubit.updateStation(station, context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                2.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    station.title.toLowerCase(),
                                    style: Styles.boldStyle(
                                      fontSize: 25,
                                      color: AppColor.white,
                                      family: FontFamily.kanit,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    cubit.updateStation(station, context);
                                  },
                                  iconSize: 20,
                                  color: AppColor.white,
                                  icon: Icon(
                                    station.id == state.currentStation?.id
                                        ? Icons.pause
                                        : Icons.play_arrow_outlined,
                                  ),
                                ),
                                2.horizontalSpace,
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        );
      },
    );
  }
}
