import 'package:communico_frontend/navigation/route_name.dart';

import '../../navigation/app_navigation.dart';

class HomeNavigator {
  final AppNavigation navigation;
  HomeNavigator(this.navigation);

  void goToAuth() => navigation.pushReplacement(RouteName.getIn);
}

mixin HomeRoute {
  AppNavigation get navigation;

  goToHome() => navigation.pushReplacement(RouteName.home);
}
