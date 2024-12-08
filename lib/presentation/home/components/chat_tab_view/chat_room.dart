import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/input_field.dart';
import 'package:communico_frontend/presentation/home/components/message/my_message.dart';
import 'package:communico_frontend/presentation/home/components/message/other_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        final currentChat = state.currentChat;
        final chatUser = currentChat.participants.isNotEmpty
            ? currentChat.participants[1].user
            : null;
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
                            Text(chatUser?.username ?? "CHAT ROOM TITLE"),
                            const Spacer(),
                            const Text("CLEAR ALL"),
                            10.horizontalSpace,
                          ],
                        ),
                      ),
                      if (currentChat.messages?.isNotEmpty ?? false)
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: currentChat.messages!.length,
                            itemBuilder: (context, index) {
                              final message = currentChat.messages![index];
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
                          hintText: "Write a message ...",
                          onChanged: (val) {},
                          showBorder: false,
                        ),
                      ),
                    ),
                    2.horizontalSpace,
                    InkWell(
                      onTap: () {},
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
      },
    );
  }
}
