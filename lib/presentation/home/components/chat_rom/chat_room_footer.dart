import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/widgets/input_form_field.dart';

class ChatRoomFooter extends StatelessWidget {
  const ChatRoomFooter(
      {super.key, required this.onSendMessage, required this.textController});
  final TextEditingController textController;
  final void Function() onSendMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.05.sh,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: InputFormField(
                textEditingController: textController,
                hintText: "Write a message ...",
                onChanged: (val) {},
                onSubmit: (val) {
                  onSendMessage.call();
                },
                showBorder: false,
              ),
            ),
          ),
          1.horizontalSpace,
          InkWell(
            onTap: () {
              onSendMessage.call();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: AppColor.violet,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      color: AppColor.white,
                      Icons.send,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
