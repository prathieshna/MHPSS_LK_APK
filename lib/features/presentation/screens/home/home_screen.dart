import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/presentation/providers/debouncing_provider.dart';
import 'package:flutter/material.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final debounce = ref.watch(debounceProvider);
    return Scaffold(
      appBar: CustomAppBar(onSearch: (value) {
        debounce(() {
          if (value.isNotEmpty) {
            print("value: $value");
            // ref.read(searchResourcesProvider(value));
          }
        });
      }),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(toolkitCategoryProvider);
          ref.refresh(popularResourcesProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // TODO: Commented out GraphQL video fetching - can be restored later
              // ref.watch(homePageVideoProvider).when(
              //     data: (videoData) {
              //       print(
              //           "videoData home screen: ${videoData.data.videos.first.videoUrl}");
              //       return VideoBanner(
              //         videoUrl: videoData.data.videos.first.videoUrl,
              //
              //       );
              //     },
              //     error: (error, stack) => Center(
              //         child: Text(
              //             textAlign: TextAlign.center, 'unknown_error'.tr())),
              //     loading: () =>
              //         const Center(child: CircularProgressIndicator())),

              // Hardcoded video URLs based on language (temporary replacement)
              Builder(
                builder: (context) {
                  String getVideoUrlByLanguage() {
                    final languageCode = context.locale.languageCode;
                    switch (languageCode) {
                      case 'si':
                        return 'https://www.youtube.com/watch?v=BnY1P4jWpY8'; // Sinhala
                      case 'ta':
                        return 'https://www.youtube.com/watch?v=9riFn0rgDxk'; // Tamil
                      case 'en':
                      default:
                        return 'https://www.youtube.com/watch?v=YLBDMKCzxu8'; // English (default)
                    }
                  }

                  return VideoBanner(
                    videoUrl: getVideoUrlByLanguage(),
                  );
                },
              ),
              const SizedBox(height: 16),
              TitleWidget(
                topic: "popular_topics".tr(),
                forwardText: "see_all_topics".tr(),
                onPressed: () {
                  navigator.navigateToWithBottomNavBar(
                      context, const AllTopicsScreen());
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 100.h,
                child: ref.watch(toolkitCategoryProvider).when(
                      data: (toolkitCategory) {
                        if (toolkitCategory.toolkit == null ||
                            toolkitCategory
                                .toolkit!.toolkitAllCategories!.isEmpty) {
                          return Center(child: Text("no_category".tr()));
                        }

                        final toolkit =
                            toolkitCategory.toolkit!.toolkitAllCategories!;
                        return ListView.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 6.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: toolkit.length,
                          itemBuilder: (context, index) {
                            final toolkitCategoryData = toolkit[index];
                            return PopularTopicsCard(
                              toolkitCategory: toolkitCategoryData,
                              onTap: () {
                                navigator.navigateToWithBottomNavBar(
                                    context,
                                    AllResourcesScreen(
                                      id: toolkitCategoryData.id,
                                      isPopularTopics: true,
                                    ));
                              },
                            );
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
              const SizedBox(height: 16),
              TitleWidget(
                topic: "top_resources".tr(),
                forwardText: "see_all".tr(),
                onPressed: () {
                  navigator.navigateToWithBottomNavBar(
                      context, const AllResourcesScreen());
                },
              ),
              const SizedBox(height: 16),
              ref.watch(popularResourcesProvider).when(
                    data: (resources) {
                      if (resources.data == null ||
                          resources.data!.toolkit == null ||
                          resources.data!.toolkit!.resources!.isEmpty) {
                        return Center(child: Text('no_resources'.tr()));
                      }

                      final resourceListData = resources
                          .data!.toolkit!.resources!
                          .where((resource) => resource.popular == true);
                      if (resourceListData.isEmpty) {
                        return Center(child: Text('no_resources'.tr()));
                      }

                      print("resourceListData: $resourceListData");
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: resourceListData.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          final resourceData =
                              resourceListData.elementAt(index);

                          final favorites = ref.watch(favoritesProvider);
                          final isFavorite = favorites
                              .any((item) => item.id == resourceData.id);
                          final isPdfDoc = resourceData.resourceDocument?.any(
                                  (doc) =>
                                      doc.fileFormat?.toLowerCase() == 'pdf') ??
                              false;
                          final isAudioDoc = resourceData.resourceDocument?.any(
                                  (doc) =>
                                      doc.fileFormat?.toLowerCase() ==
                                      'audio') ??
                              false;
                          final isVideoDoc = resourceData.resourceDocument?.any(
                                  (doc) =>
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
                              publishedDate:
                                  DateTime.parse(resourceData.createdAt ?? "")
                                      .year
                                      .toString(),
                              favouriteTap: () {
                                List<String> pdfLanguages = resourceData
                                    .resourceDocument!
                                    .where((doc) => doc.fileFormat == 'PDF')
                                    .expand((doc) => (doc.resourceTranslations)!
                                        .map((translation) =>
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

                                List<String>? toolkitCategories = resourceData
                                    .toolkitCategories!
                                    .map((doc) => doc.title)
                                    .where((categoryTitle) =>
                                        categoryTitle !=
                                        null) // Filter out null values
                                    .cast<String>() // Cast to List<String>
                                    .toList();
                                print(
                                    'Languages for PDF file format: $pdfLanguages');
                                print("fileFormats: $fileFormats");
                                print("toolkitCategories: $toolkitCategories");
                                ref
                                    .read(favoritesProvider.notifier)
                                    .toggleFavorite(
                                      ResourceModel(
                                        id: resourceData.id ?? "",
                                        title: resourceData.title ?? "N/A",
                                        description: resourceData
                                                .descriptionDeprecated ??
                                            "",
                                        author: resourceData.author ?? "N/A",
                                        imageUrl: resourceData.image?.url ?? '',
                                        languagesList: pdfLanguages,
                                        fileTypeList: fileFormats,
                                        toolkitCategories: toolkitCategories,
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
                                      id: resourceData
                                          .id, // "cm4b9slfqqc1z07tdnombv8xm",
                                    ));
                              });
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                        child: Text(
                            textAlign: TextAlign.center, 'unknown_error'.tr())),
                  ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
