import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class TypeAheadDropDown<T> extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final List<T>? listData;
  final void Function(T suggestion) onSuggestionSelected;
  final String Function(T) displayStringForOption;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;

  const TypeAheadDropDown({
    super.key,
    required this.hintText,
    required this.controller,
    required this.listData,
    this.validator,
    required this.onSuggestionSelected,
    required this.displayStringForOption,
    required this.onChanged,
  });

  @override
  State<TypeAheadDropDown<T>> createState() => _TypeAheadDropDownState<T>();

  static List<T> getSuggestions<T>(
    String query,
    List<T>? list,
    String Function(T) displayStringForOption,
  ) {
    if (list == null) return [];
    return list
        .where((item) => displayStringForOption(item)
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }
}

class _TypeAheadDropDownState<T> extends State<TypeAheadDropDown<T>> {
  bool isDropdownOpened = false;

  void toggleDropdown(bool value) {
    setState(() {
      isDropdownOpened = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      controller: widget.controller,

      // onChanged: (value) {

      //   if (widget.onChanged != null) {
      //     widget.onChanged!(value);
      //   }
      // },
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: const Padding(
                padding: EdgeInsetsDirectional.only(end: 0.0),
                child: Icon(Icons.keyboard_arrow_down)),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 25,
              minHeight: 25,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: AppColors.appBlueColor, width: 2.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.appUnSelectedColor,
              ),
            ),
            hintStyle: TextStyle(
                color: AppColors.hintTextColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
            hintText: widget.listData == null
                ? "No ${widget.hintText} found"
                : '${widget.hintText} ',
          ),
        );
      },

      loadingBuilder: (context) => SizedBox(
        height: 50,
        width: double.infinity,
        child: Center(
          child: Text(
            "Sorry no ${widget.hintText} found!",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.greyTextColor,
            ),
          ),
        ),
      ),
      suggestionsCallback: (pattern) {
        print("pattern: $pattern");
        return TypeAheadDropDown.getSuggestions(
          pattern,
          widget.listData ?? <T>[],
          widget.displayStringForOption,
        );
      },
      decorationBuilder: (context, suggestionsBoxController) => Material(
        color: AppColors.appWhiteColor,
        elevation: 4.0,
        borderRadius: BorderRadius.circular(12.0),
      ),
      constraints: const BoxConstraints(
        maxHeight: 200.0, // Set the max height for the suggestions box
      ),
      debounceDuration: const Duration(milliseconds: 400),
      itemBuilder: (context, suggestion) {
        print("suggestion: $suggestion");
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
          child: Text(
            widget.displayStringForOption(suggestion),
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.greyTextColor,
            ),
          ),
        );
      },
      onSelected: widget.onSuggestionSelected,
    );
  }
}
