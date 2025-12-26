import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/responses/resource_by_category_response.dart';
import 'package:beprepared/features/data/models/responses/toolkit_sub_category_response.dart';
import 'package:beprepared/features/data/models/responses/video_response.dart';

// Provider for the API serviceß
final _apiServiceProvider = Provider<ToolkitRespository>((ref) {
  return ToolkitRespository();
});

final toolkitCategoryProvider = FutureProvider.autoDispose<ToolkitResponse>(
  (ref) async {
    print("🔵 [DEBUG] toolkitCategoryProvider: Started");
    try {
      final apiService = ref.watch(_apiServiceProvider);
      print("🔵 [DEBUG] toolkitCategoryProvider: API service obtained");
      final result = await apiService.getToolkitCategoryRepository();
      print("🔵 [DEBUG] toolkitCategoryProvider: Success - got ${result.toolkit?.toolkitAllCategories?.length ?? 0} categories");
      return result;
    } catch (e, stack) {
      print("🔴 [DEBUG] toolkitCategoryProvider: ERROR - $e");
      print("🔴 [DEBUG] Stack trace: $stack");
      rethrow;
    }
  },
);

final toolkitSubCategoryProvider =
    FutureProvider.autoDispose<ToolkitSubCategoryResponse>(
  (ref) async {
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.getToolkitSubCategoryRepository();
  },
);

final resourcesByCategoryProvider =
    FutureProvider.autoDispose.family<ResourceByCategoryResponse, String>(
  (ref, id) async {
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.resourcesByCategoryRepository(id);
  },
);

final homePageVideoProvider = FutureProvider.autoDispose<VideoResponse>(
  (ref) async {
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.homePageVideoRepository();
  },
);
