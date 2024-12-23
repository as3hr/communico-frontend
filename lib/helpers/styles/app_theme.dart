import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const colortheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.darkPrimary,
    onPrimary: AppColor.white,
    secondary: AppColor.darkSecondary,
    onSecondary: AppColor.grey,
    error: AppColor.red,
    onError: AppColor.white,
    surface: AppColor.darkBackground,
    onSurface: AppColor.grey,
  );

  static ThemeData theme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColor.darkBackground,
      useMaterial3: true,
      colorScheme: colortheme,
      fontFamily: "Varela",
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColor.black1,
        cursorColor: AppColor.white,
        selectionHandleColor: AppColor.white,
      ),
      textTheme: Typography.whiteCupertino,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
