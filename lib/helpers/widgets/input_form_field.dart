import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions.dart';
import '../styles/app_colors.dart';
import '../styles/styles.dart';

class InputFormField extends StatefulWidget {
  const InputFormField({
    super.key,
    this.keyboardType,
    this.hintText,
    this.validator,
    this.inputFormatters,
    this.focusNode,
    this.onSubmit,
    this.textEditingController,
    this.suffixIcon,
    this.onCrossTap,
    this.borderRadius,
    this.onTap,
    this.showBorder = true,
    this.disableOnTapOutside = false,
    required this.onChanged,
  });

  final bool showBorder;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;
  final void Function(String)? onSubmit;
  final TextEditingController? textEditingController;
  final Widget? suffixIcon;
  final void Function()? onCrossTap;
  final double? borderRadius;
  final void Function()? onTap;
  final bool disableOnTapOutside;
  final void Function(String) onChanged;

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  late TextEditingController controller;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    controller = widget.textEditingController ?? TextEditingController();
  }

  @override
  void dispose() {
    widget.focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: controller,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onTap: widget.onTap,
      autofocus: true,
      validator: widget.validator,
      maxLines: null,
      minLines: 1,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.newline,
      cursorColor: context.colorScheme.onPrimary,
      cursorHeight: 20,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        border: !widget.showBorder ? InputBorder.none : null,
        fillColor: context.colorScheme.primary,
        enabledBorder: widget.showBorder ? _buildBorder(AppColor.black1) : null,
        focusedBorder: widget.showBorder
            ? _buildBorder(AppColor.black1, isFocused: true)
            : null,
        errorBorder: _buildBorder(AppColor.red),
        focusedErrorBorder: _buildBorder(AppColor.red),
        errorStyle: Styles.boldStyle(
          fontSize: 12,
          color: AppColor.red,
          family: FontFamily.bangers,
        ),
      ),
      onTapOutside: (event) {
        if (!widget.disableOnTapOutside) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }

  OutlineInputBorder _buildBorder(Color color, {bool isFocused = false}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: isFocused ? 0.5 : 0.5,
      ),
      borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
    );
  }
}
