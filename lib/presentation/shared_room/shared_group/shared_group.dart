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
import '../../../helpers/widgets/app_button.dart';
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
      endDrawer: const MembersCard(),
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
                    ? const SizedBox()
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
                                  children: [
                                    const Spacer(),
                                    Text(
                                      title,
                                      style: Styles.boldStyle(
                                        fontSize: 18,
                                        color: AppColor.white,
                                        family: FontFamily.kanit,
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        icon: const Icon(
                                          Icons.menu,
                                          color: AppColor.white,
                                        )),
                                    2.horizontalSpace,
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

class MembersCard extends StatelessWidget {
  const MembersCard({super.key});
  static final cubit = sl<SharedGroupCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SharedGroupCubit, SharedGroupState>(
      bloc: cubit,
      builder: (context, state) {
        final members = state.group.members;
        return Column(
          children: [
            Expanded(
              child: Container(
                width: 0.3.sw,
                padding: const EdgeInsets.all(16),
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
                height: 0.9.sh,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Members:",
                        style: Styles.boldStyle(
                          fontSize: 12,
                          color: AppColor.white,
                          family: FontFamily.kanit,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const Divider(
                            thickness: 0.5,
                          ),
                          itemCount: members.length,
                          itemBuilder: (context, index) {
                            final member = members[index];
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: context.colorScheme.secondary,
                                child: Text(
                                  (member.user?.username ?? "?")
                                      .substring(0, 1),
                                  style: Styles.mediumStyle(
                                    fontSize: 12,
                                    color: AppColor.white,
                                    family: FontFamily.montserrat,
                                  ),
                                ),
                              ),
                              title: Text(
                                member.user?.username ?? "Unknown",
                                style: Styles.mediumStyle(
                                  fontSize: 12,
                                  color: AppColor.white,
                                  family: FontFamily.montserrat,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
