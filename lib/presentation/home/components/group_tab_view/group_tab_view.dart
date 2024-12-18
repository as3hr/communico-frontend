import 'dart:ui';

import 'package:communico_frontend/helpers/widgets/empty_chat.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/components/group_creation.dart/group_creation_cubit.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/components/group_creation.dart/group_creation.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/components/group_list.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/components/group_room_detail.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/widgets/animated_banner.dart';
import '../chat_rom/chat_room.dart';
import '../chat_rom/chat_room_query_params.dart';
import 'group_cubit.dart';

class GroupTabView extends StatelessWidget {
  const GroupTabView({super.key});

  static final cubit = getIt<GroupCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCubit, GroupState>(
        bloc: cubit,
        builder: (context, state) {
          final currentGroup = state.currentGroup;
          return state.groupPagination.data.isEmpty && !state.isSearching
              ? EmptyChat(
                  text: "Create your First Group",
                  onTap: () {
                    getIt<GroupCreationCubit>().fetchUsers();
                    showDialog(
                      context: context,
                      builder: (_) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: const AnimatedBanner(
                            content: GroupCreationForm(),
                          ),
                        );
                      },
                    );
                  },
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(flex: 2, child: GroupList()),
                    5.horizontalSpace,
                    Expanded(
                        flex: 5,
                        child: ChatRoom(
                          params: ChatRoomQueryParams(
                            onSendMessage: () {
                              cubit.sendMessage();
                            },
                            scrollController: state.currentGroup
                                .messagePagination.scrollController,
                            scrollAndCall: () {
                              cubit.scrollAndCallMessages(state.currentGroup);
                            },
                            textController: state.groupMessageController,
                            roomTitle: currentGroup.name,
                            messages: currentGroup.messagePagination.data,
                          ),
                        )),
                    5.horizontalSpace,
                    const Expanded(flex: 2, child: GroupRoomDetail()),
                  ],
                );
        });
  }
}
