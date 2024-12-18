import 'package:communico_frontend/navigation/route_name.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room_query_params.dart';

import '../../navigation/app_navigation.dart';

class HomeNavigator {
  final AppNavigation navigation;
  HomeNavigator(this.navigation);

  goToChatRoom(ChatRoomQueryParams params) {
    navigation.push(RouteName.chatRoom, arguments: {
      'params': params,
    });
  }
}

mixin HomeRoute {
  AppNavigation get navigation;

  goToHome() => navigation.push(RouteName.home);
}
