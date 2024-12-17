import 'package:flutter/material.dart';

import 'app_colors.dart';

enum FontFamily { patrickHand, bangers }

class Styles {
  static InputDecoration inputFieldDecoration(
    String hintText,
    BuildContext context, {
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      fillColor: AppColor.lightGrey,
      errorStyle: boldStyle(
        fontSize: 12, color: AppColor.red,
        family: FontFamily.bangers,
        // family: FontFamily.varela
      ),
      errorBorder: InputBorder.none,
      errorMaxLines: 1,
      contentPadding: const EdgeInsets.all(8),
      focusedErrorBorder: InputBorder.none,
      hintStyle: mediumStyle(
          fontSize: 15, color: AppColor.grey, family: FontFamily.patrickHand),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColor.darkBackground,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColor.darkBackground,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  static TextStyle boldStyle({
    required double fontSize,
    required Color color,
    required FontFamily family,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: fontSize,
      color: color,
      fontFamily: family == FontFamily.bangers ? "Bangers" : "PatrickHand",
    );
  }

  static TextStyle semiBoldStyle({
    required double fontSize,
    required Color color,
    required FontFamily family,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: fontSize,
      color: color,
      fontFamily: family == FontFamily.bangers ? "Bangers" : "PatrickHand",
    );
  }

  static TextStyle mediumStyle({
    required double fontSize,
    required Color color,
    required FontFamily family,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: fontSize,
      color: color,
      fontFamily: family == FontFamily.bangers ? "Bangers" : "PatrickHand",
    );
  }

  static TextStyle semiMediumStyle({
    required double fontSize,
    required Color color,
    required FontFamily family,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: color,
      fontFamily: family == FontFamily.bangers ? "Bangers" : "PatrickHand",
    );
  }

  static TextStyle lightStyle({
    required double fontSize,
    required Color color,
    required FontFamily family,
  }) {
    return TextStyle(
      fontWeight: FontWeight.w300,
      fontSize: fontSize,
      color: color,
      fontFamily: family == FontFamily.bangers ? "Bangers" : "PatrickHand",
    );
  }

  static ColorScheme scheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}
