import 'package:communico_frontend/presentation/home/components/ai_tab_view.dart/ai_tab_view.dart';
import 'package:communico_frontend/presentation/home/components/chat_tab_view/chat_tab_view.dart';
import 'package:communico_frontend/presentation/home/components/group_tab_view/group_tab_view.dart';
import 'package:communico_frontend/presentation/home/components/header/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../di/service_locator.dart';
import '../../../helpers/styles/app_colors.dart';
import '../home_cubit.dart';
import '../home_state.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          return DefaultTabController(
            length: 3,
            animationDuration: const Duration(milliseconds: 600),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: .03.sw, vertical: .01.sw),
              child: Center(
                child: Column(
                  children: [
                    if (state.currentStation != null) ...[
                      2.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.music_note_sharp,
                            color: AppColor.violet,
                          ),
                          Text(
                            "playing ${state.currentStation!.title}",
                            style: const TextStyle(
                              fontSize: 15,
                              color: AppColor.white,
                              fontFamily: "Kanit",
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                    5.verticalSpace,
                    const Header(),
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
      ),
    );
  }
}
