// ignore_for_file: unused_local_variable

import 'package:communico_frontend/presentation/auth/auth_page.dart';
import 'package:communico_frontend/presentation/home/components/chat_rom/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:communico_frontend/navigation/route_name.dart';

import '../presentation/home/home_screen.dart';

enum TransitionType {
  fade,
  slide,
}

Route<dynamic> generateRoute(RouteSettings settings) {
  final args =
      (settings.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;

  switch (settings.name) {
    case RouteName.home:
      return getRoute(const HomeScreen(), TransitionType.slide);

    case RouteName.getIn:
      return getRoute(const AuthPage(), TransitionType.fade);

    case RouteName.chatRoom:
      return getRoute(
          ChatRoom(
            messageActionsParams: args["messageActionsParams"],
            params: args["params"],
          ),
          TransitionType.slide);

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('PAGE NOT FOUND!!')),
        ),
      );
  }
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
