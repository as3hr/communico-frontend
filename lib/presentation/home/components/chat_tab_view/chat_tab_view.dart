import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import 'chat_room.dart';
import 'chats_list.dart';

class ChatTabView extends StatelessWidget {
  const ChatTabView({super.key});

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
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: ChatsList()),
              5.horizontalSpace,
              Expanded(
                  flex: 5,
                  child: ChatRoom(
                    onSendMessage: () {
                      final index = DefaultTabController.of(context).index;
                      cubit.sendMessage(index);
                    },
                    textController: state.currentMessageController,
                    roomTitle: chatUser?.username ?? "",
                    messages: currentChat.messages ?? [],
                  )),
            ],
          );
        });
  }
}
