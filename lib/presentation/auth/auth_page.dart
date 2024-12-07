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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: AppColor.black1,
                    child: Center(
                      child: InputField(
                        onChanged: (val) {},
                      ),
                    ),
                  ),
                  20.horizontalSpace,
                  ElevatedButton(
                      onPressed: () {},
                      child: Center(
                        child: Text(
                          "GET IN",
                          style: Styles.boldStyle(
                            fontSize: 20,
                            color: context.colorScheme.primary,
                          ),
                        ),
                      ))
                ],
              ),
            );
          }),
    );
  }
}
