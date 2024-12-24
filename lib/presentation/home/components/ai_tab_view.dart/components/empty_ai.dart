import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../helpers/styles/styles.dart';

class EmptyAi extends StatelessWidget {
  const EmptyAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        5.verticalSpace,
        Text(
          "Note: This conversation is temporary and will not be saved. All messages will be cleared upon closing the site.",
          textAlign: TextAlign.center,
          style: Styles.boldStyle(
            fontSize: 15,
            color: AppColor.white,
            family: FontFamily.montserrat,
          ),
        ),
        const Spacer(),
        Center(
          child: Text(
            "Welcome to Your AI Buddy!",
            textAlign: TextAlign.center,
            style: Styles.boldStyle(
              fontSize: 25,
              color: AppColor.white,
              family: FontFamily.kanit,
            ),
          ),
        ),
        5.verticalSpace,
        Text(
          "Tip: Feel free to ask anything or explore ideas!",
          textAlign: TextAlign.center,
          style: Styles.mediumStyle(
            fontSize: 15,
            color: AppColor.white,
            family: FontFamily.kanit,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
