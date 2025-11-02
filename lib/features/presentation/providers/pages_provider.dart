// Provider for the API serviceß

import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/responses/onboarding_response.dart';
import 'package:beprepared/features/data/models/responses/pages_response.dart';
import 'package:beprepared/features/domain/repositories/pages_repository.dart';

final _apiServiceProvider = Provider<PagesRepository>((ref) {
  return PagesRepository();
});

final pagesDataProvider = FutureProvider.autoDispose<PagesResponse>(
  (ref) async {
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.getPagesRepository();
  },
);

final onboardingDataProvider = FutureProvider.autoDispose<OnboardingResponse>(
  (ref) async {
    final apiService = ref.watch(_apiServiceProvider);
    return apiService.getOnboardingRepository();
  },
);
