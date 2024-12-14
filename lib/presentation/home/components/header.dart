import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "WELCOME TO COMMUNICO $username",
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
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
