import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/network_image_widget.dart';
import 'package:beprepared/features/data/models/responses/onboarding_response.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  final Screen item;

  const OnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 44.h),
          Text(
            item.title ?? "",
            style: TextStyle(
              color: AppColors.textBlueColor,
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            item.description ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textBlackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 547.h,
            child: NetworkImageWidget(imageURL: item.image?.url),
          ),
          // Image.asset(
          //   item.imagePath,
          //   scale: 2.1,
          // )
        ],
      ),
    );
  }
}
