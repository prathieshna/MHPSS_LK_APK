// import 'package:beprepared/core/resources/all_imports.dart';
// import 'package:flutter/material.dart';

// class SelfCareScreen extends ConsumerStatefulWidget {
//   const SelfCareScreen({super.key});

//   @override
//   ConsumerState<SelfCareScreen> createState() => _SelfCareScreenState();
// }

// class _SelfCareScreenState extends ConsumerState<SelfCareScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           ref.refresh(toolkitSubCategoryProvider);
//           ref.refresh(resourcesByCategoryProvider("cm4i632gzx8vh07uob77cxy3w"));
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 16),
//               const VideoBanner(
//                 videoUrl: "https://www.youtube.com/watch?v=BU0HuZLGSuU",
//               ),
//               const SizedBox(height: 16),
//               TitleWidget(
//                 topic: "your_selfcare".tr(),
//                 forwardText: "see_all_selfcares".tr(),
//                 onPressed: () {
//                   navigator.navigateToWithBottomNavBar(
//                       context, const AllTopicsScreen(isSelfcare: true));
//                 },
//               ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 height: 100.h,
//                 child: ref.watch(toolkitSubCategoryProvider).when(
//                       data: (toolkitCategory) {
//                         if (toolkitCategory.data!.toolkit == null ||
//                             toolkitCategory
//                                 .data!.toolkit!.toolkitCategories!.isEmpty) {
//                           return Center(child: Text('no_category'.tr()));
//                         }

//                         final toolkit =
//                             toolkitCategory.data!.toolkit!.toolkitCategories;
//                         return ListView.separated(
//                           separatorBuilder: (context, index) =>
//                               SizedBox(width: 6.w),
//                           scrollDirection: Axis.horizontal,
//                           itemCount:
//                               toolkit!.first!.toolkitSubCategories!.length,
//                           itemBuilder: (context, index) {
//                             final toolkitCategoryData =
//                                 toolkit.first!.toolkitSubCategories?[index];

//                             return PopularTopicsCard(
//                               toolkitCategory: toolkitCategoryData!,
//                               onTap: () {
//                                 navigator.navigateToWithBottomNavBar(
//                                     context,
//                                     AllResourcesScreen(
//                                         isPopularTopics: true,
//                                         id: toolkitCategoryData.id));
//                               },
//                             );
//                           },
//                         );
//                       },
//                       loading: () =>
//                           const Center(child: CircularProgressIndicator()),
//                       error: (error, stack) => Center(
//                           child: Text(
//                               textAlign: TextAlign.center,
//                               'unknown_error'.tr())),
//                     ),
//               ),
//               const SizedBox(height: 16),
//               TitleWidget(
//                 topic: "self_care_resources".tr(),
//                 forwardText: "see_all".tr(),
//                 onPressed: () {
//                   navigator.navigateToWithBottomNavBar(
//                       context,
//                       const AllResourcesScreen(
//                         id: "cm4i632gzx8vh07uob77cxy3w",
//                         isPopularTopics: true,
//                       ));
//                 },
//               ),
//               const SizedBox(height: 16),
//               ref
//                   .watch(
//                       resourcesByCategoryProvider("cm4i632gzx8vh07uob77cxy3w"))
//                   .when(
//                     data: (resources) {
//                       if (resources.toolkitCategory == null ||
//                           resources.toolkitCategory!.resource == null) {
//                         return Center(
//                           child: Text('no_resources'.tr()),
//                         );
//                       }
//                       return ListView.separated(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: resources.toolkitCategory!.resource!.length,
//                         separatorBuilder: (context, index) =>
//                             SizedBox(height: 8.h),
//                         itemBuilder: (context, index) {
//                           final resourceData =
//                               resources.toolkitCategory!.resource![index];

//                           final favorites = ref.watch(favoritesProvider);
//                           final isFavorite = favorites
//                               .any((item) => item.id == resourceData.id);

//                           return ResourceCard(
//                               title: resourceData.title ?? "",
//                               description: resourceData.description ?? "",
//                               author: resourceData.author ?? 'N/A',
//                               imageUrl: resourceData.imageUrl ?? "",
//                               isFavourite: isFavorite,
//                               // pdfDocument: ,
//                               // audioDocument: ,
//                               // videoDocument: ,
//                               publishedDate:
//                                   DateTime.parse(resourceData.publishedAt ?? "")
//                                       .year
//                                       .toString(),
//                               favouriteTap: () {
//                                 List<String> pdfLanguages = resourceData
//                                     .resourceDocuments!
//                                     .where((doc) => doc.fileFormat == 'PDF')
//                                     .expand((doc) => (doc.translations)!.map(
//                                         (translation) => translation.language!))
//                                     .toList();

//                                 List<String>? fileFormats = resourceData
//                                     .resourceDocuments!
//                                     .map((doc) => doc.fileFormat)
//                                     .where((fileFormat) =>
//                                         fileFormat !=
//                                         null) // Filter out null values
//                                     .cast<String>() // Cast to List<String>
//                                     .toList();

//                                 List<String>? toolkitCategories = resourceData
//                                     .toolkitCategories!
//                                     .map((doc) => doc.title)
//                                     .where((categoryTitle) =>
//                                         categoryTitle !=
//                                         null) // Filter out null values
//                                     .cast<String>() // Cast to List<String>
//                                     .toList();
//                                 print(
//                                     'Languages for PDF file format: $pdfLanguages');
//                                 print("fileFormats: $fileFormats");
//                                 print("toolkitCategories: $toolkitCategories");
//                                 ref
//                                     .read(favoritesProvider.notifier)
//                                     .toggleFavorite(
//                                       ResourceModel(
//                                         id: resourceData.id ?? "",
//                                         title: resourceData.title ?? "N/A",
//                                         description:
//                                             resourceData.description ?? "",
//                                         author: resourceData.author ?? "N/A",
//                                         imageUrl: resourceData.imageUrl ?? '',
//                                         languagesList: pdfLanguages,
//                                         fileTypeList: fileFormats,
//                                         toolkitCategories: toolkitCategories,
//                                       ),
//                                     );
//                               },
//                               downloadTap: () {
//                                 print("Download tapped");
//                                 navigator.navigateToWithBottomNavBar(
//                                     context,
//                                     ResourceDetailsScreen(
//                                       id: resourceData.id!,
//                                       isDownload: true,
//                                     ));
//                               },
//                               onTap: () {
//                                 navigator.navigateToWithBottomNavBar(
//                                     context,
//                                     ResourceDetailsScreen(
//                                       id: resourceData
//                                           .id!, // "cm4b9slfqqc1z07tdnombv8xm", //resourceData.id!,
//                                     ));
//                               });
//                         },
//                       );
//                     },
//                     loading: () =>
//                         const Center(child: CircularProgressIndicator()),
//                     error: (error, stack) => Center(
//                         child: Text(
//                             textAlign: TextAlign.center, 'unknown_error'.tr())),
//                   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
