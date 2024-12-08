import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const lightColortheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.lightPrimary,
    onPrimary: AppColor.white,
    secondary: AppColor.lightSecondary,
    onSecondary: AppColor.lightGrey,
    error: AppColor.red,
    onError: AppColor.white,
    surface: AppColor.lightBackground,
    onSurface: AppColor.darkGrey,
  );

  static const darkColortheme = ColorScheme(
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

  static ThemeData theme({bool dark = false}) {
    return ThemeData(
      scaffoldBackgroundColor:
          dark ? AppColor.darkBackground : AppColor.lightBackground,
      useMaterial3: true,
      colorScheme: dark ? darkColortheme : lightColortheme,
      fontFamily: "Varela",
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: dark ? AppColor.darkSecondary : AppColor.lightGrey,
        cursorColor: dark ? AppColor.white : AppColor.darkPrimary,
        selectionHandleColor: dark ? AppColor.white : AppColor.lightPrimary,
      ),
      textTheme: dark ? Typography.whiteCupertino : Typography.blackCupertino,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
