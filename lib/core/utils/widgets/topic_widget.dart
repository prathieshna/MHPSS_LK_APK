import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String topic;
  final String forwardText;
  final Function() onPressed;

  const TitleWidget(
      {super.key,
      required this.topic,
      required this.forwardText,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 2.h),
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: AppColors.textTitleColor, width: 2.0))),
              child: Text(topic,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  )),
            )
          ],
        ),
        const Spacer(),
        AppButton(onPressed: onPressed, text: forwardText),
      ],
    );
  }
}
