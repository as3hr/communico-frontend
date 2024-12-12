import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    this.prefixIcon,
  });
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final String hintText;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (val) {
        onChanged.call(val);
      },
      onSubmitted: (val) {
        onSubmitted.call(val);
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey.shade900,
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
