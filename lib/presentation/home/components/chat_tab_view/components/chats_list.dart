import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/widgets/input_form_field.dart';

class ChatsList extends StatelessWidget {
  const ChatsList({super.key});

  static final cubit = getIt<ChatCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: cubit,
      builder: (context, state) {
        final chats = state.chatPagination.data;
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {},
              backgroundColor: AppColor.violet,
              child: const Icon(
                Icons.add,
                color: AppColor.white,
              ),
            ),
          ),
          body: SizedBox(
            height: 0.8.sh,
            child: Column(
              children: [
                Container(
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
                  child: InputFormField(
                    hintText: "Search ...",
                    onChanged: (val) {
                      cubit.searchInChatsList(val);
                    },
                    showBorder: false,
                  ),
                ),
                1.verticalSpace,
                Expanded(
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
                    child: ListView.builder(
                        itemCount: chats.length,
                        itemBuilder: (context, index) {
                          final chat = chats[index];
                          final message = chat.messages?.last;
                          final isSelected = chat.id == state.currentChat.id;
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: InkWell(
                              onTap: () {
                                cubit.updateCurrentChat(chat);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? context.colorScheme.secondary
                                      : context.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: ListTile(
                                  title: Text(
                                      chat.participants[1].user?.username ??
                                          ""),
                                  subtitle: Text(message?.text ?? ""),
                                  trailing: Text(formatDate(
                                      message?.timeStamp ?? DateTime.now())),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
