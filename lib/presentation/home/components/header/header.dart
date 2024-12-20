import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import 'header_content.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.userName, required this.logOut});
  final String userName;
  final void Function() logOut;

  static final cubit = getIt<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      bloc: cubit,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: context.isMobile || context.isTablet
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: HeaderContent(
                              currentQuote: state.currentQuote,
                              logOut: logOut,
                              userName: userName))
                      : HeaderContent(
                          currentQuote: state.currentQuote,
                          logOut: logOut,
                          userName: userName,
                        )),
            ),
          ],
        );
      },
    );
  }
}
