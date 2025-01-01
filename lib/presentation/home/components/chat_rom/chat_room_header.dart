import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/styles/styles.dart';

class ChatRoomHeader extends StatelessWidget {
  const ChatRoomHeader({super.key, required this.params});
  final ChatRoomQueryParams params;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.05.sh,
      decoration: BoxDecoration(
        color: context.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          2.horizontalSpace,
          Text(
            params.roomTitle,
            style: Styles.mediumStyle(
              fontSize: 20,
              color: context.colorScheme.onPrimary,
              family: FontFamily.kanit,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              params.onShareChat?.call();
            },
            icon: const Icon(
              Icons.share,
            ),
            tooltip: "Share Conversation",
          ),
          2.horizontalSpace,
          if (params.isGroup) ...[
            IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(
                Icons.menu,
              ),
            ),
          ],
          2.horizontalSpace,
        ],
      ),
    );
  }
}
