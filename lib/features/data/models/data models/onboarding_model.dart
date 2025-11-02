// lib/models/onboarding_item.dart
import 'package:beprepared/core/resources/all_imports.dart';

class OnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    title: 'onboarding.find_resources_title'.tr(),
    description: 'onboarding.find_resources_description'.tr(),
    imagePath: AppImages.onboarding1,
  ),
  OnboardingItem(
    title: 'onboarding.use_offline_title'.tr(),
    description: 'onboarding.use_offline_description'.tr(),
    imagePath: AppImages.onboarding2,
  ),
  OnboardingItem(
    title: 'onboarding.favourites_title'.tr(),
    description: 'onboarding.favourites_description'.tr(),
    imagePath: AppImages.onboarding3,
  ),
];
