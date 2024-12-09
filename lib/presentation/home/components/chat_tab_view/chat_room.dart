import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/input_field.dart';
import 'package:communico_frontend/presentation/home/components/message/my_message.dart';
import 'package:communico_frontend/presentation/home/components/message/other_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../home_cubit.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({
    super.key,
    required this.messages,
    required this.onSendMessage,
    required this.roomTitle,
    required this.textController,
  });
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function() onSendMessage;
  final TextEditingController textController;

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.8.sh,
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.black1,
                ),
              ),
              constraints: BoxConstraints(
                maxHeight: 0.6.sh,
              ),
              child: Column(
                children: [
                  Container(
                    height: 0.05.sh,
                    color: context.colorScheme.secondary,
                    child: Row(
                      children: [
                        10.horizontalSpace,
                        Text(roomTitle),
                        const Spacer(),
                        const Text("CLEAR ALL"),
                        10.horizontalSpace,
                      ],
                    ),
                  ),
                  if (messages.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMyMessage = cubit.isMyMessage(message);
                          return isMyMessage
                              ? MyMessage(message: message)
                              : OtherMessage(message: message);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          2.verticalSpace,
          Container(
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
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.black1,
                      ),
                    ),
                    child: InputField(
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
          ),
        ],
      ),
    );
  }
}
