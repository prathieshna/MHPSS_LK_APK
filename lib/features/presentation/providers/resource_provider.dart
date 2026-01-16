import 'package:mhpss_app/core/resources/all_imports.dart';
import 'package:mhpss_app/features/data/models/responses/popular_resources_response.dart';
import 'package:mhpss_app/features/data/models/responses/search_response.dart';
import 'package:mhpss_app/features/data/models/responses/resources_by_slug_response.dart';
import 'package:mhpss_app/features/domain/repositories/resources_repository.dart';

// Provider for the API serviceß
final _apiServiceProvider = Provider<ResourcesRepository>((ref) {
  return ResourcesRepository();
});

final singleResourcesDataProvider =
    FutureProvider.autoDispose.family<SingleResourceResponse, String>(
  (ref, id) async {
    print("FutureProvider id: $id");
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.getSingleResourceRepository(id);
  },
);

// Provider to fetch all resources by slug (for translations)
final resourcesBySlugProvider =
    FutureProvider.autoDispose.family<ResourcesBySlugResponse, String>(
  (ref, slug) async {
    print("🔍 [DEBUG] resourcesBySlugProvider: Fetching resources for slug: $slug");
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.getResourcesBySlugRepository(slug);
  },
);

final popularResourcesProvider =
    FutureProvider.autoDispose<PopularResourcesResponse>(
  (ref) async {
    print("🟢 [DEBUG] popularResourcesProvider: Started");
    try {
      final apiService = ref.watch(_apiServiceProvider);
      print("🟢 [DEBUG] popularResourcesProvider: API service obtained");
      final result = await apiService.getPopularResourcesRepository();
      print("🟢 [DEBUG] popularResourcesProvider: Success - got ${result.data?.toolkit?.resources?.length ?? 0} resources");
      return result;
    } catch (e, stack) {
      print("🔴 [DEBUG] popularResourcesProvider: ERROR - $e");
      print("🔴 [DEBUG] Stack trace: $stack");
      rethrow;
    }
  },
);

// Provider for the selected resource types
class ResourceTypeNotifier extends StateNotifier<List<String>> {
  ResourceTypeNotifier() : super([]);

  void toggleSelection(String item) {
    if (state.contains(item)) {
      state = state.where((element) => element != item).toList();
    } else {
      state = [...state, item];
    }
    print("type state: $state");
  }

  void reset() {
    state = [];
  }
}

class DisasterStageNotifier extends StateNotifier<List<String>> {
  DisasterStageNotifier() : super([]);

  void toggleSelection(String item) {
    if (state.contains(item)) {
      state = state.where((element) => element != item).toList();
    } else {
      state = [...state, item];
    }
    print("stage state: $state");
  }

  void reset() {
    state = [];
  }
}

class LanguageNotifier extends StateNotifier<List<String>> {
  LanguageNotifier() : super([]);

  void toggleSelection(String item) {
    if (state.contains(item)) {
      state = state.where((element) => element != item).toList();
    } else {
      state = [...state, item];
    }
    print("lang state: $state");
  }

  void reset() {
    state = [];
  }
}

// Providers
final resourceTypeProvider =
    StateNotifierProvider<ResourceTypeNotifier, List<String>>(
        (ref) => ResourceTypeNotifier());

final disasterStageProvider =
    StateNotifierProvider<DisasterStageNotifier, List<String>>(
        (ref) => DisasterStageNotifier());

final languageProvider = StateNotifierProvider<LanguageNotifier, List<String>>(
    (ref) => LanguageNotifier());

final selectedAuthorProvider = StateProvider<String?>((ref) => "");

// Provider for the resource state
class ResourceState extends StateNotifier<Resource?> {
  ResourceState() : super(null);

  void setResource(Resource resource) {
    state = resource;
  }
}

final resourceProvider =
    StateNotifierProvider.autoDispose<ResourceState, Resource?>((ref) {
  return ResourceState();
});

final expandedSectionProvider =
    StateProvider.autoDispose<Set<String>>((ref) => {});

final searchResourcesProvider =
    StateNotifierProvider<SearchNotifier, AsyncValue<SearchResponse>>(
  (ref) {
    final apiService = ref.watch(_apiServiceProvider);
    return SearchNotifier(apiService);
  },
);

class SearchNotifier extends StateNotifier<AsyncValue<SearchResponse>> {
  final ResourcesRepository _apiService;

  SearchNotifier(this._apiService) : super(const AsyncValue.loading());

  Future<void> fetchResources(String searchQuery) async {
    try {
      state = const AsyncValue.loading(); // Set loading state.
      final response =
          await _apiService.getAllSearchResourcesRepository(searchQuery);
      state = AsyncValue.data(response); // Set data state.
    } catch (e, stack) {
      state = AsyncValue.error(e, stack); // Handle error state.
    }
  }
}
