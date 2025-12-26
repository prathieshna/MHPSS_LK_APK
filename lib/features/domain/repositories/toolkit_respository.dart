import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/responses/resource_by_category_response.dart';
import 'package:beprepared/features/data/models/responses/toolkit_sub_category_response.dart';
import 'package:beprepared/features/data/models/responses/video_response.dart';

abstract class ToolkitRespositoryInterface extends DioClient {}

class ToolkitRespository extends ToolkitRespositoryInterface {
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

  Future<ToolkitResponse> getToolkitCategoryRepository() async {
    print("🟡 [DEBUG] ToolkitRepository.getToolkitCategoryRepository: Called");
    try {
      final locale = navigatorKey.currentContext!.locale.languageCode;
      final hygraphLocale = _getHygraphLocale(locale);
      print("🟡 [DEBUG] App locale: $locale, Hygraph locale: $hygraphLocale");

      final query = ToolkitQuery.toolkitCategoryQuery(hygraphLocale);
      print("🟡 [DEBUG] Full Query:\n$query");

      final response = await post(
        baseUrl,
        data: {
          "query": query,
        },
      );

      log("toolkit categories response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return ToolkitResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load toolkit categories data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in toolkit categories: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<ToolkitSubCategoryResponse> getToolkitSubCategoryRepository() async {
    try {
      final response = await post(
        baseUrl,
        data: {
          "query": ToolkitQuery.toolkitSubCategoryQuery(
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("toolkit sub categories response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return ToolkitSubCategoryResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load toolkit sub categories data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in toolkit sub categories: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<ResourceByCategoryResponse> resourcesByCategoryRepository(
      String id) async {
    try {
      final response = await post(
        baseUrl,
        data: {
          "query": ToolkitQuery.resourcesByCategoryQuery(
              id, _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("resource by categories response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        print("resource by categories response: -- ${response.data}");
        return ResourceByCategoryResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load resource by categories data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in resource by categories: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<VideoResponse> homePageVideoRepository() async {
    try {
      final response = await post(
        baseUrl,
        data: {
          "query": ToolkitQuery.homePageVideoQuery(
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("Home page video response: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        print("Home page video response: -- ${response.data}");
        return VideoResponse.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to load Home page video data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in Home page video: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
