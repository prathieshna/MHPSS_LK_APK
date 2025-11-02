import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class AllResourcesScreen extends ConsumerStatefulWidget {
  final String? id;
  final bool isPopularTopics;
  const AllResourcesScreen({super.key, this.id, this.isPopularTopics = false});

  @override
  ConsumerState<AllResourcesScreen> createState() => _AllResourcesScreenState();
}

class _AllResourcesScreenState extends ConsumerState<AllResourcesScreen> {
  @override
  Widget build(BuildContext context) {
    print("widget.id: ${widget.id}");
    return Scaffold(
      appBar: const CustomAppBar(isBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Watching the provider
            Expanded(
              child: widget.isPopularTopics
                  ? ref
                      .watch(resourcesByCategoryProvider(widget.id ?? ''))
                      .when(
                        data: (resources) {
                          print(" all category resources: $resources");
                          if (resources
                              .data.toolkit.toolkitCategories.isEmpty) {
                            print(" all category resources: 33 $resources");

                            return Center(
                              child: Text(
                                'no_resources'.tr(),
                              ),
                            );
                          }
                          return ListView.separated(
                            itemCount: resources.data.toolkit.toolkitCategories
                                .first.resources.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final resourceData = resources.data.toolkit
                                  .toolkitCategories.first.resources[index];
                              final favorites = ref.watch(favoritesProvider);
                              final isFavorite = favorites
                                  .any((item) => item.id == resourceData.id);
                              final isPdfDoc = resourceData.resourceDocument
                                      .any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'pdf') ??
                                  false;
                              final isAudioDoc = resourceData.resourceDocument
                                      .any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'audio') ??
                                  false;
                              final isVideoDoc = resourceData.resourceDocument
                                      .any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'video') ??
                                  false;
                              return ResourceCard(
                                  title: resourceData.title ?? '',
                                  description:
                                      resourceData.descriptionDeprecated ?? '',
                                  author: resourceData.author ?? 'N/A',
                                  pdfDocument: isPdfDoc,
                                  audioDocument: isAudioDoc,
                                  videoDocument: isVideoDoc,
                                  publishedDate: DateTime.parse(
                                          resourceData.createdAt ?? "")
                                      .year
                                      .toString(),
                                  imageUrl: resourceData.image.url ?? '',
                                  hasVideo: false,
                                  isFavourite: isFavorite,
                                  favouriteTap: () {
                                    // Get PDF languages
                                    List<String> pdfLanguages = resourceData
                                        .resourceDocument
                                        .where((doc) => doc.fileFormat == 'PDF')
                                        .expand((doc) => doc
                                            .resourceTranslations
                                            .map((translation) =>
                                                translation.language ??
                                                'Unknown')
                                            .where((language) =>
                                                language.isNotEmpty))
                                        .toList();

                                    // Get all file formats
                                    List<String> fileFormats = resourceData
                                        .resourceDocument
                                        .map((doc) => doc.fileFormat)
                                        .whereType<
                                            String>() // This filters out null values and casts to String
                                        .toList();

                                    // Get toolkit categories
                                    // List<String> toolkitCategories =
                                    //     resourceData
                                    //         .map((category) =>
                                    //             category.title ?? 'Unknown')
                                    //         .where((title) => title.isNotEmpty)
                                    //         .toList();

                                    print(
                                        'Languages for PDF file format: $pdfLanguages');
                                    print("fileFormats: $fileFormats");
                                    // print(
                                    //     "toolkitCategories: $toolkitCategories");

                                    ref
                                        .read(favoritesProvider.notifier)
                                        .toggleFavorite(
                                          ResourceModel(
                                            id: resourceData.id ?? "",
                                            title: resourceData.title ?? "N/A",
                                            description: resourceData
                                                    .descriptionDeprecated ??
                                                "",
                                            author:
                                                resourceData.author ?? "N/A",
                                            imageUrl:
                                                resourceData.image.url ?? '',
                                            fileTypeList: fileFormats,
                                            // toolkitCategories:
                                            //     toolkitCategories,
                                            languagesList: pdfLanguages,
                                            pdfDocument: isPdfDoc,
                                            audioDocument: isAudioDoc,
                                            videoDocumeent: isVideoDoc,
                                          ),
                                        );
                                  },
                                  downloadTap: () {
                                    print("Download tapped");
                                    navigator.navigateToWithBottomNavBar(
                                        context,
                                        ResourceDetailsScreen(
                                          id: resourceData.id,
                                          isDownload: true,
                                        ));
                                  },
                                  onTap: () {
                                    navigator.navigateToWithBottomNavBar(
                                        context,
                                        ResourceDetailsScreen(
                                          id: resourceData.id,
                                        ));
                                  });
                            },
                          );
                        },
                        loading: () => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        error: (error, stack) => Center(
                          child: Text(
                              textAlign: TextAlign.center,
                              'unknown_error'.tr()),
                        ),
                      )
                  : ref.watch(popularResourcesProvider).when(
                        data: (resources) {
                          if (resources.data == null ||
                              resources.data!.toolkit == null ||
                              resources.data!.toolkit!.resources!.isEmpty) {
                            return Center(child: Text('no_resources'.tr()));
                          }

                          // final resourceListData = resources
                          //     .data!.toolkit!.resources!
                          //     .where((resource) => resource.popular == true);
                          return ListView.separated(
                            itemCount:
                                resources.data!.toolkit!.resources!.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 8.h),
                            itemBuilder: (context, index) {
                              final resourceData =
                                  resources.data!.toolkit!.resources![index];

                              final favorites = ref.watch(favoritesProvider);
                              final isFavorite = favorites
                                  .any((item) => item.id == resourceData.id);
                              final isPdfDoc = resourceData.resourceDocument
                                      ?.any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'pdf') ??
                                  false;
                              final isAudioDoc = resourceData.resourceDocument
                                      ?.any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'audio') ??
                                  false;
                              final isVideoDoc = resourceData.resourceDocument
                                      ?.any((doc) =>
                                          doc.fileFormat?.toLowerCase() ==
                                          'video') ??
                                  false;

                              return ResourceCard(
                                  title: resourceData.title ?? "",
                                  description:
                                      resourceData.descriptionDeprecated ?? "",
                                  author: resourceData.author ?? 'N/A',
                                  imageUrl: resourceData.image?.url ?? "",
                                  isFavourite: isFavorite,
                                  pdfDocument: isPdfDoc,
                                  audioDocument: isAudioDoc,
                                  videoDocument: isVideoDoc,
                                  publishedDate: DateTime.parse(
                                          resourceData.createdAt ?? "")
                                      .year
                                      .toString(),
                                  favouriteTap: () {
                                    List<String> pdfLanguages = resourceData
                                        .resourceDocument!
                                        .where((doc) => doc.fileFormat == 'PDF')
                                        .expand((doc) =>
                                            (doc.resourceTranslations)!.map(
                                                (translation) =>
                                                    translation.language!))
                                        .toList();

                                    List<String>? fileFormats = resourceData
                                        .resourceDocument!
                                        .map((doc) => doc.fileFormat)
                                        .where((fileFormat) =>
                                            fileFormat !=
                                            null) // Filter out null values
                                        .cast<String>() // Cast to List<String>
                                        .toList();

                                    List<String>? toolkitCategories =
                                        resourceData.toolkitCategories!
                                            .map((doc) => doc.title)
                                            .where((categoryTitle) =>
                                                categoryTitle !=
                                                null) // Filter out null values
                                            .cast<
                                                String>() // Cast to List<String>
                                            .toList();
                                    print(
                                        'Languages for PDF file format: $pdfLanguages');
                                    print("fileFormats: $fileFormats");
                                    print(
                                        "toolkitCategories: $toolkitCategories");
                                    ref
                                        .read(favoritesProvider.notifier)
                                        .toggleFavorite(
                                          ResourceModel(
                                            id: resourceData.id ?? "",
                                            title: resourceData.title ?? "N/A",
                                            description: resourceData
                                                    .descriptionDeprecated ??
                                                "",
                                            author:
                                                resourceData.author ?? "N/A",
                                            imageUrl:
                                                resourceData.image?.url ?? '',
                                            languagesList: pdfLanguages,
                                            fileTypeList: fileFormats,
                                            toolkitCategories:
                                                toolkitCategories,
                                            pdfDocument: isPdfDoc,
                                            audioDocument: isAudioDoc,
                                            videoDocumeent: isVideoDoc,
                                          ),
                                        );
                                  },
                                  downloadTap: () {
                                    print("Download tapped");
                                    navigator.navigateToWithBottomNavBar(
                                        context,
                                        ResourceDetailsScreen(
                                          id: resourceData.id!,
                                          isDownload: true,
                                        ));
                                  },
                                  onTap: () {
                                    navigator.navigateToWithBottomNavBar(
                                        context,
                                        ResourceDetailsScreen(
                                          id: resourceData
                                              .id!, // "cm4b9slfqqc1z07tdnombv8xm", //resourceData.id!,
                                        ));
                                  });
                            },
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Center(
                            child: Text(
                                textAlign: TextAlign.center,
                                'unknown_error'.tr())),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
