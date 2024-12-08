import 'package:communico_frontend/presentation/home/home_cubit.dart';

import '../../../di/service_locator.dart';

class HomeModule {
  static Future<void> configureHomeModuleInjection() async {
    getIt.registerLazySingleton<HomeCubit>(
      () => HomeCubit(
        getIt(),
        getIt(),
        getIt(),
      )..fetchData(),
    );
  }
}
