import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:flutter/material.dart';

class ReplyToBox extends StatelessWidget {
  const ReplyToBox({
    super.key,
    required this.message,
    required this.onTap,
    required this.color,
  });
  final MessageEntity message;
  final void Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.3),
          border: Border(
            left: BorderSide(
              color: AppColor.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Replying to...',
                style: Styles.boldStyle(
                  fontSize: 10,
                  color: AppColor.white,
                  family: FontFamily.montserrat,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                message.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Styles.boldStyle(
                  fontSize: 12,
                  color: AppColor.white,
                  family: FontFamily.montserrat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
