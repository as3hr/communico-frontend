import 'package:communico_frontend/helpers/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'presentation/communico.dart';

final eventBus = EventBus();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await ServiceLocator.configureServiceLocator();
  Gemini.init(apiKey: dotenv.env['GEMINI_API_KEY'].toString());
  runApp(const Communico());
}
