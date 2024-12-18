import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

extension Responsive on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get keyBoardVisible => MediaQuery.of(this).viewInsets.bottom >= 0;
  bool get isDark => AdaptiveTheme.of(this).mode.isDark;
  bool get isLight => AdaptiveTheme.of(this).mode.isLight;
  bool get isWeb => screenWidth > 1024;
  bool get isTablet => screenWidth > 600 && screenWidth <= 1024;
  bool get isMobile => screenWidth <= 600;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}

extension StringConvert on String {
  int get toInt => int.parse(this);
  double get toDouble => double.parse(this);
  String capitalized() {
    return replaceAllMapped(
            RegExp(r'([a-z])([A-Z])'), (Match m) => '${m[1]} ${m[2]}')
        .split(' ')
        .map((word) =>
            word.substring(0, 1).toUpperCase() +
            word.substring(1).toLowerCase())
        .join(' ');
  }
}
