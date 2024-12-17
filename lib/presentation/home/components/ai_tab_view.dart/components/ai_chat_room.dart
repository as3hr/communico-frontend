import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/ai_streaming_message.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/empty_ai.dart';
import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/components/ai_message.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_footer.dart';
import 'package:communico_frontend/presentation/home/components/loading_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../message/my_message.dart';

class AiChatRoom extends StatelessWidget {
  const AiChatRoom({
    super.key,
    required this.messages,
    required this.onSendMessage,
    required this.roomTitle,
    required this.textController,
    required this.isLoading,
    required this.response,
  });
  final String roomTitle;
  final List<MessageEntity> messages;
  final void Function() onSendMessage;
  final TextEditingController textController;
  final bool isLoading;
  final String response;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              child: messages.isEmpty
                  ? const EmptyAi()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return message.isAi
                                  ? AiMessage(
                                      message: message,
                                      key: ValueKey(index.toString()))
                                  : MyMessage(
                                      message: message,
                                      key: ValueKey(index.toString()));
                            },
                          ),
                        ),
                        if (isLoading) const LoadingMessage(),
                        if (response.isNotEmpty)
                          AiStreamingMessage(
                            text: response,
                          ),
                      ],
                    ),
            ),
          ),
          2.verticalSpace,
          ChatRoomFooter(
            onSendMessage: onSendMessage,
            textController: textController,
          ),
        ],
      ),
    );
  }
}
