import 'package:communico_frontend/initializer.dart';
import 'package:flutter/material.dart';

import 'presentation/communico.dart';

Future<void> main() async {
  await Initializer.initApp();
  runApp(const Communico());
}
