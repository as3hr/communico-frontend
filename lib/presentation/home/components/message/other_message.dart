import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/styles.dart';
import '../../../../helpers/utils.dart';

class OtherMessage extends StatelessWidget {
  const OtherMessage({super.key, required this.message});
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: 0.55.sw,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colorScheme.secondary,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.sender?.username ?? "",
                  style: Styles.mediumStyle(
                    fontSize: 15,
                    color: context.colorScheme.onPrimary,
                    family: FontFamily.kanit,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.text,
                  style: Styles.mediumStyle(
                    fontSize: 14,
                    color: AppColor.white,
                    family: FontFamily.montserrat,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              formatDate(message.timeStamp),
              style: Styles.lightStyle(
                fontSize: 12,
                color: AppColor.white,
                family: FontFamily.montserrat,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
