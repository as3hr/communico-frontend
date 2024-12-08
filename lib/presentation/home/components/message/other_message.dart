import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
              maxWidth: 0.65.sw,
            ),
            decoration: BoxDecoration(
                color: context.colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
            child: Text(
              message.text,
            ),
          ),
          5.verticalSpace,
          Text(formatDate(message.timeStamp)),
        ],
      ),
    );
  }
}
