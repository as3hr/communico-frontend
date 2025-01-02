import 'package:communico_frontend/presentation/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/service_locator.dart';
import 'auth/auth_cubit.dart';
import 'auth/auth_page.dart';
import 'home/home_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static final cubit = sl<AuthCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
        bloc: cubit..verifyToken(),
        builder: (context, state) {
          return state.isLoading
              ? const SizedBox()
              : state.isAuthenticated
                  ? const HomeScreen()
                  : const AuthPage();
        });
  }
}
