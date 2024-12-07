import '../../../di/service_locator.dart';
import '../../auth/auth_cubit.dart';

class AuthModule {
  static Future<void> configureAuthModuleInjection() async {
    getIt.registerSingleton<AuthCubit>(
      AuthCubit(),
    );
  }
}
