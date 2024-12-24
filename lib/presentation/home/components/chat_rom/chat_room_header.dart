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
        color: context.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (context.isMobile || context.isTablet) ...[
            2.horizontalSpace,
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
              ),
            ),
          ],
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
