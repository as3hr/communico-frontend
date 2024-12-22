import 'package:flutter/material.dart';
import 'components/ai_chat_room.dart';

class AiTabView extends StatelessWidget {
  const AiTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(children: [
      Expanded(child: AiChatRoom()),
    ]);
  }
}
