import 'package:communico_frontend/presentation/home/components/chat_room.dart';
import 'package:communico_frontend/presentation/home/components/chat_room_detail.dart';
import 'package:communico_frontend/presentation/home/components/chats_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          return Scaffold(
              body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(0.05.sw),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        "COMMUNICO",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      const Expanded(flex: 2, child: ChatsList()),
                      10.horizontalSpace,
                      const Expanded(flex: 5, child: ChatRoom()),
                      10.horizontalSpace,
                      const Expanded(flex: 2, child: ChatRoomDetail()),
                    ],
                  ),
                ],
              ),
            ),
          ));
        });
  }
}
