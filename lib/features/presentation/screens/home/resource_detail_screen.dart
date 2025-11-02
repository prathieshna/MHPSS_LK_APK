import 'package:beprepared/core/utils/widgets/network_image_widget.dart';
import 'package:beprepared/features/presentation/providers/resource_provider.dart'
    as rp;
import 'package:flutter/material.dart';

import '../../../../core/resources/all_imports.dart';

class ResourceDetailsScreen extends ConsumerStatefulWidget {
  final String? id;
  // final ResourceCategory? resourceCategory;
  final bool? isDownload;
  const ResourceDetailsScreen({super.key, this.id, this.isDownload = false});

  @override
  ConsumerState<ResourceDetailsScreen> createState() =>
      _ResourceDetailsScreenState();
}

class _ResourceDetailsScreenState extends ConsumerState<ResourceDetailsScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey languageSectionKey = GlobalKey();
  bool _hasScrolled = false;
  String? selectedLink;
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    print("widget.id: ${widget.id}");
  }

  void scrollToLanguageSection() {
    if (!mounted || _hasScrolled) return;

    // Expand the actions for heroes section
    final expandedSections = ref.read(rp.expandedSectionProvider);
    final newExpandedSections = Set<String>.from(expandedSections);
    newExpandedSections.add('actions_for_heroes');
    ref.read(rp.expandedSectionProvider.notifier).state = newExpandedSections;

    // Add a small delay to ensure the section is expanded
    Future.delayed(const Duration(milliseconds: 100), () {
      if (languageSectionKey.currentContext != null) {
        Scrollable.ensureVisible(
          languageSectionKey.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ).then((_) {
          setState(() {
            _hasScrolled = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.any((item) => item.id == widget.id);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.refresh(singleResourcesDataProvider(widget.id!));
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ref.watch(singleResourcesDataProvider(widget.id!)).when(
                  data: (singleResourceData) {
                    print("singleResourceData: ${singleResourceData.resource}");
                    if (singleResourceData.resource == null) {
                      return Center(child: Text("no_resources".tr()));
                    }

                    // Separate resource documents
                    final ResourceDocumentGroups documentGroups =
                        ResourceDocumentGroups.fromResource(
                            singleResourceData.resource);
                    print("documentGroups: ${documentGroups.videoDocument}");
                    // If isDownload is true, scroll to language section after build
                    if (widget.isDownload == true && !_hasScrolled) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToLanguageSection();
                      });
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                              child: NetworkImageWidget(
                                imageURL:
                                    "${singleResourceData.resource?.image?.url}",
                                boxFit: BoxFit.cover,
                                height: 180.h,
                                width: double.infinity,
                              ),
                            ),
                            Container(
                              height: 180.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () {
                                  navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  AppImages.backIconConatiner,
                                  width: 24.w,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              bottom: 12,
                              child: Row(
                                children: [
                                  ShareFavoriteWidget(
                                      onTap: () async {
                                        try {
                                          final result = await Share.share(
                                              "This was shared with you from the BePrepared App [${singleResourceData.resource?.resourceDocument?.first.link ?? ""}]");

                                          if (result.status ==
                                              ShareResultStatus.success) {
                                            print('Thank you for sharing!');
                                          }
                                        } catch (e) {
                                          Utils.displayToast(
                                              "There is no any PDf to share");
                                        }
                                      },
                                      svgImage: AppImages.shareIconSvg),
                                  const SizedBox(width: 8),
                                  ShareFavoriteWidget(
                                      onTap: () {
                                        List<String> pdfLanguages =
                                            List<String>.from(singleResourceData
                                                .resource!.resourceDocument!
                                                .where((doc) =>
                                                    doc.fileFormat == 'PDF')
                                                .expand((doc) =>
                                                    (doc.resourceTranslations)!)
                                                .map((translation) =>
                                                    translation.language!));

                                        List<String>? fileFormats = singleResourceData
                                            .resource!.resourceDocument!
                                            .map((doc) => doc.fileFormat)
                                            .where((fileFormat) =>
                                                fileFormat !=
                                                null) // Filter out null values
                                            .cast<
                                                String>() // Cast to List<String>
                                            .toList();

                                        List<String>? toolkitCategories =
                                            singleResourceData
                                                .resource!.resourceCategory!
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
                                                id: singleResourceData
                                                        .resource?.id ??
                                                    "",
                                                title: singleResourceData
                                                        .resource?.title ??
                                                    "",
                                                description: singleResourceData
                                                        .resource
                                                        ?.description ??
                                                    '',
                                                author: singleResourceData
                                                        .resource?.author ??
                                                    "",
                                                imageUrl: singleResourceData
                                                        .resource?.image?.url ??
                                                    '',
                                                fileTypeList: fileFormats,
                                                toolkitCategories:
                                                    toolkitCategories,
                                                languagesList: pdfLanguages,
                                                pdfDocument: documentGroups
                                                            .pdfDocument !=
                                                        null
                                                    ? true
                                                    : false,
                                                audioDocument: documentGroups
                                                            .audioDocument !=
                                                        null
                                                    ? true
                                                    : false,
                                                videoDocumeent: documentGroups
                                                            .videoDocument !=
                                                        null
                                                    ? true
                                                    : false,
                                              ),
                                            );
                                        // }
                                      },
                                      svgImage: isFavorite
                                          ? AppImages.favoriteSvg
                                          : AppImages.unfavoriteSvg),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              singleResourceData.resource!.title ?? "",
                              style: TextStyle(
                                fontSize: 16.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description section
                            _buildExpandableSection(
                              ref,
                              'resource_description',
                              'resource_description'.tr(),
                              Text(
                                singleResourceData.resource!.description ?? "",
                                style: TextStyle(
                                  fontSize: 11.6.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              subTitle:
                                  singleResourceData.resource!.description ??
                                      "",
                            ),
                            // PDF section
                            if (documentGroups.pdfDocument != null &&
                                singleResourceData
                                    .resource!.resourceDocument!.isNotEmpty)
                              _buildExpandableResourceSection(
                                ref,
                                'actions_for_heroes',
                                singleResourceData.resource!.title ?? "",
                                // 'actions_for_heroes'.tr(),
                                AppImages.docIcon,
                                key: languageSectionKey,
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'select_language:'.tr(),
                                      style: TextStyle(
                                        fontSize: 11.6.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: -8,
                                      children: documentGroups
                                              .pdfDocument?.resourceTranslations
                                              ?.map((lang) {
                                            // print("lang: ${lang.language}");
                                            return Chip(
                                              label: Text(lang.language ?? ""),
                                              padding: EdgeInsets.all(0),
                                              labelStyle: TextStyle(
                                                  fontSize: 11.6.sp,
                                                  fontWeight: FontWeight.w400),
                                            );
                                          }).toList() ??
                                          [],
                                    )
                                  ],
                                ),
                                onTap: documentGroups.pdfDocument!
                                        .resourceTranslations!.isNotEmpty
                                    ? () {
                                        _showPicker(
                                          context,
                                          documentGroups.pdfDocument!
                                                  .resourceTranslations ??
                                              [],
                                          'select_language'.tr(),
                                          singleResourceData.resource!,
                                        );
                                      }
                                    : () async {
                                        try {
                                          if (documentGroups.pdfDocument !=
                                              null) {
                                            final languageCheck = documentGroups
                                                .pdfDocument!.link
                                                ?.endsWith(".pdf");
                                            if (languageCheck == true) {
                                              navigator.navigateTo(
                                                  PdfReaderScreen(
                                                      pdfLink:
                                                          documentGroups
                                                                  .pdfDocument!
                                                                  .link ??
                                                              "",
                                                      language: "English",
                                                      resourceDetails:
                                                          singleResourceData
                                                              .resource!));
                                            } else {
                                              appFunctions.openWebUrl(
                                                  documentGroups
                                                          .pdfDocument!.link ??
                                                      "");
                                            }
                                          } else {
                                            Utils.displayToast(
                                                'no_pdf_documents'.tr());
                                          }
                                        } catch (e) {
                                          Utils.displayToast(
                                              'download_failed'.tr());
                                        }
                                      },
                              ),

                            // Audio Section
                            if (documentGroups.audioDocument != null)
                              _buildExpandableResourceSection(
                                ref,
                                'audio_files',
                                documentGroups.audioDocument?.title ?? "",
                                // "audio_files_title".tr(),
                                AppImages.audioIcon,
                                onTap: () async {
                                  try {
                                    if (documentGroups.audioDocument != null) {
                                      final String? audioLink =
                                          documentGroups.audioDocument!.link;

                                      if (audioLink != null) {
                                        await appFunctions
                                            .openWebUrl(audioLink);
                                      } else {
                                        Utils.displayToast(
                                            'no_valid_audio_link'.tr());
                                      }
                                    } else {
                                      Utils.displayToast(
                                          'no_audio_resources'.tr());
                                    }
                                  } catch (e) {
                                    print('An error occurred: ${e.toString()}');
                                  }
                                },
                              ),

                            // Video Section
                            if (documentGroups.videoDocument != null)
                              _buildExpandableResourceSection(
                                ref,
                                'animated_film',
                                documentGroups.videoDocument?.title ?? "",
                                // 'short_animated_film'.tr(),
                                AppImages.vedioIcon,
                                onTap: () async {
                                  try {
                                    if (documentGroups.videoDocument != null) {
                                      final String videoLink =
                                          documentGroups.videoDocument!.link ??
                                              '';

                                      if (videoLink.isNotEmpty) {
                                        await appFunctions
                                            .openWebUrl(videoLink);
                                      } else {
                                        Utils.displayToast(
                                            'no_valid_video_link'.tr());
                                      }
                                    } else {
                                      Utils.displayToast(
                                          'no_video_resources'.tr());
                                    }
                                  } catch (e) {
                                    print(
                                        'An error occurred while retrieving the video link: ${e.toString()}');
                                  }
                                },
                              ),

                            const SizedBox(height: 16),

                            if (singleResourceData.resource!.tags!.isNotEmpty &&
                                singleResourceData.resource!.tags != null)
                              Wrap(
                                spacing: 4,
                                children: [
                                  for (final tag
                                      in singleResourceData.resource!.tags!)
                                    if (tag != null && tag != "")
                                      _buildChip(tag),
                                ],
                              ),
                            Divider(),
                            const SizedBox(height: 16),
                            Text(
                              "suggested_resources".tr(),
                              style: TextStyle(
                                fontSize: 16.5.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),

                            ref
                                .watch(resourcesByCategoryProvider(
                                    singleResourceData
                                                .resource
                                                ?.toolkitCategories
                                                ?.isNotEmpty ==
                                            true
                                        ? singleResourceData.resource!
                                            .toolkitCategories!.first.id!
                                        : "cm3h4wrjda6bx07umxxkkldc6"))
                                .when(
                                  data: (resources) {
                                    if (resources.data.toolkit.toolkitCategories
                                        .isEmpty) {
                                      return Center(
                                          child: Text('no_results'.tr()));
                                    }
                                    // Filter out the resource with the specified ID
                                    final filteredResources = resources
                                        .data
                                        .toolkit
                                        .toolkitCategories
                                        .first
                                        .resources
                                        .where((item) => item.id != widget.id)
                                        .toList();
                                    return ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredResources.length,
                                      separatorBuilder: (context, index) =>
                                          SizedBox(height: 8.h),
                                      itemBuilder: (context, index) {
                                        final resourceData =
                                            filteredResources[index];

                                        final favorites =
                                            ref.watch(favoritesProvider);
                                        final isFavorite = favorites.any(
                                            (item) =>
                                                item.id == resourceData.id);
                                        final isPdfDoc = resourceData
                                                .resourceDocument
                                                .any((doc) =>
                                                    doc.fileFormat
                                                        ?.toLowerCase() ==
                                                    'pdf') ??
                                            false;
                                        final isAudioDoc = resourceData
                                                .resourceDocument
                                                .any((doc) =>
                                                    doc.fileFormat
                                                        ?.toLowerCase() ==
                                                    'audio') ??
                                            false;
                                        final isVideoDoc = resourceData
                                                .resourceDocument
                                                .any((doc) =>
                                                    doc.fileFormat
                                                        ?.toLowerCase() ==
                                                    'video') ??
                                            false;

                                        return ResourceCard(
                                            title: resourceData.title ?? "",
                                            description: resourceData
                                                    .descriptionDeprecated ??
                                                "",
                                            author:
                                                resourceData.author ?? 'N/A',
                                            imageUrl:
                                                resourceData.image.url ?? "",
                                            isFavourite: isFavorite,
                                            pdfDocument: isPdfDoc,
                                            audioDocument: isAudioDoc,
                                            videoDocument: isVideoDoc,
                                            publishedDate: DateTime.parse(
                                                    resourceData.createdAt ??
                                                        "")
                                                .year
                                                .toString(),
                                            favouriteTap: () {
                                              // Get PDF languages
                                              List<String> pdfLanguages =
                                                  resourceData.resourceDocument
                                                      .where(
                                                          (doc) =>
                                                              doc.fileFormat ==
                                                              'PDF')
                                                      .expand((doc) => doc
                                                          .resourceTranslations
                                                          .map((translation) =>
                                                              translation
                                                                  .language ??
                                                              'Unknown')
                                                          .where((language) =>
                                                              language
                                                                  .isNotEmpty))
                                                      .toList();

                                              // Get all file formats
                                              List<String> fileFormats =
                                                  resourceData.resourceDocument
                                                      .map((doc) =>
                                                          doc.fileFormat)
                                                      .whereType<
                                                          String>() // This filters out null values and casts to String
                                                      .toList();

                                              // Get toolkit categories
                                              // List<String> toolkitCategories = resourceData.toolkitCategories
                                              //     .map((category) => category.title ?? 'Unknown')
                                              //     .where((title) => title.isNotEmpty)
                                              //     .toList();

                                              print(
                                                  'Languages for PDF file format: $pdfLanguages');
                                              print(
                                                  "fileFormats: $fileFormats");
                                              // print("toolkitCategories: $toolkitCategories");

                                              ref
                                                  .read(favoritesProvider
                                                      .notifier)
                                                  .toggleFavorite(
                                                    ResourceModel(
                                                      id: resourceData.id ?? "",
                                                      title:
                                                          resourceData.title ??
                                                              "N/A",
                                                      description: resourceData
                                                              .descriptionDeprecated ??
                                                          "",
                                                      author:
                                                          resourceData.author ??
                                                              "N/A",
                                                      imageUrl: resourceData
                                                              .image.url ??
                                                          '',
                                                      fileTypeList: fileFormats,
                                                      // toolkitCategories: toolkitCategories,
                                                      languagesList:
                                                          pdfLanguages,
                                                      pdfDocument: isPdfDoc,
                                                      audioDocument: isAudioDoc,
                                                      videoDocumeent:
                                                          isVideoDoc,
                                                    ),
                                                  );
                                            },
                                            downloadTap: () {
                                              print("Download tapped");
                                              navigator
                                                  .navigateToWithBottomNavBar(
                                                      context,
                                                      ResourceDetailsScreen(
                                                        id: resourceData.id,
                                                        isDownload: true,
                                                      ));
                                            },
                                            onTap: () {
                                              ref.invalidate(
                                                  expandedSectionProvider);
                                              navigator
                                                  .navigateToWithBottomNavBar(
                                                      context,
                                                      ResourceDetailsScreen(
                                                        id: resourceData.id,
                                                      ));
                                            });
                                      },
                                    );
                                  },
                                  loading: () => const Center(
                                      child: CircularProgressIndicator()),
                                  error: (error, stack) => Center(
                                      child: Text(
                                          textAlign: TextAlign.center,
                                          'unknown_error'.tr())),
                                ),
                          ],
                        )
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                      child: Text(
                          textAlign: TextAlign.center, 'unknown_error'.tr())),
                ),
          ),
        ),
      ),
    );
  }

  void _showPicker(
    BuildContext context,
    List<ResourceTranslation> items,
    String title,
    SingleResourceDetails resourceDetails,
  ) {
    print(
        "items: ${items.length}, $title, ${resourceDetails.resourceDocument}");
    // Set the first item as default if available
    if (items.isNotEmpty) {
      selectedLink = items.first.link;
      selectedLanguage = items.first.language;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => PickerWidget<ResourceTranslation>(
        title: title,
        items: items,
        itemToString: (item) => item.language ?? "",
        onItemSelected: (selectedItem) {
          setState(() {
            selectedLink = selectedItem.link;
            selectedLanguage = selectedItem.language;
          });
        },
        onConfirm: () async {
          navigator.pop(context);
          await Future.delayed(Duration(milliseconds: 100));
          print("selectedLanguage: $selectedLink");
          final languageCheck = selectedLink?.endsWith(".pdf");

          if (selectedLink != null && languageCheck == true) {
            navigator.navigateTo(PdfReaderScreen(
              pdfLink: selectedLink ?? "",
              language: selectedLanguage ?? "",
              resourceDetails: resourceDetails,
            ));
          } else {
            appFunctions.openWebUrl(selectedLink ?? "");
          }
        },
      ),
    );
  }

  Widget _buildExpandableSection(
    WidgetRef ref,
    String id,
    String title,
    Widget content, {
    String? subTitle,
    bool isDescription = false,
  }) {
    final expandedSections = ref.watch(rp.expandedSectionProvider);
    final isExpanded = isDescription || expandedSections.contains(id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: !isExpanded
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      subTitle ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.6.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                : null,
            trailing: isDescription
                ? null
                : Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: isDescription
                ? null
                : () {
                    final newExpandedSections =
                        Set<String>.from(expandedSections);
                    if (isExpanded) {
                      newExpandedSections.remove(id);
                    } else {
                      newExpandedSections.add(id);
                    }
                    ref.read(rp.expandedSectionProvider.notifier).state =
                        newExpandedSections;
                  },
          ),
          if (isExpanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: content,
            ),
        ],
      ),
    );
  }

  Widget _buildExpandableResourceSection(
    WidgetRef ref,
    String id,
    String title,
    String iconData, {
    Widget? content,
    Function()? onTap,
    Key? key,
  }) {
    final expandedSections = ref.watch(rp.expandedSectionProvider);
    final isExpanded = expandedSections.contains(id);

    return Card(
      key: key, // Add the optional key
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: SvgPicture.asset(iconData, height: 20.h),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: onTap ??
                () {
                  final newExpandedSections =
                      Set<String>.from(expandedSections);
                  if (isExpanded) {
                    newExpandedSections.remove(id);
                  } else {
                    newExpandedSections.add(id);
                  }
                  ref.read(rp.expandedSectionProvider.notifier).state =
                      newExpandedSections;
                },
          ),
          if (isExpanded)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: GestureDetector(onTap: onTap ?? () {}, child: content),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        // showModalBottomSheet(
        //   isScrollControlled: true,
        //   isDismissible: false,
        //   context: context,
        //   builder: (context) {
        //     return AdvanceFilterView();
        //   },
        // );
      },
      child: Chip(
        labelPadding:
            const EdgeInsets.symmetric(horizontal: 4.0, vertical: 0.0),
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        side: const BorderSide(
          color: AppColors.tagColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        backgroundColor: AppColors.appWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20.0), // Adjust the radius as needed
        ),
        label: Text(
          label,
          style: TextStyle(fontSize: 10.sp),
        ),
      ),
    );
  }
}
