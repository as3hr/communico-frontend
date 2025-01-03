import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/widgets/app_button.dart';
import '../../../../helpers/widgets/input_field.dart';

class MessageUpdationBanner extends StatefulWidget {
  const MessageUpdationBanner({
    super.key,
    required this.message,
    required this.onTap,
  });
  final MessageEntity message;
  final void Function(MessageEntity message) onTap;

  @override
  State<MessageUpdationBanner> createState() => _MessageUpdationBannerState();
}

class _MessageUpdationBannerState extends State<MessageUpdationBanner> {
  String currentText = "";
  final condition = ValueNotifier<bool>(false);

  void onTap() {
    widget.message.text = currentText;
    widget.onTap(widget.message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.colorScheme.primary,
              context.colorScheme.secondary
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        width: 0.2.sw,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
          child: ValueListenableBuilder<bool>(
              valueListenable: condition,
              builder: (context, value, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    2.verticalSpace,
                    InputField(
                      prefilledValue: widget.message.text,
                      hintText: "write a message",
                      onChanged: (val) {
                        currentText = val;
                        final isValid = currentText != widget.message.text &&
                            currentText.isNotEmpty;

                        condition.value = isValid;
                      },
                      onSubmitted: (val) {
                        if (value) {
                          onTap();
                        }
                      },
                      prefixIcon: Icons.edit,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      backgroundColor:
                          (value) ? AppColor.styleColor : AppColor.black3,
                      title: "Update Message",
                      onTap: (value)
                          ? () {
                              onTap();
                            }
                          : null,
                    ),
                  ],
                );
              }),
        ));
  }
}
