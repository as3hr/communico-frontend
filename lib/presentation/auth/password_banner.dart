import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../di/service_locator.dart';
import '../../helpers/widgets/app_button.dart';
import '../../helpers/widgets/input_field.dart';
import '../../helpers/widgets/loader.dart';

class PasswordBanner extends StatelessWidget {
  const PasswordBanner({super.key});

  static final cubit = sl<AuthCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colorScheme.primary,
                  context.colorScheme.secondary
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            width: 0.2.sw,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputField(
                  hintText: "Enter password",
                  onChanged: (val) {
                    state.password = val;
                  },
                  onSubmitted: (val) {
                    if (state.password?.isNotEmpty ?? false) {
                      cubit.updatePassword(context);
                    }
                  },
                  prefixIcon: Icons.lock_outline_rounded,
                ),
                const SizedBox(height: 20),
                AppButton(
                    content: state.isLoading ? const Loader() : null,
                    title: "Update",
                    onTap: () {
                      if (state.password?.isNotEmpty ?? false) {
                        cubit.updatePassword(context);
                      }
                    }),
              ],
            ));
      },
    );
  }
}
