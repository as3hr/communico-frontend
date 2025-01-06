import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/components/header/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:one_clock/one_clock.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/styles/styles.dart';
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
    required this.updatePassword,
    required this.userName,
  });
  final String userName;
  final void Function() logOut;
  final void Function() updatePassword;
  final String currentQuote;

  @override
  State<HeaderContent> createState() => _HeaderContentState();
}

class _HeaderContentState extends State<HeaderContent> {
  final cubit = sl<HomeCubit>();
  late YoutubePlayerController controller;
  final scrollController = ScrollController();

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
        return Scrollbar(
          thickness: 6,
          controller: scrollController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "welcome ${widget.userName}!",
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppColor.white,
                    fontFamily: "Kanit",
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
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
                    AnimatedTextKit(
                      repeatForever: true,
                      onTap: () {
                        DefaultTabController.of(context).animateTo(2);
                      },
                      pause: const Duration(milliseconds: 500),
                      animatedTexts: [
                        ColorizeAnimatedText(
                          "Ask AI",
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: "kanit",
                          ),
                          colors: [
                            Colors.purple,
                            Colors.blue,
                            Colors.yellow,
                            Colors.red,
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                Text(
                  "Quote: ${widget.currentQuote}",
                  style: Styles.boldStyle(
                    fontSize: 15,
                    color: const Color(0xffE3E9EC),
                    family: FontFamily.montserrat,
                  ),
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                Row(
                  children: [
                    Text(
                      "Local Time: ",
                      style: Styles.boldStyle(
                        fontSize: 15,
                        color: const Color(0xffE3E9EC),
                        family: FontFamily.montserrat,
                      ),
                    ),
                    DigitalClock(
                      showSeconds: true,
                      isLive: true,
                      textScaleFactor: 0.75,
                      padding: const EdgeInsets.all(5),
                      digitalClockTextColor: const Color(0xffE3E9EC),
                      datetime: DateTime.now().toLocal(),
                    ),
                  ],
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                Row(
                  children: [
                    Text(
                      "Backgrounds: ",
                      style: Styles.boldStyle(
                        fontSize: 15,
                        color: const Color(0xffE3E9EC),
                        family: FontFamily.montserrat,
                      ),
                    ),
                    DropdownMenu<Background>(
                        menuStyle: const MenuStyle(
                          alignment: Alignment.bottomLeft,
                        ),
                        hintText: state.currentBackground?.title ?? "Select",
                        textStyle: Styles.boldStyle(
                          fontSize: 15,
                          color: const Color(0xffE3E9EC),
                          family: FontFamily.kanit,
                        ),
                        enableSearch: false,
                        textAlign: TextAlign.center,
                        inputDecorationTheme: const InputDecorationTheme(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        enableFilter: false,
                        requestFocusOnTap: false,
                        onSelected: (background) {
                          if (background != null) {
                            cubit.updateBackground(background);
                          }
                        },
                        dropdownMenuEntries:
                            state.backgrounds.map((background) {
                          return DropdownMenuEntry<Background>(
                            value: background,
                            label: background.title,
                            labelWidget: Text(
                              background.title,
                              style: Styles.mediumStyle(
                                fontSize: 15,
                                color: context.colorScheme.onPrimary,
                                family: FontFamily.kanit,
                              ),
                            ),
                          );
                        }).toList()),
                    if (state.currentBackground?.image.isNotEmpty ?? false)
                      IconButton(
                        onPressed: () {
                          cubit.removeBg();
                        },
                        icon: const Icon(
                          Icons.highlight_remove_sharp,
                          color: AppColor.red,
                          size: 24,
                        ),
                        tooltip: 'Remove Background',
                      ),
                  ],
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                Row(
                  children: [
                    Text(
                      "Stations ",
                      style: Styles.mediumStyle(
                        fontSize: 15,
                        color: const Color(0xffE3E9EC),
                        family: FontFamily.montserrat,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showAppDialog(
                            context, RadioBanner(controller: controller));
                      },
                      icon: const Icon(
                        Icons.radio,
                        color: Color(0xFFb07154),
                      ),
                      tooltip: "Radio",
                    ),
                    RadioPlayer(
                      controller: controller,
                    ),
                  ],
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                IconButton(
                  onPressed: () {
                    widget.updatePassword.call();
                  },
                  icon: const Icon(
                    Icons.lock_reset,
                    color: Colors.blue,
                    size: 24,
                  ),
                  tooltip: 'Add/Update Password',
                ),
                3.horizontalSpace,
                const AppVerticalDivider(),
                3.horizontalSpace,
                IconButton(
                  onPressed: () async {
                    if (await showConfirmationDialog(
                        "Are you sure you want to logout?")) {
                      widget.logOut.call();
                    }
                  },
                  icon: const Icon(
                    Icons.power_settings_new_outlined,
                    color: AppColor.red,
                    size: 24,
                  ),
                  tooltip: 'Logout',
                ),
                3.horizontalSpace,
              ],
            ),
          ),
        );
      },
    );
  }
}
