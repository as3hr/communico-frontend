import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff191624),
                Color(0xff191624),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
