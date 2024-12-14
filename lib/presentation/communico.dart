import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:communico_frontend/navigation/app_navigation.dart';
import 'package:communico_frontend/navigation/route_generator.dart';
import 'package:communico_frontend/navigation/route_name.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:universal_html/html.dart';

import '../helpers/styles/app_theme.dart';

class Communico extends StatelessWidget {
  const Communico({super.key});
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
        enabled: false,
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
          return AdaptiveTheme(
              light: AppTheme.theme(),
              initial: AdaptiveThemeMode.dark,
              dark: AppTheme.theme(dark: true),
              builder: (light, dark) {
                return ScreenUtilInit(
                    useInheritedMediaQuery: true,
                    designSize: const Size(300, 200),
                    builder: (context, _) {
                      return MaterialApp(
                        theme: light,
                        darkTheme: dark,
                        debugShowCheckedModeBanner: false,
                        navigatorKey: AppNavigation.navigatorKey,
                        onGenerateRoute: generateRoute,
                        initialRoute: window.localStorage['authToken'] != null
                            ? RouteName.home
                            : RouteName.getIn,
                      );
                    });
              });
        });
  }
}
