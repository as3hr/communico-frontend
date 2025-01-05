import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatelessWidget {
  final double width;
  final double height;

  const ShimmerEffect({
    super.key,
    this.width = double.infinity,
    this.height = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1200),
      baseColor: AppColor.primaryColor.withOpacity(0.6),
      highlightColor: AppColor.white.withOpacity(0.2),
      direction: ShimmerDirection.ltr,
      child: Container(
        width: 200,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
