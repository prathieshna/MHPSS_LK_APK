import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/utils/widgets/mhpss_logo_text.dart';
import 'package:flutter/material.dart';

class CountryLanguageScreen extends StatefulWidget {
  final bool isFromSettings;
  const CountryLanguageScreen({super.key, this.isFromSettings = false});

  @override
  State<CountryLanguageScreen> createState() => _CountryLanguageScreenState();
}

class _CountryLanguageScreenState extends State<CountryLanguageScreen> {
  String? selectedCountry;
  String? selectedLanguage;
  String? finalCountry;
  String? finalLanguage;

  // Unified list for countries and languages
  final List<Map<String, String>> localizedItems = [
    {'en': 'Sri Lanka', 'si': 'ශ්‍රී ලංකාව', 'ta': 'இலங்கை', 'ar': 'سريلانكا'},
    {'en': 'Other Countries', 'si': 'වෙනත් රටවල්', 'ta': 'பிற நாடுகள்', 'ar': 'بلدان أخرى'},
    {'en': 'English', 'si': 'ඉංග්‍රීසි', 'ta': 'ஆங்கிலம்', 'ar': 'الإنجليزية'},
    {'en': 'Sinhala', 'si': 'සිංහල', 'ta': 'சிংகளம்', 'ar': 'السنهالية'},
    {'en': 'Tamil', 'si': 'දෙමළ', 'ta': 'தமிழ்', 'ar': 'التاميل'},
    {'en': 'Arabic', 'si': 'අරාබි', 'ta': 'அரபு', 'ar': 'العربية'},
  ];

  // Get the localized name based on current locale
  String getLocalizedName(String englishName) {
    // For languages, show in native form regardless of current locale
    switch (englishName) {
      case 'English':
        return 'English';
      case 'Sinhala':
        return 'සිංහල';
      case 'Tamil':
        return 'தமிழ்';
      default:
        // For countries, use localized names
        final item = localizedItems.firstWhere(
          (item) => item['en'] == englishName,
          orElse: () => {'en': englishName, 'si': englishName, 'ta': englishName},
        );
        return item[context.locale.languageCode] ?? englishName;
    }
  }

  List<String> getLocalizedList(String type) {
    if (type == 'country') {
      return localizedItems
          .where((item) => item['en']!.contains(
              RegExp(r'Sri Lanka|Other Countries')))
          .map((item) => item[context.locale.languageCode] ?? item['en']!)
          .toList();
    } else {
      // For languages, show in their native form and hide Arabic temporarily
      return localizedItems
          .where((item) => item['en']!.contains(RegExp(r'English|Sinhala|Tamil'))) // Removed Arabic
          .map((item) {
            // Show languages in their native form
            switch (item['en']) {
              case 'English':
                return 'English'; // English in English
              case 'Sinhala':
                return 'සිංහල'; // Sinhala in Sinhala script
              case 'Tamil':
                return 'தமிழ்'; // Tamil in Tamil script
              default:
                return item['en']!;
            }
          })
          .toList();
    }
  }

  // Get the English name from localized name
  String getEnglishName(String localizedName) {
    // Handle native language names
    switch (localizedName) {
      case 'English':
        return 'English';
      case 'සිංහල':
        return 'Sinhala';
      case 'தமிழ்':
        return 'Tamil';
      default:
        // Fallback to original logic for countries and other items
        for (var item in localizedItems) {
          if (item['en'] == localizedName || item['si'] == localizedName || item['ta'] == localizedName || item['ar'] == localizedName) {
            return item['en']!;
          }
        }
        return localizedName; // fallback
    }
  }

  void _showPicker<T>(
    BuildContext context,
    List<T> items,
    String title,
    ValueChanged<T> onItemSelected,
    String Function(T) itemToString,
    Function() onConfirm,
  ) {
    // Create a temporary variable for selection to avoid modifying state until confirmation
    T? tempSelection;

    // Set initial selection to first item but don't update state yet
    tempSelection = items.first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) => PickerWidget<T>(
        title: title,
        items: items,
        itemToString: itemToString,
        onItemSelected: (selectedItem) {
          // Update temporary selection
          tempSelection = selectedItem;
        },
        onConfirm: () {
          // Only update state when confirming
          onItemSelected(tempSelection as T);
          onConfirm();
        },
      ),
    );
  }

  void _onCountrySelected(String country) {
    setState(() {
      selectedCountry = country;
    });
  }

  void _onLanguageSelected(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  Future<void> _navigateIfBothSelected() async {
    if (finalCountry != null &&
        finalLanguage != null &&
        !widget.isFromSettings) {
      print("finalCountry: $finalCountry, finalLanguage: $finalLanguage");
      storage.setHiveValue("country", getEnglishName(finalCountry!));
      storage.setHiveValue("language", getEnglishName(finalLanguage!));
      await Future.delayed(const Duration(seconds: 1));
      final deviceId = await storage.getHiveValue("deviceId");
      navigator.navigateToReplacement(
        deviceId == null ? OnboardingScreen() : BottmTabBarScreen(),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    final storedCountry = await storage.getHiveValue("country");
    final storedLanguage = await storage.getHiveValue("language");

    setState(() {
      selectedCountry =
          storedCountry != null ? getLocalizedName(storedCountry) : null;
      selectedLanguage =
          storedLanguage != null ? getLocalizedName(storedLanguage) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countries = getLocalizedList('country');
    final languages = getLocalizedList('language');

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MHPSSLogoText(fontSize: 32),
            SizedBox(
              width: 170.w,
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.language,
                    title: finalCountry == null
                        ? selectedCountry ?? 'Country'.tr()
                        : getLocalizedName(getEnglishName(finalCountry!)),
                    onTap: () {
                      _showPicker(
                        context,
                        countries,
                        'select_country'.tr(),
                        _onCountrySelected,
                        (country) => country,
                        () {
                          setState(() {
                            // Now selectedCountry is updated only after confirmation
                            finalCountry = selectedCountry;
                            _navigateIfBothSelected();
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildOptionTile(
                    icon: Icons.translate,
                    title: finalLanguage == null
                        ? selectedLanguage ?? 'Language'.tr()
                        : getLocalizedName(getEnglishName(finalLanguage!)),
                    onTap: () {
                      _showPicker(
                        context,
                        languages,
                        'select_language'.tr(),
                        _onLanguageSelected,
                        (language) => language,
                        () {
                          setState(() {
                            // Now selectedLanguage is updated only after confirmation
                            finalLanguage = selectedLanguage;
                            _navigateIfBothSelected();

                            final englishName = getEnglishName(finalLanguage!);
                            if (englishName == 'English') {
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('en', 'US'));
                            } else if (englishName == 'Sinhala') {
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('si', 'LK'));
                            } else if (englishName == 'Tamil') {
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('ta', 'LK'));
                            } else if (englishName == 'Arabic') {
                              EasyLocalization.of(context)!
                                  .setLocale(const Locale('ar', 'AE'));
                            }
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.isFromSettings)
                    ElevatedButton(
                      onPressed: () async {
                        final countries = getLocalizedList('country');
                        final languages = getLocalizedList('language');

                        setState(() {
                          // Use existing selections or default to first item
                          finalCountry = finalCountry ??
                              selectedCountry ??
                              countries.first;
                          finalLanguage = finalLanguage ??
                              selectedLanguage ??
                              languages.first;

                          storage.setHiveValue(
                              "country", getEnglishName(finalCountry!));
                          storage.setHiveValue(
                              "language", getEnglishName(finalLanguage!));

                          final englishName = getEnglishName(finalLanguage!);
                          if (englishName == 'English') {
                            EasyLocalization.of(context)!
                                .setLocale(const Locale('en', 'US'));
                          } else if (englishName == 'Sinhala') {
                            EasyLocalization.of(context)!
                                .setLocale(const Locale('si', 'LK'));
                          } else if (englishName == 'Tamil') {
                            EasyLocalization.of(context)!
                                .setLocale(const Locale('ta', 'LK'));
                          } else if (englishName == 'Arabic') {
                            EasyLocalization.of(context)!
                                .setLocale(const Locale('ar', 'AE'));
                          }
                        });

                        final deviceId = await storage.getHiveValue("deviceId");
                        navigator.navigateToReplacement(
                          deviceId == null
                              ? OnboardingScreen()
                              : BottmTabBarScreen(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        padding: EdgeInsets.symmetric(horizontal: 34.0),
                        backgroundColor: AppColors.appWhiteColor,
                        minimumSize: Size(170.w, 40.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        "save_changes".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textBlackColor,
                        ),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 14.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
