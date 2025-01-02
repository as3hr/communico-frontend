import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/utils.dart';
import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/auth/password_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/service_locator.dart';
import '../../home_cubit.dart';
import '../../home_state.dart';
import 'header_content.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  static final cubit = sl<HomeCubit>();

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
                  child: HeaderContent(
                    currentQuote: state.currentQuote,
                    logOut: () {
                      cubit.closeStates();
                      sl<AuthCubit>().logOut();
                    },
                    userName: cubit.user!.username,
                    updatePassword: () {
                      showAppDialog(context, const PasswordBanner());
                    },
                  )),
            ),
          ],
        );
      },
    );
  }
}
