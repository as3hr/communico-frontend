import 'package:communico_frontend/domain/stores/user_store.dart';

import '../../../di/service_locator.dart';

class StoreModule {
  static Future<void> configureStoreModuleInjection() async {
    sl.registerSingleton<UserStore>(
      UserStore(),
    );
  }
}
