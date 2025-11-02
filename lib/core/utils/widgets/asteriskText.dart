 
import 'package:beprepared/core/resources/all_imports.dart';

import 'package:flutter/material.dart';

class AsteriskText extends StatelessWidget {
  final String labelText;
  const AsteriskText({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: labelText,
          style: TextStyle(
            color: AppColors.appBlackColor,
            fontSize: 12.sp,
          ),
          children: [
            TextSpan(
                text: ' *',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold)),
          ]),
      textAlign: TextAlign.start,
    );
  }
}
