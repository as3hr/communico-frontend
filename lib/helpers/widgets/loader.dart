import 'package:communico_frontend/helpers/widgets/background.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Background(
        children: [Center(child: CircularProgressIndicator())]);
  }
}
