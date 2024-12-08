import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "COMMUNICO",
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {},
          child: const Text(
            "LOGOUT",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
