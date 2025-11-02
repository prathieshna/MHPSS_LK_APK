import 'package:beprepared/core/resources/all_imports.dart';

final hiveProvider = Provider<HiveInterface>((ref) => Hive);

final downloadToolTipProvider = StateProvider.autoDispose<bool>((ref) => true);

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, List<ResourceModel>>((ref) {
  final hive = ref.read(hiveProvider);
  return FavoritesNotifier(hive);
});

class FavoritesNotifier extends StateNotifier<List<ResourceModel>> {
  final HiveInterface hive;
  static const favoritesBox = 'favoritesBox';

  // New state for search term
  String searchTerm = '';

  FavoritesNotifier(this.hive) : super([]) {
    _loadFavorites();
  }

  void _loadFavorites() {
    final box = hive.box<ResourceModel>(favoritesBox);
    state = box.values.toList().cast<ResourceModel>();
  }

  Future<void> toggleFavorite(ResourceModel resource) async {
    final box = hive.box<ResourceModel>(favoritesBox);

    if (state.any((item) => item.id == resource.id)) {
      // Remove favorite
      await box.delete(resource.id);
      state = state.where((item) => item.id != resource.id).toList();
    } else {
      // Add favorite
      await box.put(resource.id, resource..isFavorite = true);
      // Prepend the new favorite to the top of the list
      state = [resource] + state;
    }
  }

  // New method to update the search term and filter favorites
  void updateSearchTerm(String term,
      {String? selectedAuthor,
      List<String>? selectedFileTypes,
      List<String>? selectedLanguages,
      List<String>? selectedToolkitCategories}) {
    searchTerm = term;
    final box = hive.box<ResourceModel>(favoritesBox);

    state = box.values.toList().cast<ResourceModel>().where((item) {
      final termLowerCase = term.toLowerCase();

      // Search in title, author, fileTypeList, languagesList, and toolkitCategories
      bool matchesSearchTerm = term.isEmpty ||
          (item.title?.toLowerCase().contains(termLowerCase) == true ||
              item.author?.toLowerCase().contains(termLowerCase) == true ||
              item.fileTypeList?.any((fileType) =>
                      fileType.toLowerCase().contains(termLowerCase)) ==
                  true ||
              item.languagesList?.any((language) =>
                      language.toLowerCase().contains(termLowerCase)) ==
                  true ||
              item.toolkitCategories?.any((category) =>
                      category.toLowerCase().contains(termLowerCase)) ==
                  true);

      // Filter by selected author
      bool matchesAuthor = selectedAuthor == null ||
          (item.author?.toLowerCase().contains(selectedAuthor.toLowerCase()) ??
              false);

      // Filter by selected file types
      bool matchesFileTypes = selectedFileTypes == null ||
          selectedFileTypes.isEmpty ||
          (item.fileTypeList?.any((fileTypeItem) => selectedFileTypes.any(
                  (selectedFileType) => fileTypeItem
                      .toLowerCase()
                      .contains(selectedFileType.toLowerCase()))) ==
              true);

      // Filter by selected languages
      bool matchesLanguages = selectedLanguages == null ||
          selectedLanguages.isEmpty ||
          (item.languagesList?.any((languageItem) => selectedLanguages.any(
                  (selectedLang) => languageItem
                      .toLowerCase()
                      .contains(selectedLang.toLowerCase()))) ==
              true);

      // Filter by selected toolkit categories
      bool matchesToolkitCategories = selectedToolkitCategories == null ||
          selectedToolkitCategories.isEmpty ||
          (item.toolkitCategories?.any((categoryItem) =>
                  selectedToolkitCategories.any((selectedCategory) =>
                      categoryItem
                          .toLowerCase()
                          .contains(selectedCategory.toLowerCase()))) ==
              true);

      // Return true if all conditions are satisfied
      return matchesSearchTerm &&
          matchesAuthor &&
          matchesFileTypes &&
          matchesLanguages &&
          matchesToolkitCategories;
    }).toList();
  }

  void advanceSearchs(String authorName, List<String> fileType,
      List<String> lang, List<String> toolkitCategories) {
    print(
        "authorName: $authorName, fileType: $fileType, lang: $lang, toolkitCategories: $toolkitCategories");
    final box = hive.box<ResourceModel>(favoritesBox);
    state = box.values.toList().cast<ResourceModel>().where((item) {
      final authorNameLower = authorName.toLowerCase();

      // Check if the item author matches the given author name (case-insensitive)
      bool matchesAuthor =
          item.author?.toLowerCase().contains(authorNameLower) ?? false;

      // Check if any item in fileTypeList matches the provided fileType (case-insensitive)

      bool matchesFileType = fileType.isEmpty ||
          item.fileTypeList?.any((fileTypeItem) => fileTypeItem
                  .toLowerCase()
                  .contains(fileType.join(' ').toLowerCase())) ==
              true;

      // Check if any item in languagesList matches the provided lang list (case-insensitive)
      bool matchesLanguage = lang.isEmpty ||
          item.languagesList?.any((languageItem) => lang.any((searchLang) =>
                  languageItem
                      .toLowerCase()
                      .contains(searchLang.toLowerCase()))) ==
              true;

      // Check if any item in toolkitCategories matches the provided toolkitCategories list (case-insensitive)
      bool matchesToolkitCategories = toolkitCategories.isEmpty ||
          item.toolkitCategories?.any((categoryItem) => toolkitCategories.any(
                  (category) => categoryItem
                      .toLowerCase()
                      .contains(category.toLowerCase()))) ==
              true;

      // Return true if all filters match
      return matchesAuthor &&
          matchesFileType &&
          matchesLanguage &&
          matchesToolkitCategories;
    }).toList();
  }

  // New method to get unique authors from favorites
  List<String> getUniqueAuthors() {
    final authorsSet = <String>{}; // Using a Set to avoid duplicates

    for (var item in state) {
      if (item.author != null && item.author!.isNotEmpty) {
        authorsSet.add(item.author!);
      }
    }

    return authorsSet.toList(); // Convert Set back to List
  }
}

final downloadProvider =
    StateNotifierProvider.autoDispose<DownloadNotifier, List<DownloadedFile>>(
        (ref) {
  return DownloadNotifier();
});

class DownloadNotifier extends StateNotifier<List<DownloadedFile>> {
  DownloadNotifier() : super([]) {
    _initialize();
  }

  Future<void> _initialize() async {
    await loadDownloads();
  }

  Future<void> download(DownloadedFile downloadedFile) async {
    try {
      print("state: $state");
      // Download the main file
      final filePath = await appFunctions.downloadFile(
          downloadedFile.fileUrl ?? "", downloadedFile.fileName ?? "");

      // Download the image if available
      String? localImagePath;
      if (downloadedFile.imageUrl != null &&
          downloadedFile.imageUrl!.isNotEmpty) {
        localImagePath = await appFunctions.downloadAndSaveImage(
          downloadedFile.imageUrl!,
          downloadedFile.fileName ?? "unknown",
        );
      }

      // Download and update translations
      List<Future<DownloadLanguageTranslation>> translationFutures =
          (downloadedFile.downloadLanguageTranslations ?? [])
              .map((translation) async {
        if (translation.link.isNotEmpty) {
          // Generate a unique file name for each translation
          final uniqueFileName =
              "${downloadedFile.id}_${translation.language}_${downloadedFile.fileName}";

          // Download the file and get the local path
          final translationFilePath = await appFunctions.downloadFile(
            translation.link,
            uniqueFileName,
          );

          // Update the translation object with the local file path
          return DownloadLanguageTranslation(
            language: translation.language,
            id: translation.id,
            link: translation.link,
            filePath: translationFilePath,
          );
        }
        return translation; // Return the original if no link
      }).toList();

      // Wait for all translation downloads to complete
      List<DownloadLanguageTranslation> updatedTranslations =
          await Future.wait(translationFutures);

      if (filePath != null) {
        // Open the Hive box
        final downloadsBox = await Hive.openBox<DownloadedFile>('downloads');

        final downloadedFileData = DownloadedFile(
          id: downloadedFile.id,
          title: downloadedFile.title,
          description: downloadedFile.description,
          author: downloadedFile.author,
          publishedAt: downloadedFile.publishedAt,
          fileUrl: downloadedFile.fileUrl,
          fileName: downloadedFile.fileName,
          filePath: filePath,
          imageUrl: downloadedFile.imageUrl,
          imagePath: localImagePath,
          pdfLanguage: downloadedFile.pdfLanguage,
          downloadLanguageTranslations: updatedTranslations,
        );

        // Save to Hive
        await downloadsBox.add(downloadedFileData);
      }

      await loadDownloads();
    } catch (e) {
      print("Download failed: $e");
    }
  }

  // Future<void> download(DownloadedFile downloadedFile) async {
  //   try {
  //     print("state: $state");

  //     // Download the main file
  //     final filePath = await appFunctions.downloadFile(
  //         downloadedFile.fileUrl ?? "", downloadedFile.fileName ?? "");

  //     // Download the image if available
  //     String? localImagePath;
  //     if (downloadedFile.imageUrl != null &&
  //         downloadedFile.imageUrl!.isNotEmpty) {
  //       localImagePath = await appFunctions.downloadAndSaveImage(
  //         downloadedFile.imageUrl!,
  //         downloadedFile.fileName ?? "unknown",
  //       );
  //     }

  //     // Generate and download translations
  //     List<DownloadLanguageTranslation>? newTranslations = await Future.wait(
  //         (downloadedFile.downloadLanguageTranslations ?? [])
  //             .map((translation) async {
  //       if (translation.link.isNotEmpty) {
  //         // Unique file name generation
  //         final uniqueFileName =
  //             "${downloadedFile.id}_${translation.language}_${downloadedFile.fileName}";

  //         // Download the file and get the local path
  //         final translationFilePath = await appFunctions.downloadFile(
  //           translation.link,
  //           uniqueFileName,
  //         );

  //         // Return updated translation object
  //         return DownloadLanguageTranslation(
  //           language: translation.language,
  //           id: translation.id,
  //           link: translation.link,
  //           filePath: translationFilePath, // Save local path
  //         );
  //       }
  //       return translation; // Return the original if no link
  //     }).toList());

  //     // Open the Hive box
  //     final downloadsBox = await Hive.openBox<DownloadedFile>('downloads');

  //     // Check if an object with the same ID already exists
  //     final existingIndex = downloadsBox.values
  //         .toList()
  //         .indexWhere((item) => item.id == downloadedFile.id);

  //     if (existingIndex != -1) {
  //       // If the object exists, merge translations
  //       final existingFile = downloadsBox.getAt(existingIndex);

  //       // Combine old and new translations
  //       List<DownloadLanguageTranslation> combinedTranslations = [
  //         ...(existingFile?.downloadLanguageTranslations ?? []),
  //         ...newTranslations ?? [],
  //       ];

  //       // Remove duplicate translations (based on language)
  //       combinedTranslations =
  //           _removeDuplicateTranslations(combinedTranslations);

  //       print(
  //           "combinedTranslations: ${combinedTranslations.length}, ${combinedTranslations[0].filePath}, ${combinedTranslations[1].filePath}, ${combinedTranslations[2].filePath}");

  //       // Update the existing object with new translations
  //       final updatedDownloadedFile = DownloadedFile(
  //         id: existingFile?.id ?? downloadedFile.id,
  //         title: existingFile?.title ?? downloadedFile.title,
  //         description: existingFile?.description ?? downloadedFile.description,
  //         author: existingFile?.author ?? downloadedFile.author,
  //         publishedAt: existingFile?.publishedAt ?? downloadedFile.publishedAt,
  //         fileUrl: existingFile?.fileUrl ?? downloadedFile.fileUrl,
  //         fileName: existingFile?.fileName ?? downloadedFile.fileName,
  //         filePath: existingFile?.filePath ?? filePath,
  //         imageUrl: existingFile?.imageUrl ?? downloadedFile.imageUrl,
  //         imagePath: existingFile?.imagePath ?? localImagePath,
  //         pdfLanguage: existingFile?.pdfLanguage ?? downloadedFile.pdfLanguage,
  //         downloadLanguageTranslations: combinedTranslations,
  //       );

  //       // Save the updated object back to Hive
  //       await downloadsBox.putAt(existingIndex, updatedDownloadedFile);
  //     } else {
  //       // If no existing object, save a new one
  //       final newDownloadedFile = DownloadedFile(
  //         id: downloadedFile.id,
  //         title: downloadedFile.title,
  //         description: downloadedFile.description,
  //         author: downloadedFile.author,
  //         publishedAt: downloadedFile.publishedAt,
  //         fileUrl: downloadedFile.fileUrl,
  //         fileName: downloadedFile.fileName,
  //         filePath: filePath,
  //         imageUrl: downloadedFile.imageUrl,
  //         imagePath: localImagePath,
  //         pdfLanguage: downloadedFile.pdfLanguage,
  //         downloadLanguageTranslations: newTranslations,
  //       );

  //       await downloadsBox.add(newDownloadedFile);
  //     }

  //     // Reload state
  //     await loadDownloads();
  //   } catch (e) {
  //     print("Download failed: $e");
  //   }
  // }

  // Safely convert dynamic translations to typed translations
  List<DownloadLanguageTranslation>? _convertTranslations(
      dynamic translations) {
    if (translations == null) return null;

    // If already the correct type, return as is
    if (translations is List<DownloadLanguageTranslation>) {
      return translations;
    }

    // If it's a List<dynamic>, try to convert
    if (translations is List) {
      return translations
          .map((item) {
            // If item is already a DownloadLanguageTranslation, return it
            if (item is DownloadLanguageTranslation) return item;

            // If item is a Map, try to create a new DownloadLanguageTranslation
            if (item is Map) {
              return DownloadLanguageTranslation(
                language: item['language']?.toString() ?? '',
                id: item['id']?.toString() ?? '',
                link: item['link']?.toString() ?? '',
                filePath: item['filePath']?.toString() ?? '',
              );
            }

            // If cannot convert, return null (will be filtered out)
            return null;
          })
          .whereType<DownloadLanguageTranslation>()
          .toList();
    }

    // If cannot convert, return null
    return null;
  }

  // Remove duplicate translations
  List<DownloadLanguageTranslation> _removeDuplicateTranslations(
      List<DownloadLanguageTranslation> translations) {
    final uniqueTranslations = <String, DownloadLanguageTranslation>{};

    for (var translation in translations) {
      // Use the language as the key to remove duplicates
      uniqueTranslations[translation.language] = translation;
    }

    return uniqueTranslations.values.toList();
  }

  // Load the files from Hive and update state
  Future<void> loadDownloads() async {
    try {
      final box = await Hive.openBox<DownloadedFile>('downloads');
      final files = box.values.toList();

      // Update state with files loaded from Hive
      state = files.toList(); // Reverse to show most recent on top

      for (var file in files) {
        // print(
        //     "File path:--------- ${file.filePath}, File URL: ${file.fileUrl}, File name: ${file.pdfLanguage}");

        // Print translations if they exist
        if (file.downloadLanguageTranslations != null) {
          // print("Translations:");
          for (var translation in file.downloadLanguageTranslations!) {
            print(
                "- Language: ${translation.language}, ID: ${translation.id}, filePath: ${translation.filePath}, Link: ${translation.link}, File path: ${file.filePath}, File URL: ${file.fileUrl}, File name: ${file.pdfLanguage}");
          }
        }
      }
    } catch (e) {
      print("Error loading downloads: $e");
    }
  }

  // Delete the file from both the filesystem and Hive
  Future<void> deleteFile(int index) async {
    try {
      final box = await Hive.openBox<DownloadedFile>('downloads');
      final downloadedFile = box.getAt(index);

      if (downloadedFile != null) {
        final file = File(downloadedFile.filePath ?? "");
        if (await file.exists()) {
          await file.delete();
          print("File deleted from filesystem: ${downloadedFile.fileName}");
        }
        // Remove from Hive
        box.deleteAt(index);
        print("File deleted from Hive: ${downloadedFile.fileName}");

        // Refresh the state by reloading the files
        await loadDownloads();
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
}
