import 'dart:ui';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/radio/radio_banner.dart';
import 'package:communico_frontend/presentation/home/components/radio/radio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';

import '../../../di/service_locator.dart';
import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/styles/app_images.dart';
import '../../../helpers/styles/styles.dart';
import '../../../helpers/widgets/animated_banner.dart';
import '../../../helpers/widgets/theme_switch.dart';

import '../../../helpers/widgets/vertical_divider.dart';
import '../home_cubit.dart';
import '../home_state.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.userName, required this.logOut});
  final String userName;
  final void Function() logOut;

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: context.isMobile || context.isTablet
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: HeaderContent(
                              currentQuote: state.currentQuote,
                              logOut: logOut,
                              userName: userName))
                      : HeaderContent(
                          currentQuote: state.currentQuote,
                          logOut: logOut,
                          userName: userName,
                        )),
            ),
          ],
        );
      },
    );
  }
}

class HeaderContent extends StatelessWidget {
  const HeaderContent({
    super.key,
    required this.currentQuote,
    required this.logOut,
    required this.userName,
  });
  final String userName;
  final void Function() logOut;
  final String currentQuote;

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "welcome $userName!",
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
              "Quote: $currentQuote",
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
                  showSeconds: false,
                  isLive: true,
                  textScaleFactor: 0.75,
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
                          child: const AnimatedBanner(
                            backgroundColor: Colors.black,
                            content: RadioBanner(),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.radio,
                  ),
                ),
                const RadioPlayer(),
              ],
            ),
            const AppVerticalDivider(),
            IconButton(
              onPressed: () {
                logOut.call();
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
