import 'package:communico_frontend/presentation/auth/auth_page.dart';
import 'package:communico_frontend/presentation/shared_room/shared_chat/shared_chat.dart';
import 'package:communico_frontend/presentation/shared_room/shared_group/shared_group.dart';
import 'package:flutter/material.dart';
import 'package:communico_frontend/navigation/route_name.dart';
import 'package:universal_html/html.dart';

import '../presentation/home/home_screen.dart';

enum TransitionType {
  fade,
  slide,
}

Route<dynamic> generateRoute(RouteSettings settings) {
  if (settings.name != null && settings.name!.startsWith('chats/')) {
    final encryptedId = settings.name!.substring(6);
    return getRoute(
      SharedChat(
        encryptedId: encryptedId,
      ),
      TransitionType.slide,
    );
  }

  if (settings.name != null && settings.name!.startsWith('groups/')) {
    final encryptedId = settings.name!.substring(7);
    return getRoute(
      SharedGroup(
        encryptedId: encryptedId,
      ),
      TransitionType.slide,
    );
  }

  switch (settings.name) {
    case RouteName.home:
      return getMainPage();

    case RouteName.getIn:
      return getMainPage();

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('PAGE NOT FOUND!!')),
        ),
      );
  }
}

PageRouteBuilder getMainPage() {
  final token = window.localStorage['authToken'] ?? "";
  return (token.isNotEmpty)
      ? getRoute(const HomeScreen(), TransitionType.slide)
      : getRoute(const AuthPage(), TransitionType.fade);
}

PageRouteBuilder getRoute(Widget page, TransitionType transitionType) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      switch (transitionType) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case TransitionType.slide:
          const begin = Offset(1, 0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
      }
    },
  );
}
