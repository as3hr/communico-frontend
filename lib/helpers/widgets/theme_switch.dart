import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

import '../../../helpers/styles/app_colors.dart';

class ThemeSwitch extends StatelessWidget {
  const ThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final adaptiveTheme = AdaptiveTheme.of(context);
    return ValueListenableBuilder(
      valueListenable: adaptiveTheme.modeChangeNotifier,
      builder: (context, theme, child) {
        return Container(
          height: 30,
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FlutterSwitch(
            value: adaptiveTheme.mode.isDark,
            padding: 3.0,
            toggleSize: 20,
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
    );
  }
}
