import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
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
        return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 0.8.sh,
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
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
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: currentChat.messages?.length,
                          itemBuilder: (context, index) {
                            final message = currentChat.messages?[index];
                            return Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(message?.text ?? ""),
                            );
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
                      child: InputField(
                        hintText: "Write a message ...",
                        onChanged: (val) {},
                      ),
                    ),
                    2.horizontalSpace,
                    InkWell(
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                            color: context.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.send,
                                color: context.colorScheme.secondary,
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
