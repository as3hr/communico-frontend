import 'dart:ui';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/styles/app_images.dart';
import '../../../../helpers/styles/styles.dart';
import '../../../../helpers/widgets/animated_banner.dart';
import '../../../../helpers/widgets/theme_switch.dart';
import '../../../../helpers/widgets/vertical_divider.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import '../radio/radio_banner.dart';
import '../radio/radio_player.dart';

class HeaderContent extends StatefulWidget {
  const HeaderContent({
    super.key,
    required this.currentQuote,
    required this.logOut,
    required this.userName,
  });
  final String userName;
  final void Function() logOut;
  final String currentQuote;

  @override
  State<HeaderContent> createState() => _HeaderContentState();
}

class _HeaderContentState extends State<HeaderContent> {
  final cubit = getIt<HomeCubit>();
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: false,
        showFullscreenButton: false,
        mute: false,
        loop: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "welcome ${widget.userName}!",
              style: const TextStyle(
                fontSize: 20,
                color: AppColor.white,
                fontFamily: "Kanit",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            TabBar(
              isScrollable: true,
              dividerColor: Colors.transparent,
              padding: const EdgeInsets.all(0),
              indicatorColor: Colors.transparent,
              labelStyle: Styles.semiBoldStyle(
                fontSize: 15,
                color: context.colorScheme.onPrimary,
                family: FontFamily.montserrat,
              ),
              unselectedLabelStyle: Styles.mediumStyle(
                fontSize: 15,
                color: context.colorScheme.onPrimary.withOpacity(0.6),
                family: FontFamily.montserrat,
              ),
              tabs: [
                const Text("Direct Messages"),
                const Text("Group Messages"),
                Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        AppImages.aiGif,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text("Ask AI"),
                  ],
                ),
              ],
            ),
            const AppVerticalDivider(),
            Text(
              "Quote: ${widget.currentQuote}",
              style: Styles.mediumStyle(
                fontSize: 15,
                color: context.colorScheme.onPrimary,
                family: FontFamily.montserrat,
              ),
            ),
            const AppVerticalDivider(),
            Row(
              children: [
                Text(
                  "Local Time: ",
                  style: Styles.mediumStyle(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary.withOpacity(0.8),
                    family: FontFamily.montserrat,
                  ),
                ),
                DigitalClock(
                  showSeconds: true,
                  isLive: true,
                  textScaleFactor: 0.75,
                  padding: const EdgeInsets.all(5),
                  digitalClockTextColor: context.colorScheme.onPrimary,
                  datetime: DateTime.now(),
                ),
              ],
            ),
            const AppVerticalDivider(),
            Row(
              children: [
                Text(
                  "Light",
                  style: Styles.mediumStyle(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary,
                    family: FontFamily.montserrat,
                  ),
                ),
                const ThemeSwitch(),
                Text(
                  "Dark",
                  style: Styles.mediumStyle(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary,
                    family: FontFamily.montserrat,
                  ),
                ),
              ],
            ),
            const AppVerticalDivider(),
            Row(
              children: [
                Text(
                  "Stations ",
                  style: Styles.mediumStyle(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary,
                    family: FontFamily.montserrat,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: AnimatedBanner(
                            backgroundColor: Colors.black,
                            content: RadioBanner(
                              controller: controller,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.radio,
                  ),
                ),
                RadioPlayer(
                  controller: controller,
                ),
              ],
            ),
            const AppVerticalDivider(),
            IconButton(
              onPressed: () {
                widget.logOut.call();
              },
              icon: const Icon(
                Icons.power_settings_new_outlined,
                color: AppColor.red,
                size: 24,
              ),
              tooltip: 'Logout',
            ),
          ],
        );
      },
    );
  }
}
