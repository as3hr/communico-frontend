import '../extensions.dart';
import '../styles/styles.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';
import 'package:flutter/material.dart';

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
  final List<TextInputFormatter>? inputFormatters;
  final String? preFilledValue;
  final bool disableOnTapOutside;
  final bool passwordField;
  final void Function()? onTap;
  final int? maxLength;
  final bool isDateField;
  final bool readOnly;
  final String? hintText;
  final bool showCrossIcon;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final double? borderRadius;
  final Widget? suffixIcon;
  final void Function()? onCrossTap;
  final String? Function(String?)? validator;
  final void Function(String) onChanged;
  final void Function(String)? onSubmit;
  final FocusNode? focusNode;
  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late TextEditingController controller;
  bool isObsecure = true;

  @override
  void initState() {
    super.initState();
    if (widget.textEditingController != null) {
      controller = widget.textEditingController!;
    } else {
      controller = TextEditingController();
    }
    if (widget.preFilledValue != null) {
      controller.text = '${widget.preFilledValue}';
    }
  }

  @override
  void dispose() {
    if (widget.focusNode != null) {
      // widget.focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        focusNode: widget.focusNode,
        textInputAction: TextInputAction.done,
        onTapOutside: (event) {
          if (!widget.disableOnTapOutside) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        keyboardType: widget.keyboardType,
        controller: controller,
        style: Styles.semiMediumStyle(
          fontSize: 15,
          color: context.colorScheme.onPrimary,
          family: FontFamily.varela,
        ),
        inputFormatters: widget.inputFormatters,
        obscureText: widget.passwordField ? isObsecure : false,
        readOnly: widget.readOnly,
        cursorColor: context.colorScheme.onPrimary,
        cursorErrorColor: context.colorScheme.onPrimary,
        onChanged: widget.onChanged,
        validator: widget.validator,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        maxLength: widget.maxLength,
        scrollPadding: const EdgeInsets.all(0),
        onFieldSubmitted: widget.onSubmit,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon ??
              (widget.passwordField
                  ? GestureDetector(
                      onTap: () {
                        isObsecure = !isObsecure;
                        setState(() {});
                      },
                      child: Icon(
                        isObsecure
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded,
                        color: context.colorScheme.onPrimary,
                      ))
                  : widget.showCrossIcon
                      ? GestureDetector(
                          onTap: () {
                            controller.text = "";
                            widget.onCrossTap?.call();
                          },
                          child: Icon(
                            Icons.cancel,
                            color: context.colorScheme.onPrimary,
                          ))
                      : null),
          fillColor: context.colorScheme.secondary,
          errorStyle: Styles.boldStyle(
            fontSize: 12, color: AppColor.red,
            // family: FontFamily.varela
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.red,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          ),
          errorMaxLines: 1,
          contentPadding: const EdgeInsets.all(8),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColor.red,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          ),
          hintStyle: Styles.mediumStyle(
              fontSize: 15, color: AppColor.grey, family: FontFamily.varela),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colorScheme.onPrimary,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: context.colorScheme.onPrimary,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
          ),
        ));
  }
}
