import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../helpers/styles/app_colors.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: adaptiveTheme.modeChangeNotifier,
            builder: (context, theme, child) {
              return SizedBox(
                height: 0.03.sh,
                child: FlutterSwitch(
                  value: adaptiveTheme.mode.isDark,
                  padding: 4.0,
                  activeColor: AppColor.darkBackground,
                  inactiveColor: AppColor.grey.withOpacity(0.15),
                  activeIcon: const Icon(
                    Icons.dark_mode,
                    color: AppColor.black3,
                  ),
                  inactiveIcon: const Icon(
                    Icons.light_mode,
                    color: AppColor.mango,
                  ),
                  onToggle: (value) {
                    adaptiveTheme.setThemeMode(
                      value ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
