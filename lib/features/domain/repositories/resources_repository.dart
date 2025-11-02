import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/responses/popular_resources_response.dart';
import 'package:beprepared/features/data/models/responses/search_response.dart';

abstract class ResourcesRepositoryInterface extends DioClient {}

class ResourcesRepository extends ResourcesRepositoryInterface {
  final ResourcesQuery resourcesQuery = ResourcesQuery();
  final String baseUrl = APIConstants.baseUrl;

  // Map app locale codes to Hygraph supported locales with fallback
  String _getHygraphLocale(String appLocaleCode) {
    switch (appLocaleCode) {
      case 'en':
        return 'en';
      case 'ar':
        return 'ar';
      case 'si':
      case 'ta':
        // Fallback to English for Sinhala and Tamil since Hygraph likely doesn't support them
        return 'en';
      default:
        return 'en'; // Default fallback to English
    }
  }

  Future<PopularResourcesResponse> getPopularResourcesRepository() async {
    try {
      final response = await post(
        "${baseUrl}v1/graphql",
        data: {
          "query": ResourcesQuery.getPopularResourcesQuery(
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
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
        "${baseUrl}v1/graphql",
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
    try {
      final response = await get(
        "https://www.mhpss.net/api/search?facet=toolkit.title:BePrepared+App&q=$searchQuery",
      );

      log("search response: ${response.data}");
      log("search status code: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        return SearchResponse.fromJson(response.data);
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
