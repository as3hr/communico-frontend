import 'module/dio_module.dart';
import 'module/network_module.dart';

class NetworkLayerInjection {
  static Future<void> configureNetworkLayerInjection() async {
    await DioModule.configureDioModuleInjection();
    await NetworkModule.configureNetwokModuleInjection();
  }
}
