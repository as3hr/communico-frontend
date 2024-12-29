import 'package:flutter/material.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/communico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/dotenv.txt");
  await ServiceLocator.configureServiceLocator();
  runApp(const Communico());
}
