import 'package:communico_frontend/helpers/extensions.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                context.colorScheme.primary,
                context.colorScheme.secondary
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
