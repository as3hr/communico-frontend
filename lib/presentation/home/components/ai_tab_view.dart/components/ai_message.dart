import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/styles/styles.dart';

class AiMessage extends StatelessWidget {
  const AiMessage({
    super.key,
    required this.message,
  });
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
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
                child: Text(
                  message.text,
                  style: Styles.mediumStyle(
                    fontSize: 14,
                    color: AppColor.white,
                    family: FontFamily.montserrat,
                  ),
                )),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
