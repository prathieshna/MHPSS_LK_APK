import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/network_image_widget.dart';
import 'package:flutter/material.dart';

class ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final String author;
  final String publishedDate;
  final String imageUrl;
  final List<String> tags;
  final List<Map<String, String>> languages;
  final bool hasVideo;
  final bool isFavourite;
  final bool isDownloadedScreen;
  final Function()? onTap;
  final Function()? docTap;
  final Function()? volumeTap;
  final Function()? videoTap;
  final Function()? deleteTap;
  final Function()? downloadTap;
  final Function()? favouriteTap;
  final Function(String link, String filePath)? onLanguageTap;
  final bool? pdfDocument;
  final bool? audioDocument;
  final bool? videoDocument;

  const ResourceCard({
    super.key,
    required this.title,
    required this.description,
    required this.author,
    required this.publishedDate,
    required this.imageUrl,
    this.tags = const [],
    this.languages = const [],
    this.hasVideo = false,
    this.isFavourite = false,
    this.isDownloadedScreen = false,
    this.onTap,
    this.docTap,
    this.volumeTap,
    this.videoTap,
    this.deleteTap,
    this.downloadTap,
    this.favouriteTap,
    this.onLanguageTap,
    required this.pdfDocument,
    required this.audioDocument,
    required this.videoDocument,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0.0),
      color: AppColors.appBarBottomColor,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with image and media icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Image for circular corner use ClipRRect
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child:
                          //  imageUrl.startsWith("http")
                          //     ?
                          NetworkImageWidget(
                        imageURL: imageUrl,
                        width: 135.w,
                        height: 200.h,
                        boxFit: BoxFit.cover,
                      )
                      // : Image.asset(imageUrl,
                      //     width: 135.w, height: 200.h, fit: BoxFit.fill),
                      ),
                  SizedBox(width: 10.w),
                  // Right side - Icons and content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Media type icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                if (pdfDocument == true)
                                  GestureDetector(
                                      onTap: docTap,
                                      child:
                                          SvgPicture.asset(AppImages.docSvg)),
                                SizedBox(width: 8.w),
                                // if (isDownloadedScreen == false)
                                if (audioDocument == true)
                                  GestureDetector(
                                      onTap: () {},
                                      child: SvgPicture.asset(
                                          AppImages.volumeSvg)),
                                SizedBox(width: 8.w),
                                // if (hasVideo && isDownloadedScreen == false)
                                if (videoDocument == true)
                                  GestureDetector(
                                      onTap: videoTap,
                                      child:
                                          SvgPicture.asset(AppImages.videoSvg)),
                              ],
                            ),
                            if (isDownloadedScreen)
                              GestureDetector(
                                  onTap: deleteTap,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade600,
                                  )),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        // Tags
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: tags
                              .map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 2.0),
                                    decoration: BoxDecoration(
                                      color: AppColors.tagColor,
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Text(
                                      tag,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // Author and date
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'author'.tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp),
                                      ),
                                      Expanded(
                                        child: Text(
                                          author,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "published".tr(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp),
                                      ),
                                      Text(
                                        publishedDate,
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (isDownloadedScreen == false)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: downloadTap,
                                      child: SvgPicture.asset(
                                        AppImages.downloadSvg,
                                      )),
                                  SizedBox(width: 10.w),
                                  GestureDetector(
                                      onTap: favouriteTap,
                                      child: SvgPicture.asset(isFavourite
                                          ? AppImages.favoriteSvg
                                          : AppImages.unfavoriteSvg)),
                                  SizedBox(width: 10.w),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if (isDownloadedScreen)
                Column(
                  children: [
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8,
                      children: languages
                          .map((lang) => GestureDetector(
                                onTap: () {
                                  if (onLanguageTap != null) {
                                    onLanguageTap!(
                                        lang['link']!, lang['filePath']!);
                                  }
                                },
                                child: Chip(
                                  label: Text(
                                    lang['language']!,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  padding: const EdgeInsets.all(4),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
