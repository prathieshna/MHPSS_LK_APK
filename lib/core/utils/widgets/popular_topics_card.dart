import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class PopularTopicsCard extends StatelessWidget {
  final ToolkitAllCategory toolkitCategory;
  final VoidCallback? onTap;

  const PopularTopicsCard({
    super.key,
    required this.toolkitCategory,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130.h,
        width: 130.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: NetworkImage(toolkitCategory.image?.url ?? ""),
            fit: BoxFit.fill,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.appBlackColor.withOpacity(0.8),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     // Colors.transparent,
            //     Colors.black.withOpacity(0.5),
            //     Colors.black.withOpacity(0.5),
            //   ],
            // ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                toolkitCategory.title ?? "",
                textAlign: TextAlign.center,
                maxLines: 3,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
