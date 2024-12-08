import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../di/service_locator.dart';
import '../../home_state.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        final chats = state.chatPagination.data;
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          height: 0.8.sh,
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final message = chat.messages?.last;
                return InkWell(
                  onTap: () {
                    cubit.updateCurrentChat(chat);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: ListTile(
                      title: Text(chat.participants[1].user?.username ?? ""),
                      subtitle: Text(message?.text ?? ""),
                      trailing: Text(
                          formatDate(message?.timeStamp ?? DateTime.now())),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
