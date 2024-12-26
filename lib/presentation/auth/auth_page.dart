import 'package:communico_frontend/helpers/widgets/app_button.dart';
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
  static final cubit = getIt<AuthCubit>();
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<AuthCubit, AuthState>(
        bloc: cubit,
        builder: (context, state) {
          return SafeArea(
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
                            final regex = RegExp(r'^[a-z0-9_.]{4,10}$');
                            if (val == null || val.isEmpty) {
                              return "Username cannot be empty";
                            } else if (val.length < 4) {
                              return "Username must be at least 4 characters long";
                            } else if (val.length > 10) {
                              return "Wow, planning a novel? Keep it short, champ!";
                            } else if (!regex.hasMatch(val)) {
                              return "Only lowercase letters, numbers, underscores, '.' allowed.";
                            }
                            return null;
                          },
                          onSubmitted: (val) {
                            if (state.username.isNotEmpty &&
                                _formKey.currentState!.validate()) {
                              cubit.getIn();
                            }
                          },
                          prefixIcon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        if (state.passwordProtected) ...[
                          InputField(
                            hintText: "Enter your password",
                            onChanged: (val) {
                              state.password = val;
                            },
                            onSubmitted: (val) {
                              if (state.password?.isNotEmpty ?? false) {
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
                              if (state.username.isNotEmpty &&
                                  _formKey.currentState!.validate()) {
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
          );
        },
      ),
    );
  }
}
