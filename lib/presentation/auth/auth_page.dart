import 'package:communico_frontend/helpers/extensions.dart';
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
      backgroundColor: Colors.black,
      body: BlocBuilder<AuthCubit, AuthState>(
          bloc: cubit,
          builder: (context, state) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: InputField(
                      onChanged: (val) {
                        state.username = val;
                      },
                      onSubmit: (val) {
                        if (state.username.isNotEmpty) cubit.getIn();
                      },
                    ),
                  ),
                  20.verticalSpace,
                  GestureDetector(
                      onTap: () {
                        if (state.username.isNotEmpty) cubit.getIn();
                      },
                      child: Container(
                        width: 0.2.sw,
                        padding: const EdgeInsets.all(10),
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            "GET IN",
                            style: Styles.boldStyle(
                              fontSize: 12,
                              family: FontFamily.dmSans,
                              color: context.colorScheme.primary,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            );
          }),
    );
  }
}
