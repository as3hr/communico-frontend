import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/widgets/jumping_dots.dart';
import 'package:flutter/material.dart';

class LoadingMessage extends StatelessWidget {
  const LoadingMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff272334),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.zero,
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: JumpingDots(
                  color: AppColor.white,
                  numberOfDots: 3,
                )),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
