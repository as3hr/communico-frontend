import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/widgets/jumping_dots.dart';

class LoadingHome extends StatelessWidget {
  const LoadingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Row(
          children: [
            const Spacer(),
            JumpingDots(
              color: AppColor.white,
              numberOfDots: 3,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
