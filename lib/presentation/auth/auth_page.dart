import 'package:communico_frontend/helpers/widgets/app_button.dart';
import 'package:communico_frontend/helpers/widgets/background.dart';
import 'package:communico_frontend/helpers/widgets/input_field.dart';
import 'package:communico_frontend/presentation/auth/auth_cubit.dart';
import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di/service_locator.dart';
import '../../helpers/styles/app_colors.dart';
import '../../helpers/styles/styles.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static final cubit = sl<AuthCubit>();
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: cubit,
        builder: (context, state) {
          return SafeArea(
            child: Background(children: [
              SelectionArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Communico",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Kanit",
                                color: Colors.white,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Connect with your world, one chat at a time.",
                              style: Styles.lightStyle(
                                fontSize: 15,
                                color: AppColor.white,
                                family: FontFamily.montserrat,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),
                            InputField(
                              hintText: "Enter your username",
                              onChanged: (val) {
                                state.username = val;
                              },
                              validator: (val) {
                                if (val != null) {
                                  if (val.length < 3) {
                                    return "Username is too short";
                                  }
                                  if (val.length > 10) {
                                    return "Wow! That's a long username";
                                  }
                                }
                                return null;
                              },
                              onSubmitted: (val) {
                                if ((_formKey.currentState?.validate() ??
                                        false) &&
                                    state.username.isNotEmpty) {
                                  cubit.getIn();
                                }
                              },
                              prefixIcon: Icons.person,
                            ),
                            const SizedBox(height: 20),
                            if (state.passwordProtected) ...[
                              InputField(
                                hintText: "Enter your password",
                                passwordField: true,
                                onChanged: (val) {
                                  state.password = val;
                                },
                                onSubmitted: (val) {
                                  if ((state.password?.isNotEmpty ?? false)) {
                                    cubit.getIn();
                                  }
                                },
                                prefixIcon: Icons.lock_outline_rounded,
                              ),
                              const SizedBox(height: 20),
                            ],
                            AppButton(
                                title: "GET IN",
                                onTap: () {
                                  if ((_formKey.currentState?.validate() ??
                                          false) &&
                                      state.username.isNotEmpty) {
                                    cubit.getIn();
                                  }
                                }),
                            const SizedBox(height: 40),
                            Text(
                              "Powered by Communico",
                              style: Styles.lightStyle(
                                fontSize: 12,
                                color: AppColor.white,
                                family: FontFamily.montserrat,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
