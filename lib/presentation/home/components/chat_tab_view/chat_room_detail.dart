import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../../../helpers/styles/app_colors.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';

class ChatRoomDetail extends StatelessWidget {
  const ChatRoomDetail({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        final currentChat = state.currentChat;
        final chatUser = currentChat.participants.isNotEmpty
            ? currentChat.participants[1].user
            : null;
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            border: Border.all(
              color: AppColor.black1,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 0.8.sh,
          child: Column(
            children: [
              10.verticalSpace,
              Text(chatUser?.username ?? ""),
            ],
          ),
        );
      },
    );
  }
}
