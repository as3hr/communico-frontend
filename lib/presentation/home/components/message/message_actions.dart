import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/presentation/home/components/message/message_actions_params.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/app_colors.dart';

class MessageActions extends StatelessWidget {
  const MessageActions({
    super.key,
    required this.params,
    required this.message,
    required this.onReplyTap,
    this.isOtherMessage = false,
  });
  final MessageActionsParams params;
  final MessageEntity message;
  final bool isOtherMessage;
  final void Function()? onReplyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isOtherMessage) ...[
          2.horizontalSpace,
          IconButton(
            onPressed: () {
              params.onDelete?.call(message);
            },
            icon: const Icon(Icons.delete),
            color: AppColor.red,
            iconSize: 15,
          ),
          2.horizontalSpace,
          IconButton(
            onPressed: () {
              params.onUpdate?.call(message);
            },
            icon: const Icon(CupertinoIcons.pencil),
            color: AppColor.grey,
            iconSize: 15,
          ),
        ],
        2.horizontalSpace,
        IconButton(
          onPressed: () {
            onReplyTap?.call();
          },
          icon: const Icon(Icons.reply),
          color: AppColor.grey,
          iconSize: 15,
        ),
      ],
    );
  }
}
