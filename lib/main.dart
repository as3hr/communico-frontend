import 'package:communico_frontend/helpers/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:communico_frontend/di/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/communico.dart';

final eventBus = EventBus();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await ServiceLocator.configureServiceLocator();
  runApp(const Communico());
}
