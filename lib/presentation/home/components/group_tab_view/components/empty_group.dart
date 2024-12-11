import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../helpers/styles/app_colors.dart';

class EmptyGroup extends StatelessWidget {
  const EmptyGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        border: Border.all(
          color: AppColor.black1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Create Your First Group!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
          5.verticalSpace,
          Center(
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {},
              backgroundColor: AppColor.violet,
              child: const Icon(
                Icons.add,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
