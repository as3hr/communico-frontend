import 'package:flutter/material.dart';

import 'di/service_locator.dart';
import 'helpers/styles/app_images.dart';

class Initializer {
  static Future<void> initApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await ServiceLocator.configureServiceLocator();
    AppImages.loadImages();
  }
}
