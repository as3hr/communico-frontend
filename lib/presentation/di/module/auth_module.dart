import 'package:communico_frontend/presentation/auth/auth_navigator.dart';

import '../../../di/service_locator.dart';
import '../../auth/auth_cubit.dart';

class AuthModule {
  static Future<void> configureAuthModuleInjection() async {
    getIt.registerSingleton<AuthNavigator>(AuthNavigator(getIt()));
    getIt.registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt(), getIt()),
    );
  }
}
