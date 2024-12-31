import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_footer.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_header.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';
import 'package:communico_frontend/presentation/home/components/message/message_actions_params.dart';
import 'package:communico_frontend/presentation/home/components/message/my_message.dart';
import 'package:communico_frontend/presentation/home/components/message/other_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import '../group_tab_view/components/group_room_detail.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.params,
    required this.messageActionsParams,
    required this.onReply,
    required this.replyTo,
  });
  final ChatRoomQueryParams params;
  final MessageActionsParams messageActionsParams;
  final void Function(MessageEntity? message, bool show) onReply;
  final ValueNotifier<bool> replyTo;

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  MessageEntity currentReplyToMessage = MessageEntity.empty();
  final cubit = sl<HomeCubit>();
  final Map<int, int> indexIdMap = {};
  final itemScrollController = ItemScrollController();
  final scrollOffsetListener = ScrollOffsetListener.create();

  @override
  void initState() {
    super.initState();
    scrollOffsetListener.changes.asBroadcastStream().listen((offset) {
      if (offset >= 0.8) {
        widget.params.scrollAndCall();
      }
    });
  }

  void animateToTargetMessage(int id) {
    final index = indexIdMap[id];
    if (index != null) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  void dispose() {
    widget.replyTo.value = false;
    super.dispose();
  }

  jumpToBottom() {
    final messages = widget.params.messages;
    if (messages.length > 1) {
      final index = messages.indexOf(messages.first);
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: widget.params.isGroup ? const GroupRoomDetail() : null,
      drawerScrimColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      onEndDrawerChanged: (isOpened) {
        widget.params.onEndDrawerChanged?.call();
      },
      body: SafeArea(
        child: BlocBuilder<HomeCubit, HomeState>(
          bloc: cubit,
          builder: (context, state) {
            return Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  widget.replyTo.value = false;
                  widget.onReply(null, false);
                },
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
                                    child: ScrollablePositionedList.builder(
                                      reverse: true,
                                      itemScrollController:
                                          itemScrollController,
                                      scrollOffsetListener:
                                          scrollOffsetListener,
                                      itemCount: widget.params.messages.length,
                                      itemBuilder: (context, index) {
                                        final message =
                                            widget.params.messages[index];
                                        final isMyMessage =
                                            cubit.isMyMessage(message);
                                        indexIdMap.putIfAbsent(
                                            message.id, () => index);
                                        return isMyMessage
                                            ? MyMessage(
                                                messageActionsParams:
                                                    widget.messageActionsParams,
                                                message: message,
                                                onReplySelection: () {
                                                  widget.replyTo.value = true;
                                                  currentReplyToMessage =
                                                      message;
                                                  widget.onReply(message, true);
                                                },
                                                onReplyTap: () {
                                                  animateToTargetMessage(
                                                      message.replyTo!.id);
                                                },
                                              )
                                            : OtherMessage(
                                                messageActionsParams:
                                                    widget.messageActionsParams,
                                                onReplySelection: () {
                                                  widget.replyTo.value = true;
                                                  currentReplyToMessage =
                                                      message;
                                                  widget.onReply(message, true);
                                                },
                                                message: message,
                                                onReplyTap: () {
                                                  animateToTargetMessage(
                                                    message.replyTo!.id,
                                                  );
                                                },
                                              );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              ValueListenableBuilder(
                                valueListenable: widget.replyTo,
                                builder: (context, value, _) {
                                  final replyToMessage =
                                      currentReplyToMessage.text.isEmpty
                                          ? null
                                          : currentReplyToMessage;
                                  return Positioned(
                                    bottom: 0,
                                    child: AnimatedSlide(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      offset: value
                                          ? Offset.zero
                                          : const Offset(0, 1),
                                      child: value
                                          ? Container(
                                              width: 0.5.sw,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                              decoration: BoxDecoration(
                                                color:
                                                    context.colorScheme.primary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, -2),
                                                  ),
                                                ],
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                  top: Radius.circular(16),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Replying to ${replyToMessage?.sender?.username}',
                                                        style: Styles.boldStyle(
                                                            fontSize: 12,
                                                            color:
                                                                AppColor.white,
                                                            family: FontFamily
                                                                .montserrat),
                                                      ),
                                                      const Spacer(),
                                                      IconButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        constraints:
                                                            const BoxConstraints(),
                                                        icon: const Icon(
                                                          Icons.close,
                                                          size: 20,
                                                          color: Colors.grey,
                                                        ),
                                                        onPressed: () {
                                                          widget.replyTo.value =
                                                              false;
                                                          widget.onReply(
                                                              null, false);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: BoxDecoration(
                                                      color: context.colorScheme
                                                          .secondary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            replyToMessage
                                                                    ?.text ??
                                                                "",
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Styles.mediumStyle(
                                                                fontSize: 12,
                                                                color: AppColor
                                                                    .white,
                                                                family: FontFamily
                                                                    .montserrat),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (widget.params.textController != null) ...[
                        2.verticalSpace,
                        ChatRoomFooter(
                          textController: widget.params.textController!,
                          onSendMessage: () {
                            widget.params.onSendMessage?.call();
                            jumpToBottom();
                          },
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
