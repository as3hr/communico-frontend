import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import '../styles/styles.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    this.prefixIcon,
    this.validator,
  });
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final String hintText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (val) {
        onChanged.call(val);
      },
      onFieldSubmitted: (val) {
        onSubmitted.call(val);
      },
      style: const TextStyle(color: Colors.white),
      validator: (val) {
        return validator?.call(val);
      },
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Styles.lightStyle(
          fontSize: 15,
          color: AppColor.white,
          family: FontFamily.montserrat,
        ),
        filled: true,
        fillColor: Colors.grey.shade900,
        prefixIcon: Icon(prefixIcon, color: Colors.grey.shade600),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        errorBorder: _buildBorder(AppColor.red),
        focusedErrorBorder: _buildBorder(AppColor.red),
        errorStyle: Styles.boldStyle(
          fontSize: 12,
          color: AppColor.red,
          family: FontFamily.kanit,
        ),
      ),
    );
  }

  OutlineInputBorder _buildBorder(Color color, {bool isFocused = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: isFocused ? 0.5 : 0.5,
      ),
      borderRadius: BorderRadius.circular(10),
    );
  }
}
