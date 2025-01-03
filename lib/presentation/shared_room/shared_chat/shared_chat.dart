import 'dart:developer';

import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:communico_frontend/presentation/shared_room/shared_chat/shared_chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../di/service_locator.dart';
import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/widgets/app_button.dart';
import '../../home/components/message/other_message.dart';
import 'shared_chat_state.dart';

class SharedChat extends StatefulWidget {
  const SharedChat({super.key, required this.encryptedId});
  final String encryptedId;

  @override
  State<SharedChat> createState() => _SharedChatState();
}

class _SharedChatState extends State<SharedChat> {
  final cubit = sl<SharedChatCubit>();
  final Map<int, int> indexIdMap = {};
  final itemScrollController = ItemScrollController();
  final scrollOffsetListener = ScrollOffsetListener.create();

  @override
  void initState() {
    super.initState();
    scrollOffsetListener.changes.asBroadcastStream().listen((offset) {
      if (offset >= 0.8) {
        cubit.scrollAndCallMessages();
      }
    });
  }

  void animateToTargetMessage(int id) {
    final index = indexIdMap[id];
    if (index != null) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SharedChatCubit, SharedChatState>(
        bloc: cubit..loadChat(widget.encryptedId),
        builder: (context, state) {
          final currentChat = state.chat;
          final title =
              "${currentChat.participants.map((participant) => participant.user?.username).join(" - ")} Conversation";

          return SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.secondaryColor,
                        AppColor.primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                state.isLoading
                    ? const SizedBox()
                    : state.chat.id == 0
                        ? Center(
                            child: Text(
                              'Chat not found!',
                              style: Styles.boldStyle(
                                fontSize: 18,
                                color: AppColor.white,
                                family: FontFamily.kanit,
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 0.08.sh,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor,
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      title,
                                      style: Styles.boldStyle(
                                        fontSize: 18,
                                        color: AppColor.white,
                                        family: FontFamily.kanit,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 16.w),
                                  child: ScrollablePositionedList.builder(
                                    reverse: true,
                                    itemScrollController: itemScrollController,
                                    scrollOffsetListener: scrollOffsetListener,
                                    itemCount: currentChat
                                        .messagePagination.data.length,
                                    itemBuilder: (context, index) {
                                      final message = currentChat
                                          .messagePagination.data[index];
                                      indexIdMap.putIfAbsent(
                                          message.id, () => index);
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: OtherMessage(
                                          message: message,
                                          onReplyTap: () {
                                            animateToTargetMessage(
                                              message.replyTo!.id,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              AppButton(
                                  height: 60,
                                  width: 0.2.sw,
                                  title: "Start your own space",
                                  onTap: () async {
                                    const url = 'https://communico.as3hr.dev/';
                                    if (await canLaunchUrl(Uri.parse(url))) {
                                      await launchUrl(
                                        Uri.parse(url),
                                        mode: LaunchMode.platformDefault,
                                      );
                                    } else {
                                      log("An error occurred while launching the URL");
                                    }
                                  }),
                              10.verticalSpace,
                            ],
                          ),
              ],
            ),
          );
        },
      ),
    );
  }
}
