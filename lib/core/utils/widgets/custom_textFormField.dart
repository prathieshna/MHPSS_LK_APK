import 'package:beprepared/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? textInputType;
  final int? maxLines;
  final int? minLines;
  final bool readOnly;
  final bool disableColor;
  final bool isPassword;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator,
    this.textInputType,
    this.readOnly = false,
    this.disableColor = false,
    this.maxLines = 1,
    this.minLines,
    this.isPassword = false,
  });

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        minLines: widget.minLines,
        readOnly: widget.readOnly,
        keyboardType: widget.textInputType ?? TextInputType.text,
        obscureText: widget.isPassword && _obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColors.hintTextColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(
              color: AppColors.appUnSelectedColor,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
          filled: true,
          fillColor: widget.disableColor
              ? AppColors.appUnSelectedColor.withOpacity(0.5)
              : Colors.white,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.verticalDividerColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
        ),
        validator: widget.validator,
      ),
    );
  }
}
