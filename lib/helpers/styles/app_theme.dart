import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // static const colortheme = ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: AppColor.darkPrimary,
  //   onPrimary: AppColor.white,
  //   secondary: AppColor.darkSecondary,
  //   onSecondary: AppColor.grey,
  //   error: AppColor.red,
  //   onError: AppColor.white,
  //   surface: AppColor.darkBackground,
  //   onSurface: AppColor.grey,
  // );

  static const colortheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.primaryColor,
    onPrimary: AppColor.white,
    secondary: AppColor.secondaryColor,
    onSecondary: AppColor.grey,
    error: AppColor.red,
    onError: AppColor.white,
    surface: AppColor.primaryColor,
    onSurface: AppColor.coolGray,
  );

  static ThemeData theme() {
    return ThemeData(
      scaffoldBackgroundColor: AppColor.primaryColor,
      useMaterial3: true,
      colorScheme: colortheme,
      fontFamily: "Montserrat",
      textSelectionTheme: const TextSelectionThemeData(
        selectionColor: AppColor.darkBackground,
        cursorColor: AppColor.white,
        selectionHandleColor: AppColor.brightMagenta,
      ),
      textTheme: Typography.whiteCupertino,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
