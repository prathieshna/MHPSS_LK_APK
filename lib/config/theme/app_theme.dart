import 'package:flutter/material.dart';

import '../../core/resources/all_imports.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context, Locale locale) {
    return ThemeData(
      useMaterial3: true,
      fontFamily: locale.languageCode == 'ar' ? 'Kufi' : 'Inter',
      primaryColor: AppColors.appBlueColor,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appBlueColor),
      textTheme: AppTextTheme.lightTheme(context, locale),
      unselectedWidgetColor: AppColors.appUnSelectedColor,
      scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor: WidgetStateProperty.all(const Color(0XFFD9D9D9)),
      ),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            fontFamily: locale.languageCode == 'ar' ? 'Kufi' : 'Inter',
            color: AppColors.appWhiteColor,
            fontSize: 18,
            fontWeight: FontWeight.w500),
        elevation: 0.0,
      ),
      
      hintColor: AppColors.textBlackColor,
      scaffoldBackgroundColor: AppColors.appWhiteColor,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          // backgroundColor: AppColors.appRippleColor,a
          ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black.withOpacity(0),
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: TextStyle(fontSize: 12.0, color: Colors.white),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
      
        hintStyle: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textTitleColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.searchFieldBorderColor),
        ),
        constraints: BoxConstraints(minHeight: 40.0, maxHeight: 45.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: AppColors.searchFieldBorderColor),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context, Locale locale) {
    return ThemeData(
      fontFamily: locale.languageCode == 'ar' ? 'Kufi' : 'Inter',
      scaffoldBackgroundColor: Colors.blueGrey.shade800,
      textTheme: AppTextTheme.darkTheme(context, locale),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: AppColors.textBlackColor,
      ),
      // appBarTheme: AppBarTheme(
      //   color: Colors.blueGrey.shade800,
      //   titleTextStyle: const TextStyle(
      //     color: AppColors.appWhiteColor,
      //     fontSize: 18,
      //     fontWeight: FontWeight.w500,
      //   ),
      // ),
    );
  }
}
