import 'package:flutter/material.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'presentation/communico.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.configureServiceLocator();
  Gemini.init(apiKey: "apiKey");
  runApp(const Communico());
}
