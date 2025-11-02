import 'package:flutter/material.dart';

import '../../core/resources/all_imports.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTheme(BuildContext context, Locale locale) {
    return Theme.of(context).textTheme.copyWith(
          displayLarge: _buildTextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 36.sp,
            locale: locale,
          ),
          displayMedium: _buildTextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 32.sp,
            locale: locale,
          ),
          displaySmall: _buildTextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 28.sp,
            locale: locale,
          ),
          titleLarge: _buildTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            locale: locale,
          ),
          titleMedium: _buildTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
            locale: locale,
          ),
          titleSmall: _buildTextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
            locale: locale,
          ),
          bodyLarge: _buildTextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            locale: locale,
          ),
          bodyMedium: _buildTextStyle(
            fontSize: 14.sp,
            locale: locale,
          ),
          bodySmall: _buildTextStyle(
            fontSize: 12.sp,
            locale: locale,
          ),
          labelLarge: _buildTextStyle(
            fontSize: 16.sp,
            locale: locale,
          ),
          labelMedium: _buildTextStyle(
            fontSize: 14.sp,
            locale: locale,
          ),
          labelSmall: _buildTextStyle(
            fontSize: 12.sp,
            locale: locale,
          ),
          headlineLarge: _buildTextStyle(
            fontSize: 10.sp,
            locale: locale,
          ),
        );
  }

  static TextTheme darkTheme(BuildContext context, Locale locale) {
    return Theme.of(context).textTheme;
  }

  static TextStyle _buildTextStyle({
    required Locale locale,
    FontWeight fontWeight = FontWeight.normal,
    double fontSize = 12.0,
    Color color = AppColors.textBlackColor,
  }) {
    // Set the font family based on the locale
    final fontFamily = locale.languageCode == 'ar' ? 'Kufi' : 'Inter';
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}
