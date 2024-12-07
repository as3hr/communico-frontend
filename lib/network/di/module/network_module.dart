import '../../network_repository.dart';

import '../../../di/service_locator.dart';

class NetworkModule {
  static Future<void> configureNetwokModuleInjection() async {
    getIt.registerSingleton<NetworkRepository>(NetworkRepository(
      getIt(),
      getIt(),
    ));
  }
}
