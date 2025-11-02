import 'package:beprepared/features/presentation/providers/pages_provider.dart';
import 'package:flutter/material.dart';

import '../../../../core/resources/all_imports.dart';

// Hardcoded onboarding item class
class HardcodedOnboardingItem {
  final String title;
  final String description;
  final String imagePath;

  HardcodedOnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

// Hardcoded onboarding page widget
class HardcodedOnboardingPage extends StatelessWidget {
  final HardcodedOnboardingItem item;

  const HardcodedOnboardingPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 44.h),
          Text(
            item.title,
            style: TextStyle(
              color: AppColors.textBlueColor,
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textBlackColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            height: 547.h,
            child: Image.asset(
              item.imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: Commented out CMS query fetching - can be restored later
    // final asyncOnboardingItems = ref.watch(onboardingDataProvider);
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: SafeArea(
    //     top: false,
    //     child: asyncOnboardingItems.when(
    //       data: (onboardingItems) {
    //         final currentPage = ref.watch(currentPageProvider);
    //         final isLastPage = ref.watch(isLastPageProvider);
    //         return Column(
    //           children: [
    //             Expanded(
    //               child: onboardingItems.onboardingScreens == null ||
    //                       onboardingItems.onboardingScreens!.isEmpty
    //                   ? Center(child: Text('no_results'.tr()))
    //                   : PageView.builder(
    //                       controller: _pageController,
    //                       itemCount: onboardingItems.onboardingScreens!.length,
    //                       onPageChanged: (index) {
    //                         ref.read(currentPageProvider.notifier).state = index;
    //                       },
    //                       itemBuilder: (context, index) {
    //                         final item = onboardingItems.onboardingScreens![index];
    //                         return OnboardingPage(item: item);
    //                       },
    //                     ),
    //             ),
    //             // ... rest of the original CMS-based UI
    //           ],
    //         );
    //       },
    //       loading: () => Center(child: CircularProgressIndicator()),
    //       error: (error, stack) => Center(
    //           child: Text(textAlign: TextAlign.center, 'unknown_error'.tr())),
    //     ),
    //   ),
    // );

    // Hardcoded onboarding data (temporary replacement)
    final hardcodedOnboardingData = [
      HardcodedOnboardingItem(
        title: "Search & Discover",
        description: "Find the mental health resources you need",
        imagePath: AppImages.searchPng,
      ),
      HardcodedOnboardingItem(
        title: "Save Resources",
        description: "Save your favorite resources for offline access",
        imagePath: AppImages.savePng,
      ),
      HardcodedOnboardingItem(
        title: "Download Content",
        description: "Download resources to access them anytime",
        imagePath: AppImages.downloadPng,
      ),
    ];

    final isLastPage = _currentPage == hardcodedOnboardingData.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: hardcodedOnboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = hardcodedOnboardingData[index];
                  return HardcodedOnboardingPage(item: item);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 32.0, right: 32.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 80.w,
                    child: GestureDetector(
                      onTap: () {
                        navigator.navigateToReplacement(
                            const BottmTabBarScreen());
                      },
                      child: Text(
                        tr('skip'),
                        style: TextStyle(
                          color: AppColors.textSkipColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: hardcodedOnboardingData.length,
                    effect: WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      activeDotColor: AppColors.textBlueColor,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),
                  SizedBox(
                    width: 80.w,
                    child: GestureDetector(
                      onTap: () {
                        if (isLastPage) {
                          navigator.navigateToReplacement(
                              const BottmTabBarScreen());
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: Text(
                        isLastPage ? tr('get_started') : tr('next'),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: AppColors.textBlueColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}