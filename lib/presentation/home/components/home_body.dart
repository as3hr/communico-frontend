import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_tab_view.dart';
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

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return DefaultTabController(
          length: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: .03.sw, vertical: .01.sw),
            child: Center(
              child: Column(
                children: [
                  const Header(),
                  5.verticalSpace,
                  const SubHeader(),
                  5.verticalSpace,
                  const Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        ChatTabView(),
                        GroupTabView(),
                        AiTabView(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
