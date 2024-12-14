import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_footer.dart';
import 'package:communico_frontend/presentation/home/components/message/my_message.dart';
import 'package:communico_frontend/presentation/home/components/message/other_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({
    super.key,
    required this.messages,
    required this.onSendMessage,
    required this.roomTitle,
    required this.textController,
    required this.scrollAndCall,
    required this.scrollController,
  });
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function() onSendMessage;
  final void Function() scrollAndCall;
  final TextEditingController textController;
  final ScrollController scrollController;

  static final cubit = getIt<HomeCubit>();

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.hasClients) {
        final threshold =
            widget.scrollController.position.maxScrollExtent * 0.2;
        if (widget.scrollController.position.pixels >= threshold) {
          widget.scrollAndCall();
        }
      }
    });
  }

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 0.05.sh,
                    color: context.colorScheme.secondary,
                    child: Row(
                      children: [
                        10.horizontalSpace,
                        Text(widget.roomTitle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      controller: widget.scrollController,
                      itemCount: widget.messages.length,
                      itemBuilder: (context, index) {
                        final message = widget.messages[index];
                        final isMyMessage = ChatRoom.cubit.isMyMessage(message);
                        return isMyMessage
                            ? MyMessage(
                                message: message,
                                key: ValueKey(index.toString()))
                            : OtherMessage(
                                message: message,
                                key: ValueKey(index.toString()));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          2.verticalSpace,
          ChatRoomFooter(
            textController: widget.textController,
            onSendMessage: widget.onSendMessage,
          ),
        ],
      ),
    );
  }
}
