import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/data%20query/pages_query.dart';
import 'package:beprepared/features/data/models/responses/onboarding_response.dart';
import 'package:beprepared/features/data/models/responses/pages_response.dart';

abstract class PagesRepositoryInterface extends DioClient {}

class PagesRepository extends PagesRepositoryInterface {
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
  Future<PagesResponse> getPagesRepository() async {
    try {
      final response = await post(
        "${baseUrl}v1/graphql",
        data: {
          "query": PagesQuery.pagesQuery(
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
          'variables': {
            'locales': [_getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)]
          },
        },
      );

      log("pages response: ${response.data}");

      if (response.statusCode == 200 && response.data["data"] != null) {
        return PagesResponse.fromJson(response.data["data"]);
      } else {
        throw Exception('Failed to load pages data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in pages: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }

  Future<OnboardingResponse> getOnboardingRepository() async {
    try {
      final response = await post(
        "${baseUrl}v1/graphql",
        data: {
          "query": PagesQuery.onboardingQuery(
              _getHygraphLocale(navigatorKey.currentContext!.locale.languageCode)),
        },
      );

      log("onboarding response: ${response.data}");

      if (response.statusCode == 200 && response.data["data"] != null) {
        return OnboardingResponse.fromJson(response.data["data"]);
      } else {
        throw Exception('Failed to load onboarding pages data: ${response.statusMessage}');
      }
    } catch (e, stackTrace) {
      log("Error in onboarding pages: $e");
      log("Stack trace: $stackTrace");
      rethrow;
    }
  }
}
