import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/utils.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({super.key, required this.message});
  final MessageEntity message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                constraints: BoxConstraints(
                  maxWidth: 0.55.sw,
                ),
                decoration: BoxDecoration(
                    color: AppColor.violet,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.zero,
                    )),
                child: Text(
                  message.text,
                ),
              ),
              1.verticalSpace,
              Text(
                formatDate(message.timeStamp),
                style: Styles.lightStyle(
                  fontSize: 12,
                  color: context.colorScheme.onSurface,
                  family: FontFamily.bangers,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
