import 'package:flutter/material.dart';
import 'package:communico_frontend/di/service_locator.dart';

import 'presentation/communico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.configureServiceLocator();
  runApp(const Communico());
}
