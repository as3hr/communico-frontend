import 'package:communico_frontend/navigation/app_navigation.dart';
import 'package:communico_frontend/navigation/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../helpers/styles/app_theme.dart';

class Communico extends StatelessWidget {
  const Communico({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(300, 200),
        builder: (context, _) {
          return MaterialApp(
            title: 'Communico',
            theme: AppTheme.theme(),
            debugShowCheckedModeBanner: false,
            navigatorKey: AppNavigation.navigatorKey,
            onGenerateRoute: generateRoute,
          );
        });
  }
}
