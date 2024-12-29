import 'package:communico_frontend/presentation/di/module/auth_module.dart';
import 'package:communico_frontend/presentation/di/module/home_module.dart';
import 'package:communico_frontend/presentation/di/module/shared_module.dart';

class PresentationLayerInjection {
  static Future<void> configurePresentationLayerInjection() async {
    await AuthModule.configureAuthModuleInjection();
    await HomeModule.configureHomeModuleInjection();
    await SharedModule.configureSharedModuleInjection();
  }
}
