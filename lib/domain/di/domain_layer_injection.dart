import 'module/post_module.dart';

class DomainLayerInjection {
  static Future<void> configureDataLayerInjection() async {
    await PostModule.configurePostModuleInjection();
  }
}
