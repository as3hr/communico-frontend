import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_footer.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_header.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';
import 'package:communico_frontend/presentation/home/components/message/message_actions_params.dart';
import 'package:communico_frontend/presentation/home/components/message/my_message.dart';
import 'package:communico_frontend/presentation/home/components/message/other_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import '../group_tab_view/components/group_room_detail.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.params,
    required this.messageActionsParams,
  });
  final ChatRoomQueryParams params;
  final MessageActionsParams messageActionsParams;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final cubit = getIt<HomeCubit>();
  @override
  void initState() {
    super.initState();
    widget.params.scrollController.addListener(() {
      if (widget.params.scrollController.hasClients) {
        final threshold =
            widget.params.scrollController.position.maxScrollExtent * 0.2;
        if (widget.params.scrollController.position.pixels >= threshold) {
          widget.params.scrollAndCall();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: widget.params.isGroup ? const GroupRoomDetail() : null,
      drawerScrimColor: Colors.transparent,
      onEndDrawerChanged: (isOpened) {
        widget.params.onEndDrawerChanged?.call();
      },
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: cubit,
          builder: (context, state) {
            return Material(
              child: SizedBox(
                height: 0.9.sh,
                child: Column(
                  children: [
                    Expanded(
                      flex: 7,
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
                        constraints: BoxConstraints(
                          maxHeight: 0.6.sh,
                        ),
                        child: Stack(
                          children: [
                            if (state.currentBackground?.image.isNotEmpty ??
                                false)
                              Positioned.fill(
                                child: Image.asset(
                                  state.currentBackground!.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ChatRoomHeader(params: widget.params),
                                Expanded(
                                  child: ListView.builder(
                                    reverse: true,
                                    controller: widget.params.scrollController,
                                    itemCount: widget.params.messages.length,
                                    itemBuilder: (context, index) {
                                      final message =
                                          widget.params.messages[index];
                                      final isMyMessage =
                                          cubit.isMyMessage(message);
                                      return isMyMessage
                                          ? MyMessage(
                                              messageActionsParams:
                                                  widget.messageActionsParams,
                                              message: message,
                                              key: ValueKey(index.toString()))
                                          : OtherMessage(
                                              messageActionsParams:
                                                  widget.messageActionsParams,
                                              message: message,
                                              key: ValueKey(index.toString()));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    2.verticalSpace,
                    ChatRoomFooter(
                      textController: widget.params.textController,
                      onSendMessage: widget.params.onSendMessage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
