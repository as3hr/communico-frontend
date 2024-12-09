import 'package:communico_frontend/presentation/home/components/group_tab_view/group_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import '../chat_tab_view/chat_room.dart';
import '../chat_tab_view/chat_room_detail.dart';

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
            children: [
              const Expanded(flex: 2, child: GroupList()),
              5.horizontalSpace,
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
              const Expanded(flex: 2, child: ChatRoomDetail()),
            ],
          );
        });
  }
}
