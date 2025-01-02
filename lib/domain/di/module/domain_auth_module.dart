import '../../../data/auth/api_auth_repository.dart';
import '../../../di/service_locator.dart';
import '../../repositories/auth_repository.dart';

class DomainAuthModule {
  static Future<void> configureAuthModuleInjection() async {
    sl.registerSingleton<AuthRepository>(
      ApiAuthRepository(
        sl(),
      ),
    );
  }
}
