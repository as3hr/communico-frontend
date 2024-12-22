import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../styles/styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.content,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor = AppColor.violet,
  });
  final String title;
  final void Function()? onTap;
  final Widget? content;
  final Color backgroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: width ?? double.infinity,
        height: height,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              backgroundColor,
              backgroundColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: content ??
            Center(
              child: Text(
                title,
                style: Styles.boldStyle(
                  fontSize: 20,
                  color: AppColor.white,
                  family: FontFamily.kanit,
                ),
              ),
            ),
      ),
    );
  }
}
