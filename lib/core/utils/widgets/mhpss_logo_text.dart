import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_colors.dart';

class MHPSSLogoText extends StatelessWidget {
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final double? letterSpacing;
  final TextAlign? textAlign;

  const MHPSSLogoText({
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.letterSpacing,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'MHPSS.lk',
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontSize: fontSize ?? 18.sp,
        fontWeight: fontWeight ?? FontWeight.w600,
        color: color ?? AppColors.appWhiteColor,
        letterSpacing: letterSpacing ?? 0.5,
        fontFamily: 'Inter',
      ),
    );
  }
}