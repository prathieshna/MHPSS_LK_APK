// Separate the filter view into its own widget
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class AdvanceFilterView extends ConsumerWidget {
  final TextEditingController textEditingController = TextEditingController();

  AdvanceFilterView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the providers to rebuild when state changes
    final selectedResourceTypes = ref.watch(resourceTypeProvider);
    final selectedDisasterStages = ref.watch(disasterStageProvider);
    final selectedLanguages = ref.watch(languageProvider);

    // Get unique authors from the notifier
    final uniqueAuthors =
        ref.watch(favoritesProvider.notifier).getUniqueAuthors();

    return Container(
      height: 520.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 0),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'filters'.tr(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ref.read(selectedAuthorProvider.notifier).state = null;
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'resource_types'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                children: [
                  for (final type in [
                    'text'.tr(),
                    'video'.tr(),
                    'audio'.tr(),
                    'other'.tr()
                  ])
                    _SelectableChip(
                      label: type,
                      isSelected: selectedResourceTypes.contains(type),
                      onTap: () => ref
                          .read(resourceTypeProvider.notifier)
                          .toggleSelection(type),
                    ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                "toolkit_categories".tr(), //'Disaster Stage',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              ref.watch(toolkitCategoryProvider).when(
                    data: (toolkitCategory) {
                      final toolkit =
                          toolkitCategory.toolkit!.toolkitAllCategories!;
                      return Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (final type in toolkit)
                            _SelectableChip(
                              label: type.title,
                              isSelected:
                                  selectedResourceTypes.contains(type.title),
                              onTap: () => ref
                                  .read(resourceTypeProvider.notifier)
                                  .toggleSelection(type.title),
                            ),
                        ],
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                        child: Text(
                            textAlign: TextAlign.center, 'unknown_error'.tr())),
                  ),
              const SizedBox(height: 16.0),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.appWhiteColor,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 0),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'languages_of_resource'.tr(),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: [
                          for (final language in [
                            'English',
                            'Spanish',
                            'French',
                            'German'
                          ])
                            _SelectableChip(
                              label: language,
                              isSelected: selectedLanguages.contains(language),
                              onTap: () => ref
                                  .read(languageProvider.notifier)
                                  .toggleSelection(language),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                'resource_publisher'.tr(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),

              DropdownMenu<String>(
                controller: textEditingController,
                hintText: "any".tr(),
                menuHeight: 200.h,
                width: MediaQuery.of(context).size.width * 0.935,
                initialSelection: ref.watch(selectedAuthorProvider),
                dropdownMenuEntries: uniqueAuthors.map((author) {
                  return DropdownMenuEntry<String>(
                    value: author,
                    label: author,
                    labelWidget: Text(
                      author,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
                onSelected: (value) {
                  ref.read(selectedAuthorProvider.notifier).state =
                      value; // Update selected author
                  // You can add additional logic here if needed, e.g., filtering resources by author
                },
                menuStyle: MenuStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                  side: WidgetStateProperty.all(BorderSide(
                      width: 0.5,
                      color: AppColors.searchFieldBorderColor,
                      style: BorderStyle.solid,
                      strokeAlign: BorderSide.strokeAlignCenter)),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
                ),
              ),
              // TypeAheadDropDown(
              //   controller: textEditingController,
              //   hintText: "Any",
              //   listData: uniqueAuthors,
              //   onSuggestionSelected: (suggestion) {},
              //   onChanged: (p0) {},
              //   displayStringForOption: (p0) => p0,
              // ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton(
                    onPressed: () {
                      print('Selected Resource Types: $selectedResourceTypes');
                      print(
                          'Selected Disaster Stages: $selectedDisasterStages');
                      print('Selected Languages: $selectedLanguages');
                      final selectedAuthor = ref.watch(selectedAuthorProvider);
                      print('Selected Author: $selectedAuthor');
                      ref.read(favoritesProvider.notifier).advanceSearchs(
                          selectedAuthor ?? '',
                          selectedResourceTypes,
                          selectedLanguages,
                          selectedDisasterStages);
                      Navigator.pop(context);
                      textEditingController.clear();
                    },
                    text: 'apply_filters'.tr(),
                    height: 38.h,
                    horizontalPadding: 18,
                  ),
                  const SizedBox(width: 8.0),
                  AppButton(
                    onPressed: () {
                      ref.read(resourceTypeProvider.notifier).reset();
                      ref.read(disasterStageProvider.notifier).reset();
                      ref.read(languageProvider.notifier).reset();
                      ref.read(selectedAuthorProvider.notifier).state = null;
                      print('Selected ${ref.watch(selectedAuthorProvider)}');
                      textEditingController.clear();
                    },
                    text: 'reset_filters'.tr(),
                    height: 38.h,
                    horizontalPadding: 18,
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

// Separate stateless widget for the selectable chip
class _SelectableChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectableChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        labelPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
        visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity,
        ),
        side: const BorderSide(
          color: AppColors.appCGreenColor,
          width: 1.0,
          style: BorderStyle.solid,
        ),
        backgroundColor:
            isSelected ? AppColors.appCGreenColor : AppColors.appWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color:
                isSelected ? AppColors.appWhiteColor : AppColors.appBlackColor,
          ),
        ),
      ),
    );
  }
}
