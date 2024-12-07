import '../network_monitor.dart';

import '../../di/service_locator.dart';

class ServiceInjection {
  static Future<void> configureServiceLayerInjction() async {
    getIt.registerSingleton<NetworkMonitor>(NetworkMonitor());
  }
}
