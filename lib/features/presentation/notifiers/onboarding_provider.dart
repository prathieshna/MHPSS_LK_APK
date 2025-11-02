// lib/providers/onboarding_provider.dart
import 'package:beprepared/features/data/models/data%20models/onboarding_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

final isLastPageProvider = Provider<bool>((ref) {
  final currentPage = ref.watch(currentPageProvider);
  return currentPage == onboardingItems.length - 1;
});
