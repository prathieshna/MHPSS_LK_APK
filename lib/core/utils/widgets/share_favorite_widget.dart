import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class ShareFavoriteWidget extends StatelessWidget {
  final Function()? onTap;
  final String svgImage;
  const ShareFavoriteWidget({super.key, required this.svgImage, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: 32.w,
        height: 32.h,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: SvgPicture.asset(
          svgImage,
        ),
      ),
    );
  }
}
