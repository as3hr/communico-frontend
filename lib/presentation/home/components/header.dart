import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/radio/radio_player.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/styles/app_images.dart';
import '../../../helpers/styles/styles.dart';
import '../../../helpers/widgets/theme_switch.dart';

import 'dart:math';

import '../../../helpers/widgets/vertical_divider.dart';

class Header extends StatefulWidget {
  const Header({super.key, required this.userName, required this.logOut});
  final String userName;
  final void Function() logOut;
  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  final List<String> quotes = [
    "Live with purpose.",
    "Dream big daily.",
    "Joy is a choice.",
    "Simplify your life.",
    "Hustle and grow.",
    "Cherish small moments.",
    "Stay curious always.",
    "Learn, adapt, thrive.",
    "Kindness is power.",
    "Create your legacy.",
  ];

  late String currentQuote;

  @override
  void initState() {
    super.initState();
    currentQuote = quotes[Random().nextInt(quotes.length)];
  }

  @override
  Widget build(BuildContext context) {
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
                          currentQuote: currentQuote,
                          logOut: widget.logOut,
                          userName: widget.userName))
                  : HeaderContent(
                      currentQuote: currentQuote,
                      logOut: widget.logOut,
                      userName: widget.userName,
                    )),
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
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
              "Radio: ",
              style: Styles.mediumStyle(
                fontSize: 15,
                color: context.colorScheme.onPrimary,
                family: FontFamily.montserrat,
              ),
            ),
            const RadioPlayer(videoId: "jfKfPfyJRdk"),
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
  }
}
