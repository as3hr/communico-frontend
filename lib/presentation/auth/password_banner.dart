import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../di/service_locator.dart';
import '../../helpers/widgets/app_button.dart';
import '../../helpers/widgets/input_field.dart';

class PasswordBanner extends StatelessWidget {
  const PasswordBanner({super.key});

  static final cubit = getIt<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: cubit,
      builder: (context, state) {
        final isNotEmpty = state.password?.isNotEmpty ?? false;
        return SizedBox(
            width: 0.2.sw,
            height: 0.2.sh,
            child: Column(
              children: [
                InputField(
                  hintText: "Enter your password",
                  onChanged: (val) {
                    state.password = val;
                  },
                  onSubmitted: (val) {
                    if (isNotEmpty) {
                      cubit.getIn();
                    }
                  },
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                const SizedBox(height: 20),
                AppButton(
                    title: "GET IN",
                    onTap: () {
                      if (isNotEmpty) {
                        cubit.getIn();
                      }
                    }),
              ],
            ));
      },
    );
  }
}
