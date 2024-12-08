import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_room.dart';
import 'chat_room_detail.dart';
import 'chats_list.dart';

class ChatTabView extends StatelessWidget {
  const ChatTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(flex: 2, child: ChatsList()),
        5.horizontalSpace,
        const Expanded(flex: 5, child: ChatRoom()),
        5.horizontalSpace,
        const Expanded(flex: 2, child: ChatRoomDetail()),
      ],
    );
  }
}
