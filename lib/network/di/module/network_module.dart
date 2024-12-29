import '../../network_repository.dart';

import '../../../di/service_locator.dart';

class NetworkModule {
  static Future<void> configureNetwokModuleInjection() async {
    sl.registerSingleton<NetworkRepository>(NetworkRepository(
      sl(),
      sl(),
    ));
  }
}
