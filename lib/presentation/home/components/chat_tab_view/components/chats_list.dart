import 'package:communico_frontend/domain/entities/message_entity.dart';
import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_cubit.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../di/service_locator.dart';
import '../../../../../helpers/styles/app_colors.dart';
import '../../../../../helpers/styles/styles.dart';
import '../../../../../helpers/widgets/input_field.dart';
import 'chat_creation.dart';
import 'chat_creation_cubit.dart';

class ChatsList extends StatefulWidget {
  const ChatsList({super.key});

  @override
  State<ChatsList> createState() => _ChatsListState();
}

class _ChatsListState extends State<ChatsList> {
  final cubit = sl<ChatCubit>();

  @override
  void initState() {
    super.initState();
    final scrollController = cubit.state.chatPagination.scrollController;
    scrollController.addListener(() {
      if (scrollController.hasClients) {
        final threshold = scrollController.position.maxScrollExtent * 0.2;
        if (scrollController.position.pixels >= threshold) {
          cubit.scrollAndCallChat();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      bloc: cubit,
      builder: (context, state) {
        final chats = state.isSearching
            ? state.chatSearchList
            : state.chatPagination.data;

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: FloatingActionButton(
              shape: const CircleBorder(),
              onPressed: () {
                sl<ChatCreationCubit>().fetchUsers();
                showAppDialog(context, const ChatCreationForm());
              },
              backgroundColor: AppColor.styleColor,
              child: const Icon(
                Icons.add,
                color: AppColor.black,
              ),
            ),
          ),
          body: SizedBox(
            height: 0.9.sh,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InputField(
                    hintText: "Search ...",
                    onChanged: (val) {
                      cubit.searchInChatsList(val);
                    },
                    onSubmitted: (val) {},
                  ),
                ),
                3.verticalSpace,
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
                    child: chats.isEmpty
                        ? const Center(
                            child: Text("NO CHATS FOUND!"),
                          )
                        : ListView.separated(
                            controller: state.chatPagination.scrollController,
                            itemCount: chats.length,
                            separatorBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Divider(
                                  thickness: 0.5,
                                  color: context.colorScheme.onPrimary,
                                ),
                              );
                            },
                            itemBuilder: (context, index) {
                              final chat = chats[index];
                              List<MessageEntity> messages = state
                                  .chatPagination.data
                                  .firstWhere(
                                      (element) => element.id == chat.id)
                                  .messagePagination
                                  .data;
                              messages =
                                  messages.isEmpty ? chat.messages : messages;
                              final message =
                                  messages.isNotEmpty ? messages.first : null;
                              final participant = chat.participants.firstWhere(
                                  (participant) =>
                                      participant.userId != cubit.user!.id);
                              return IconButton(
                                style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                        const StadiumBorder())),
                                onPressed: () {
                                  cubit.updateCurrentChat(chat);
                                },
                                icon: Container(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            participant.user?.username ?? "",
                                            style: Styles.mediumStyle(
                                              fontSize: 15,
                                              color:
                                                  context.colorScheme.onPrimary,
                                              family: FontFamily.kanit,
                                            ),
                                          ),
                                          const Spacer(),
                                          2.horizontalSpace,
                                          Text(
                                            formatDate(message?.timeStamp ??
                                                DateTime.now().toLocal()),
                                            style: Styles.mediumStyle(
                                              fontSize: 13,
                                              color:
                                                  context.colorScheme.onPrimary,
                                              family: FontFamily.montserrat,
                                            ),
                                          ),
                                        ],
                                      ),
                                      1.verticalSpace,
                                      Text(
                                        message?.text ?? "",
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          color: context.colorScheme.onPrimary,
                                          fontFamily: "Montserrat",
                                        ),
                                      ),
                                    ],
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
