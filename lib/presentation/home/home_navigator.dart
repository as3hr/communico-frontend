import 'package:communico_frontend/navigation/route_name.dart';

import '../../navigation/app_navigation.dart';

class HomeNavigator {
  final AppNavigation navigation;
  HomeNavigator(this.navigation);
}

mixin HomeRoute {
  AppNavigation get navigation;

  goToHome() => navigation.push(RouteName.home);
}
