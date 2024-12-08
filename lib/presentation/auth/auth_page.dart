import 'package:communico_frontend/helpers/extensions.dart';
import 'package:communico_frontend/helpers/styles/app_colors.dart';
import 'package:communico_frontend/helpers/styles/styles.dart';
import 'package:communico_frontend/helpers/widgets/input_field.dart';
import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../di/service_locator.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});
  static final cubit = getIt<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black1,
      body: BlocBuilder<AuthCubit, AuthState>(
          bloc: cubit,
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 0.3.sw,
                      height: 0.1.sh,
                      color: AppColor.black1,
                      child: InputField(
                        onChanged: (val) {
                          state.username = val;
                        },
                      ),
                    ),
                  ),
                  20.verticalSpace,
                  Center(
                    child: SizedBox(
                      width: 0.8.sw,
                      height: 0.1.sh,
                      child: ElevatedButton(
                          onPressed: () {
                            if (state.username.isNotEmpty) cubit.getIn();
                          },
                          child: Center(
                            child: Text(
                              "GET IN",
                              style: Styles.boldStyle(
                                fontSize: 12,
                                color: context.colorScheme.primary,
                              ),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
