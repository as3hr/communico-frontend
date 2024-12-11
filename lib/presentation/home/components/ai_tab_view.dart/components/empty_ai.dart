import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../helpers/styles/app_images.dart';

class EmptyAi extends StatelessWidget {
  const EmptyAi({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        Center(
          child: Text(
            "Welcome to Your AI Buddy!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          "Note:",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColor.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 5),
        Text(
          "This conversation is temporary and will not be saved. All messages will be cleared upon closing the site.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.white,
              ),
        ),
        const SizedBox(height: 20),
        Text(
          "Tip: Feel free to ask anything or explore ideas!",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColor.white,
                fontStyle: FontStyle.italic,
              ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ClipOval(
            child: Image.asset(
              AppImages.aiGif,
              height: 50,
              width: 50,
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
