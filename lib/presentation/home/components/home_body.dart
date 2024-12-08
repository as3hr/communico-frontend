import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/widgets/theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/service_locator.dart';
import '../home_cubit.dart';
import '../home_state.dart';
import 'chat_tab_view/chat_room.dart';
import 'chat_tab_view/chat_room_detail.dart';
import 'chat_tab_view/chats_list.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody>
    with SingleTickerProviderStateMixin {
  final cubit = getIt<HomeCubit>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: .03.sw, vertical: .01.sw),
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "COMMUNICO",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TabBar(
                                  indicatorColor: context.colorScheme.onPrimary,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  unselectedLabelStyle: const TextStyle(
                                      fontSize: 12, color: AppColor.grey),
                                  labelStyle: const TextStyle(
                                      fontSize: 12, color: AppColor.white),
                                  labelPadding: const EdgeInsets.only(
                                      bottom: 5, left: 15, right: 15),
                                  tabAlignment: TabAlignment.start,
                                  isScrollable: true,
                                  dividerColor: Colors.transparent,
                                  onTap: (index) {},
                                  controller: tabController,
                                  tabs: const [
                                    Text("Direct Message"),
                                    Text("Group Message"),
                                  ]),
                            ),
                            const Spacer(),
                            const ThemeSwitch(),
                            10.horizontalSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                5.verticalSpace,
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Row(
                        children: [
                          const Expanded(flex: 2, child: ChatsList()),
                          5.horizontalSpace,
                          const Expanded(flex: 5, child: ChatRoom()),
                          5.horizontalSpace,
                          const Expanded(flex: 2, child: ChatRoomDetail()),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(flex: 2, child: ChatsList()),
                          5.horizontalSpace,
                          const Expanded(flex: 5, child: ChatRoom()),
                          5.horizontalSpace,
                          const Expanded(flex: 2, child: ChatRoomDetail()),
                        ],
                      ),
                    ],
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
