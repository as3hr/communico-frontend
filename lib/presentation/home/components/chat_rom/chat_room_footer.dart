import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/app_colors.dart';
import '../../../../helpers/widgets/input_form_field.dart';

class ChatRoomFooter extends StatefulWidget {
  const ChatRoomFooter({
    super.key,
    required this.onSendMessage,
    required this.textController,
    this.onChanged,
  });
  final TextEditingController textController;
  final void Function() onSendMessage;
  final void Function(String text)? onChanged;

  @override
  State<ChatRoomFooter> createState() => _ChatRoomFooterState();
}

class _ChatRoomFooterState extends State<ChatRoomFooter> {
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    focusNode = getFieldFocusNode(widget.onSendMessage);
  }

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
                textEditingController: widget.textController,
                hintText: "Write a message ...",
                onChanged: (val) {
                  widget.onChanged?.call(val);
                },
                focusNode: focusNode,
                showBorder: false,
              ),
            ),
          ),
          1.horizontalSpace,
          InkWell(
            onTap: () {
              widget.onSendMessage.call();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: AppColor.styleColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                    child: Icon(
                      color: AppColor.black,
                      Icons.send,
                      size: 20,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
