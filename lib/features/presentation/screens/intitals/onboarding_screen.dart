import 'package:flutter/material.dart';

import '../../../../core/resources/all_imports.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final asyncOnboardingItems = ref.watch(onboardingDataProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: asyncOnboardingItems.when(
          data: (onboardingItems) {
            final currentPage = ref.watch(currentPageProvider);
            final isLastPage = currentPage == (onboardingItems.onboardingScreens?.length ?? 0) - 1;

            return Column(
              children: [
                Expanded(
                  child: onboardingItems.onboardingScreens == null ||
                          onboardingItems.onboardingScreens!.isEmpty
                      ? Center(child: Text('no_results'.tr()))
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: onboardingItems.onboardingScreens!.length,
                          onPageChanged: (index) {
                            ref.read(currentPageProvider.notifier).state = index;
                          },
                          itemBuilder: (context, index) {
                            final item = onboardingItems.onboardingScreens![index];
                            return OnboardingPage(item: item);
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
                        count: onboardingItems.onboardingScreens?.length ?? 0,
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
              child: Text(textAlign: TextAlign.center, 'unknown_error'.tr())),
        ),
      ),
    );
  }
}
