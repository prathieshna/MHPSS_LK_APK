import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  // Changed from ConsumerStatefulWidget
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.height,
    this.horizontalPadding,
  });

  final Function()? onPressed;
  final String text;
  final double? height;
  final double? horizontalPadding;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding ?? 10.0, vertical: 2.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: AppColors.appGradientColors),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: 0.0,
            spacing: 14.0,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                    color: AppColors.appWhiteColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: SvgPicture.asset(
                  navigatorKey.currentContext!.locale.languageCode == 'ar'
                      ? AppImages.arrowForwardArSvg
                      : AppImages.arrowForwardSvg,
                  height: 12,
                  width: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
