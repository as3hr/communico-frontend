import 'package:flutter/material.dart';

import '../styles/app_colors.dart';
import '../styles/styles.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    required this.hintText,
    required this.onChanged,
    required this.onSubmitted,
    this.prefixIcon,
    this.prefilledValue,
    this.validator,
    this.enabled = true,
  });
  final void Function(String) onChanged;
  final void Function(String) onSubmitted;
  final String hintText;
  final String? prefilledValue;
  final IconData? prefixIcon;
  final bool enabled;
  final String? Function(String?)? validator;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.prefilledValue != null) {
      controller.text = widget.prefilledValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      controller: controller,
      onChanged: (val) {
        widget.onChanged.call(val);
      },
      onFieldSubmitted: (val) {
        widget.onSubmitted.call(val);
      },
      style: const TextStyle(color: Colors.white),
      validator: (val) {
        return widget.validator?.call(val);
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Styles.lightStyle(
          fontSize: 15,
          color: AppColor.white,
          family: FontFamily.montserrat,
        ),
        filled: true,
        prefixIcon: Icon(widget.prefixIcon, color: Colors.grey.shade600),
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
