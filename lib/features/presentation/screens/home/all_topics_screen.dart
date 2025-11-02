import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class AllTopicsScreen extends ConsumerStatefulWidget {
  final bool isSelfcare;
  const AllTopicsScreen({super.key, this.isSelfcare = false});

  @override
  ConsumerState<AllTopicsScreen> createState() => _AllTopicsScreenState();
}

class _AllTopicsScreenState extends ConsumerState<AllTopicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        isBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: widget.isSelfcare
            ? ref.watch(toolkitSubCategoryProvider).when(
                  data: (toolkitCategory) {
                    if (toolkitCategory.data!.toolkit == null ||
                        toolkitCategory
                            .data!.toolkit!.toolkitCategories!.isEmpty) {
                      return Center(child: Text('no_category'.tr()));
                    }

                    final toolkit = toolkitCategory.data!.toolkit!
                        .toolkitCategories!.first!.toolkitSubCategories;
                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: List.generate(toolkit!.length, (index) {
                          final toolkitCategoryData = toolkit[index];
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 36) / 2,
                            child: PopularTopicsCard(
                              toolkitCategory: toolkitCategoryData,
                              onTap: () {
                                navigator.navigateToWithBottomNavBar(
                                    context,
                                    AllResourcesScreen(
                                        isPopularTopics: true,
                                        id: toolkitCategoryData.id));
                              },
                            ),
                          );
                        }),
                      ),
                    );

                    // ListView.separated(
                    //   separatorBuilder: (context, index) =>
                    //       SizedBox(width: 6.w),
                    //   scrollDirection: Axis.horizontal,
                    //   itemCount: toolkit!.first!.toolkitSubCategories!.length,
                    //   itemBuilder: (context, index) {
                    //     final toolkitCategoryData =
                    //         toolkit.first!.toolkitSubCategories?[index];

                    //     return PopularTopicsCard(
                    //       toolkitCategory: toolkitCategoryData!,
                    //       onTap: () {
                    //         navigator.navigateToWithBottomNavBar(
                    //             context,
                    //             AllResourcesScreen(
                    //                 isPopularTopics: true,
                    //                 id: toolkitCategoryData.id));
                    //       },
                    //     );
                    //   },
                    // );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                )
            : ref.watch(toolkitCategoryProvider).when(
                  data: (toolkitCategory) {
                    if (toolkitCategory.toolkit == null ||
                        toolkitCategory
                            .toolkit!.toolkitAllCategories!.isEmpty) {
                      return Center(child: Text("no_category".tr()));
                    }

                    final toolkit =
                        toolkitCategory.toolkit!.toolkitAllCategories!;

                    return SingleChildScrollView(
                      child: Wrap(
                        spacing: 12.0,
                        runSpacing: 12.0,
                        children: List.generate(toolkit.length, (index) {
                          final toolkitCategory = toolkit[index];
                          return SizedBox(
                            width: (MediaQuery.of(context).size.width - 36) / 2,
                            child: PopularTopicsCard(
                              toolkitCategory: toolkitCategory,
                              onTap: () {
                                navigator.navigateToWithBottomNavBar(
                                    context,
                                    AllResourcesScreen(
                                        id: toolkitCategory.id,
                                        isPopularTopics: true));
                              },
                            ),
                          );
                        }),
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                      child: Text(
                          textAlign: TextAlign.center, 'unknown_error'.tr())),
                ),
      ),
    );
  }
}
