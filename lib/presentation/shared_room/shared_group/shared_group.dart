import 'dart:developer';

import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../di/service_locator.dart';
import '../../../helpers/styles/app_colors.dart';
import '../../../helpers/styles/styles.dart';
import '../../home/components/loading_home.dart';
import '../../home/components/message/my_message.dart';
import '../../home/components/message/other_message.dart';
import 'shared_group_cubit.dart';
import 'shared_group_state.dart';

class SharedGroup extends StatefulWidget {
  const SharedGroup({super.key, required this.encryptedId});
  final String encryptedId;

  @override
  State<SharedGroup> createState() => _SharedGroupState();
}

class _SharedGroupState extends State<SharedGroup> {
  final cubit = sl<SharedGroupCubit>();
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
      body: BlocBuilder<SharedGroupCubit, SharedGroupState>(
        bloc: cubit..loadGroup(widget.encryptedId),
        builder: (context, state) {
          final currentGroup = state.group;
          final title = currentGroup.name;

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
                    ? const LoadingHome()
                    : state.group.id == 0
                        ? Center(
                            child: Text(
                              'Group not found!',
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
                                    itemCount: currentGroup
                                        .messagePagination.data.length,
                                    itemBuilder: (context, index) {
                                      final message = currentGroup
                                          .messagePagination.data[index];
                                      indexIdMap.putIfAbsent(
                                          message.id, () => index);
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.h),
                                        child: index.isEven
                                            ? MyMessage(
                                                message: message,
                                                hideUsername: false,
                                                onReplyTap: () {
                                                  animateToTargetMessage(
                                                      message.replyTo!.id);
                                                },
                                              )
                                            : OtherMessage(
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
                              SizedBox(
                                height: 0.12.sh,
                                child: Center(
                                  child: InkWell(
                                    onTap: () async {
                                      const url =
                                          'https://communico.as3hr.dev/';
                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(
                                          Uri.parse(url),
                                          mode: LaunchMode.platformDefault,
                                        );
                                      } else {
                                        log("An error occurred while launching the URL");
                                      }
                                    },
                                    child: Container(
                                      height: 60,
                                      width: 0.2.sw,
                                      padding: const EdgeInsets.all(10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            context.colorScheme.primary
                                                .withOpacity(
                                                    0.8), // Primary color
                                            context.colorScheme.secondary
                                                .withOpacity(
                                                    0.9), // Secondary color
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Start your own space!",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                            fontFamily:
                                                'Kanit', // Use your desired font
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
