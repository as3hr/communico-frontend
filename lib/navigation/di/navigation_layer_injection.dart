import '../../di/service_locator.dart';
import '../app_navigation.dart';

class NavigationLayerInjection {
  static Future<void> configureNavigationLayerInjection() async {
    sl.registerSingleton<AppNavigation>(AppNavigation());
  }
}
