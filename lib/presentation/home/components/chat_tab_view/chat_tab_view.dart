import 'dart:ui';

import 'package:communico_frontend/helpers/widgets/empty_chat.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/components/chat_creation_cubit.dart';
import 'package:communico_frontend/presentation/home/components/message/message_updation_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/utils.dart';
import '../../../../helpers/widgets/animated_banner.dart';
import '../chat_rom/chat_room.dart';
import '../message/message_actions_params.dart';
import 'components/chats_list.dart';

class ChatTabView extends StatelessWidget {
  const ChatTabView({super.key});

  static final cubit = getIt<ChatCubit>();
  static final replyTo = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
        bloc: cubit,
        builder: (context, state) {
          final currentChat = state.currentChat;
          final chatUser = currentChat.participants.isNotEmpty
              ? currentChat.participants
                  .firstWhere(
                      (participant) => participant.userId != cubit.user!.id)
                  .user
              : null;

          return state.chatPagination.data.isEmpty && !state.isSearching
              ? EmptyChat(
                  onTap: () {
                    final chatCubit = getIt<ChatCreationCubit>();
                    chatCubit.fetchUsers();
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: const AnimatedBanner(
                            content: ChatCreationForm(),
                          ),
                        );
                      },
                    );
                  },
                  text: "Start your First Chat!",
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 2, child: ChatsList()),
                    5.horizontalSpace,
                    Expanded(
                        flex: 5,
                        child: ChatRoom(
                          replyTo: replyTo,
                          onReply: (entity, show) {
                            cubit.triggerReplyTo(entity, show);
                          },
                          messageActionsParams: MessageActionsParams(
                            onDelete: (entity) async {
                              if (await showConfirmationDialog(
                                  "Are you sure you want to delete this message permanantly?")) {
                                cubit.deleteMessage(entity);
                              }
                            },
                            onUpdate: (entity) {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return BackdropFilter(
                                    filter:
                                        ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                    child: AnimatedBanner(
                                      content: MessageUpdationBanner(
                                        message: entity,
                                        onTap: (message) {
                                          cubit.updateMessage(entity, context);
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          params: ChatRoomQueryParams(
                            onSendMessage: () {
                              cubit.sendMessage();
                              replyTo.value = false;
                            },
                            scrollAndCall: () {
                              cubit.scrollAndCallMessages(state.currentChat);
                            },
                            textController: state.messageController,
                            roomTitle: chatUser?.username ?? "",
                            messages: currentChat.messagePagination.data,
                          ),
                        )),
                  ],
                );
        });
  }
}
