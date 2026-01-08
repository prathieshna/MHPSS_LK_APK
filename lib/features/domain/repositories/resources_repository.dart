import 'package:mhpss_app/mhpss_app.dart';
import 'package:mhpss_app/core/resources/all_imports.dart';
import 'package:mhpss_app/features/data/models/responses/popular_resources_response.dart';
import 'package:mhpss_app/features/data/models/responses/search_response.dart';

abstract class ResourcesRepositoryInterface extends DioClient {}

class ResourcesRepository extends ResourcesRepositoryInterface {
  final ResourcesQuery resourcesQuery = ResourcesQuery();
  final String baseUrl = APIConstants.baseUrl;

  // Map app locale codes to language codes for Hygraph
  String _getHygraphLocale(String appLocaleCode) {
    // Extract just the language code (e.g., 'en' from 'en_US', 'ta' from 'ta_LK')
    final languageCode = appLocaleCode.split('_').first;

    switch (languageCode) {
      case 'en':
        return 'en';
      case 'ar':
        return 'ar';
      case 'si':
        return 'si';
      case 'ta':
        return 'ta';
      default:
        return 'en'; // Default fallback to English
    }
  }

  Future<PopularResourcesResponse> getPopularResourcesRepository() async {
    print("🟡 [DEBUG] ResourcesRepository.getPopularResourcesRepository: Called");
    try {
      final locale = navigatorKey.currentContext!.locale.languageCode;
      final hygraphLocale = _getHygraphLocale(locale);
      print("🟡 [DEBUG] App locale: $locale, Hygraph locale: $hygraphLocale");

      final query = ResourcesQuery.getPopularResourcesQuery(hygraphLocale);
      print("🟡 [DEBUG] Full Query:\n$query");

      final response = await post(
        baseUrl,
        data: {
          "query": query,
        },
      );

      log("Popular resources response: ${response.data}");

      if (response.statusCode == 200 && response.data["data"] != null) {
        return PopularResourcesResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load Popular resources data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in Popular resources: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<SingleResourceResponse> getSingleResourceRepository(String? id) async {
    print("Repo id: $id");
    try {
      final response = await post(
        baseUrl,
        data: {
          "query": ResourcesQuery.getSingleResourceQuery(
              id, _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("single_resources response: ${response.data}");
      log("single_resources status code: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        return SingleResourceResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load single_resources data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in single_resources: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<SearchResponse> getAllSearchResourcesRepository(
      String? searchQuery) async {
    print("🔍 [DEBUG] Search query: $searchQuery");
    try {
      final response = await post(
        baseUrl,
        data: {
          "query": ResourcesQuery.searchResourcesQuery(
              searchQuery ?? "",
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("search response: ${response.data}");
      log("search status code: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        // Convert Hygraph response to SearchResponse format
        // The response.data["data"]["resources"] contains the search results
        return SearchResponse.fromHygraphJson(response.data);
      } else {
        throw Exception(
            'Failed to load search data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in search: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
