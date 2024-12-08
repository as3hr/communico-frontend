import 'module/user_module.dart';

class DomainLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await UserModule.configureUserModuleInjection();
  }
}
