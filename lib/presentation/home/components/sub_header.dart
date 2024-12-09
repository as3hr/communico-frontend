import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:one_clock/one_clock.dart';

import '../../../helpers/styles/app_images.dart';
import '../../../helpers/widgets/theme_switch.dart';

import 'dart:math';

class SubHeader extends StatefulWidget {
  const SubHeader({super.key});

  @override
  State<SubHeader> createState() => _SubHeaderState();
}

class _SubHeaderState extends State<SubHeader> {
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
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TabBar(
                  indicatorColor: Colors.transparent,
                  indicatorPadding: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                  labelPadding: const EdgeInsets.only(left: 15, right: 15),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  onTap: (index) {},
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
                const Text("|"),
                Text("Quote: $currentQuote"),
                const Text("|"),
                Row(
                  children: [
                    const Text("Local Time: "),
                    DigitalClock(
                      showSeconds: false,
                      isLive: true,
                      textScaleFactor: 0.85,
                      digitalClockTextColor: AppColor.white,
                      datetime: DateTime.now(),
                    ),
                  ],
                ),
                const Text("|"),
                const Text("Theme: "),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Light"),
                    ThemeSwitch(),
                    Text("Dark"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
