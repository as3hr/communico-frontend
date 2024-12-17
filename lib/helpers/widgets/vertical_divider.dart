import 'package:flutter/material.dart';

class AppVerticalDivider extends StatelessWidget {
  const AppVerticalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: 2,
      color: Colors.white,
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
    );
  }
}
