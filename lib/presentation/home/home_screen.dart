import 'package:communico_frontend/presentation/home/components/home_body.dart';
import 'package:communico_frontend/presentation/home/components/loading_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:communico_frontend/presentation/home/home_cubit.dart';
import 'package:communico_frontend/presentation/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final cubit = getIt<HomeCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
        bloc: cubit,
        builder: (context, state) {
          return Scaffold(
              body: state.isLoading ? const LoadingHome() : const HomeBody());
        });
  }
}
