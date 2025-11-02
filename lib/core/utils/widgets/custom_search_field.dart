import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? prefixIcon;
  final bool readOnly;
  final Function(String)? onChanged;
  final VoidCallback? tapOnIcon;
  final VoidCallback? onTap;

  const CustomSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    required this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.tapOnIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.0, // Adjust elevation as needed
      borderRadius: BorderRadius.circular(10.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 45.0, maxHeight: 45.0),
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: AppColors.appWhiteColor,
            hintStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textTitleColor,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: AppColors.searchFieldBorderColor),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: AppColors.searchFieldBorderColor),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: AppColors.searchFieldBorderColor),
            ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            suffixIcon: GestureDetector(
              onTap: tapOnIcon,
              child: SvgPicture.asset(
                prefixIcon ?? AppImages.searchIcon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
