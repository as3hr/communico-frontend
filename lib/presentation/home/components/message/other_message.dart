import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/presentation/home/components/message/message_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/styles.dart';
import '../../../../helpers/utils.dart';
import 'message_actions_params.dart';
import 'reply_to_box.dart';

class OtherMessage extends StatelessWidget {
  const OtherMessage({
    super.key,
    required this.message,
    this.messageActionsParams,
    required this.onReplyTap,
    this.onReplySelection,
  });
  final MessageEntity message;
  final MessageActionsParams? messageActionsParams;
  final void Function() onReplyTap;
  final void Function()? onReplySelection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            onEnter: (_) {
              message.isHovered.value = true;
            },
            onExit: (_) {
              message.isHovered.value = false;
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                      if (message.replyToText != null)
                        ReplyToBox(
                          message: message,
                          onTap: () {
                            onReplyTap.call();
                          },
                          color: context.colorScheme.secondary,
                        ),
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
                          family: FontFamily.kanit,
                        ),
                      ),
                    ],
                  ),
                ),
                if (messageActionsParams != null)
                  ValueListenableBuilder(
                      valueListenable: message.isHovered,
                      builder: (context, value, _) {
                        if (value) {
                          return MessageActions(
                            params: messageActionsParams!,
                            message: message,
                            onReplyTap: () {
                              onReplySelection?.call();
                            },
                            isOtherMessage: true,
                          );
                        }
                        return const SizedBox();
                      }),
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
