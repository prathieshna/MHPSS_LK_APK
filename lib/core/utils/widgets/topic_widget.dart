import 'package:mhpss_app/core/resources/all_imports.dart';
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 2.h),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: AppColors.textTitleColor, width: 2.0))),
                child: Text(topic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    )),
              )
            ],
          ),
        ),
        const SizedBox(width: 8),
        AppButton(onPressed: onPressed, text: forwardText),
      ],
    );
  }
}
