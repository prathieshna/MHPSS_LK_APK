import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/advance_search_filter.dart';
import 'package:flutter/material.dart';

class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  TextEditingController searchConroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final favoritesData = ref.watch(favoritesProvider);
    final selectedResourceTypes = ref.watch(resourceTypeProvider);
    final selectedDisasterStages = ref.watch(disasterStageProvider);
    final selectedLanguages = ref.watch(languageProvider);
    final selectedAuthor = ref.watch(selectedAuthorProvider);
    return Scaffold(
      appBar: CustomAppBar(
        isFliter: true,
        isFavoriteSearch: true,
        controller: searchConroller,
        isBack: true,
        onBack: () {
          ref.read(bottomNavProvider.notifier).setIndex(0);
        },
        onFliter: () {
          ref.read(favoritesProvider.notifier).updateSearchTerm("");
          searchConroller.clear();
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: false,
            context: context,
            builder: (context) {
              return AdvanceFilterView();
            },
          );
        },
        onSearch: (value) {
          ref.read(favoritesProvider.notifier).updateSearchTerm(value,
              selectedAuthor: selectedAuthor,
              selectedFileTypes: selectedResourceTypes,
              selectedLanguages: selectedLanguages,
              selectedToolkitCategories: selectedDisasterStages);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // ref.refresh(favoritesProvider);
          // ref.refresh(resourceTypeProvider);
          // ref.refresh(disasterStageProvider);
          // ref.refresh(languageProvider);
          // ref.refresh(selectedAuthorProvider);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0.0),
          child: favoritesData.isEmpty
              ? Center(child: Text("no_favorites".tr()))
              : ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemCount: favoritesData.length,
                  itemBuilder: (context, index) {
                    final favoriteItem = favoritesData[index];

                    return ResourceCard(
                      title: favoriteItem.title ?? "",
                      description: favoriteItem.description ?? "",
                      author: favoriteItem.author ?? 'N/A',
                      imageUrl: favoriteItem.imageUrl ?? "",
                      isFavourite: favoriteItem.isFavorite ?? false,
                      publishedDate: "2022",
                      pdfDocument: favoriteItem.pdfDocument,
                      audioDocument: favoriteItem.audioDocument,
                      videoDocument: favoriteItem.videoDocumeent,
                      favouriteTap: () {
                        ref
                            .read(favoritesProvider.notifier)
                            .toggleFavorite(favoriteItem);
                      },
                      downloadTap: () {
                        navigator.navigateToWithBottomNavBar(
                            context,
                            ResourceDetailsScreen(
                              id: favoriteItem.id!,
                              isDownload: true,
                            ));
                      },
                      onTap: () {
                        navigator.navigateToWithBottomNavBar(
                          context,
                          ResourceDetailsScreen(
                            id: favoriteItem.id!,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}
