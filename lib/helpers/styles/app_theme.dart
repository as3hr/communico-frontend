import 'app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const lightColortheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColor.white,
    onPrimary: AppColor.darkBlue,
    secondary: AppColor.lightGrey,
    onSecondary: AppColor.lightWhite,
    error: AppColor.red,
    onError: AppColor.white,
    surface: AppColor.white,
    onSurface: AppColor.darkBlue,
  );

  static const darkColortheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColor.darkBlue,
    onPrimary: AppColor.white,
    secondary: AppColor.lightGrey,
    onSecondary: AppColor.black3,
    error: AppColor.red,
    onError: AppColor.white,
    surface: AppColor.darkBlue,
    onSurface: AppColor.lightGrey,
  );

  static ThemeData theme({bool dark = false}) {
    return ThemeData(
      scaffoldBackgroundColor: dark ? AppColor.darkBlue : AppColor.white,
      useMaterial3: true,
      colorScheme: dark ? darkColortheme : lightColortheme,
      fontFamily: "Varela",
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: AppColor.lightGrey,
        cursorColor: dark ? AppColor.white : AppColor.darkBlue,
        selectionHandleColor: dark ? AppColor.white : AppColor.darkBlue,
      ),
      textTheme: dark ? Typography.whiteCupertino : Typography.blackCupertino,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
