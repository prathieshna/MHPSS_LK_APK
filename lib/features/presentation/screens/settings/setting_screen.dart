import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/presentation/providers/pages_provider.dart';
import 'package:beprepared/features/presentation/screens/settings/terms_of_use.dart';
import 'package:flutter/material.dart';

class SettingScreen extends ConsumerStatefulWidget {
  const SettingScreen({super.key});

  @override
  ConsumerState<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr("about"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 36.h),
            ref.watch(pagesDataProvider).when(
                  data: (pages) {
                    if (pages.pagesConnection.edges.isEmpty) {
                      return Center(child: Text('no_pages'.tr()));
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: pages.pagesConnection.edges.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16.h),
                      itemBuilder: (context, index) {
                        final pagesData = pages.pagesConnection.edges[index];

                        return _buildOptionCard(
                          svgIcon: AppImages.settingAbout,
                          title: pagesData.node.title,
                          onTap: () {
                            navigator.navigateToWithBottomNavBar(
                                context,
                                TermsOfUseScreen(
                                  title: pagesData.node.title,
                                  summery: pagesData.node.content.html ?? "N/A",
                                ));
                          },
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stack) => Center(
                      child: Text(
                          textAlign: TextAlign.center, 'unknown_error'.tr())),
                ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              svgIcon: AppImages.settingCountry,
              title: tr("country"),
              onTap: () {
                navigator.navigateToReplacement(CountryLanguageScreen(
                  isFromSettings: true,
                ));
              },
            ),
            SizedBox(height: 16.h),
            _buildOptionCard(
              svgIcon: AppImages.settingLang,
              title: tr("language"),
              onTap: () {
                navigator.navigateToReplacement(CountryLanguageScreen(
                  isFromSettings: true,
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String svgIcon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8.w),
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(svgIcon),
                const SizedBox(width: 16),
                Text(title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    )),
              ],
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.black54, size: 16),
          ],
        ),
      ),
    );
  }
}
