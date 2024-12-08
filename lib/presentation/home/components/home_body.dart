import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_tab_view.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_tab_view.dart';
import 'package:communico_frontend/presentation/home/components/header.dart';
import 'package:communico_frontend/presentation/home/components/sub_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/service_locator.dart';
import '../home_cubit.dart';
import '../home_state.dart';

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
                const Header(),
                5.verticalSpace,
                SubHeader(
                  tabController: tabController,
                ),
                5.verticalSpace,
                Expanded(
                  child: TabBarView(
                    controller: tabController,
                    children: const [
                      ChatTabView(),
                      GroupTabView(),
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
