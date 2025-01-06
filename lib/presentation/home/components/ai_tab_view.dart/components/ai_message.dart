import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            child: Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 0.55.sw,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColor.purple,
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
                      family: FontFamily.kanit,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: InkWell(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: message.text),
                      );
                      message.isCopiedNotifier.value = true;
                      Future.delayed(const Duration(seconds: 2), () {
                        message.isCopiedNotifier.value = false;
                      });
                    },
                    child: ValueListenableBuilder<bool>(
                      valueListenable: message.isCopiedNotifier,
                      builder: (context, isCopied, child) {
                        return Icon(
                          isCopied ? Icons.check : Icons.copy,
                          color: isCopied
                              ? Colors.blue
                              : AppColor.white.withOpacity(0.7),
                          size: 18,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
