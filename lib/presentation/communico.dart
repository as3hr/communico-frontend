import 'package:communico_frontend/presentation/auth/auth_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final appContext = navigatorKey.currentState!.context;

class Communico extends StatelessWidget {
  const Communico({super.key});
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
        enabled: true,
        backgroundColor: Colors.white,
        defaultDevice: Devices.ios.iPhone13ProMax,
        isToolbarVisible: true,
        tools: const [
          DeviceSection(
            model: true,
            orientation: false,
            frameVisibility: false,
            virtualKeyboard: false,
          ),
        ],
        builder: (context) {
          return ScreenUtilInit(
              useInheritedMediaQuery: true,
              designSize: const Size(300, 200),
              builder: (context, _) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  navigatorKey: navigatorKey,
                  // home:  const HomeScreen(),
                  home: const AuthPage(),
                  builder: DevicePreview.appBuilder,
                );
              });
        });
  }
}
