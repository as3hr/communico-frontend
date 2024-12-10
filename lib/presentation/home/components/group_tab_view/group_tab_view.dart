import 'package:communico_frontend/helpers/widgets/empty_chat.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_list.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_room_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import '../chat_tab_view/chat_room.dart';

class GroupTabView extends StatelessWidget {
  const GroupTabView({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          final currentGroup = state.currentGroup;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 2, child: GroupList()),
              5.horizontalSpace,
              if (state.groupPagination.data.isEmpty)
                Expanded(
                    flex: 5,
                    child: EmptyChat(
                      text: "Create your First Group",
                      onTap: () {},
                    )),
              if (state.groupPagination.data.isNotEmpty) ...[
                Expanded(
                    flex: 5,
                    child: ChatRoom(
                      onSendMessage: () {
                        final index = DefaultTabController.of(context).index;
                        cubit.sendMessage(index);
                      },
                      textController: state.currentGroupMessageController,
                      roomTitle: currentGroup.name,
                      messages: currentGroup.messages,
                    )),
                5.horizontalSpace,
                const Expanded(flex: 2, child: GroupRoomDetail()),
              ]
            ],
          );
        });
  }
}
