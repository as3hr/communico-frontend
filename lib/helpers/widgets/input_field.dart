import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../extensions.dart';
import '../styles/app_colors.dart';
import '../styles/styles.dart';

class InputField extends StatefulWidget {
  const InputField({
    super.key,
    this.preFilledValue,
    this.passwordField = false,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
    this.inputFormatters,
    this.isDateField = false,
    this.focusNode,
    this.onSubmit,
    this.maxLength,
    this.textEditingController,
    this.suffixIcon,
    this.onCrossTap,
    this.borderRadius,
    this.showCrossIcon = false,
    this.onTap,
    this.disableOnTapOutside = false,
    required this.onChanged,
  });

  final String? preFilledValue;
  final bool passwordField;
  final String? hintText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDateField;
  final FocusNode? focusNode;
  final void Function(String)? onSubmit;
  final int? maxLength;
  final TextEditingController? textEditingController;
  final Widget? suffixIcon;
  final void Function()? onCrossTap;
  final double? borderRadius;
  final bool showCrossIcon;
  final void Function()? onTap;
  final bool disableOnTapOutside;
  final void Function(String) onChanged;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController controller;
  bool isObscure = true;

  @override
  void initState() {
    super.initState();
    controller = widget.textEditingController ?? TextEditingController();
    if (widget.preFilledValue != null) {
      controller.text = widget.preFilledValue!;
    }
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
      obscureText: widget.passwordField && isObscure,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onSubmit,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.done,
      style: Styles.semiMediumStyle(
        fontSize: 15,
        color: context.colorScheme.onPrimary,
        family: FontFamily.varela,
      ),
      cursorColor: context.colorScheme.onPrimary,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Styles.mediumStyle(
          fontSize: 15,
          color: AppColor.grey,
          family: FontFamily.varela,
        ),
        suffixIcon: widget.suffixIcon ?? _buildSuffixIcon(context),
        fillColor: context.colorScheme.secondary,
        contentPadding: const EdgeInsets.all(8),
        enabledBorder: _buildBorder(context.colorScheme.onPrimary),
        focusedBorder:
            _buildBorder(context.colorScheme.onPrimary, isFocused: true),
        errorBorder: _buildBorder(AppColor.red),
        focusedErrorBorder: _buildBorder(AppColor.red),
        errorStyle: Styles.boldStyle(
          fontSize: 12,
          color: AppColor.red,
        ),
      ),
      onTapOutside: (event) {
        if (!widget.disableOnTapOutside) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (widget.passwordField) {
      return GestureDetector(
        onTap: () {
          setState(() {
            isObscure = !isObscure;
          });
        },
        child: Icon(
          isObscure ? Icons.visibility_off : Icons.visibility,
          color: context.colorScheme.onPrimary,
        ),
      );
    }
    if (widget.showCrossIcon) {
      return GestureDetector(
        onTap: () {
          controller.clear();
          widget.onCrossTap?.call();
        },
        child: Icon(
          Icons.cancel,
          color: context.colorScheme.onPrimary,
        ),
      );
    }
    return null;
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
