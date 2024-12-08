import 'package:communico_frontend/presentation/home/home_navigator.dart';

import '../../navigation/app_navigation.dart';

class AuthNavigator with HomeRoute {
  @override
  final AppNavigation navigation;
  AuthNavigator(this.navigation);
}

mixin AuthRoute {}
