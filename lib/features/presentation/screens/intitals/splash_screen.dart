import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/mhpss_logo_text.dart';
import 'package:flutter/material.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashFuture = ref.watch(splashProvider);
    return Scaffold(
      backgroundColor: AppColors.welcomeBackgroundcolor,
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          gradient: RadialGradient(
              radius: 1.0, colors: AppColors.splashGradientColors),
          image: const DecorationImage(
            image: AssetImage(AppImages.splashImage),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MHPSSLogoText(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              splashFuture.when(
                data: (isLoaded) {
                  if (isLoaded) {
                    Future.microtask(() async {
                      final deviceId = await storage.getHiveValue("deviceId");
                      if (deviceId != null) {
                        navigator
                            .navigateToReplacement(const BottmTabBarScreen());
                      } else {
                        navigator.navigateToReplacement(
                            const CountryLanguageScreen());
                      }
                    });
                  }
                  return const SizedBox();
                },
                loading: () => const SizedBox(),
                error: (error, stackTrace) =>
                    Text(textAlign: TextAlign.center, 'unknown_error'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
