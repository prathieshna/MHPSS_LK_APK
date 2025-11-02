import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/core/use%20cases/app_functions.dart';
import 'package:beprepared/features/presentation/screens/settings/setting_screen.dart';
import 'package:flutter/material.dart';

class BottmTabBarScreen extends ConsumerStatefulWidget {
  const BottmTabBarScreen({
    super.key,
    this.index = 0,
    this.navigateToSavedVehicle = false,
    this.navigateToEditShowroom = false,
  });
  final bool navigateToSavedVehicle;
  final bool navigateToEditShowroom;
  final int index;

  @override
  ConsumerState<BottmTabBarScreen> createState() => _BottmTabBarScreenState();
}

class _BottmTabBarScreenState extends ConsumerState<BottmTabBarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final _navigatorKeys = {
    TabItems.HomeBeprepared: GlobalKey<NavigatorState>(),
    TabItems.Favourites: GlobalKey<NavigatorState>(),
    TabItems.Downloads: GlobalKey<NavigatorState>(),
    TabItems.Settings: GlobalKey<NavigatorState>(),
  };

  bool showHideNavBar = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final deviceId = await AppFunctions.getdeviceId();
      await storage.setHiveValue("deviceId", deviceId);
      print("deviceId: $deviceId");
      ref.read(bottomNavProvider.notifier).setIndex(widget.index);
    });
    checkLanguage();
  }

  Future<void> checkLanguage() async {
    final selectedLanguage = await storage.getHiveValue("language");
    final selectedCountry = await storage.getHiveValue("country");
    final localLang = navigatorKey.currentContext!.locale.languageCode;

    print(
        "selectedLanguage: $selectedLanguage, localLang: $localLang, selectedCountry: $selectedCountry");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectTab(TabItems tabItem) {
    final currentTab = ref.read(bottomNavProvider);
    if (tabItem.index == currentTab) {
      final navigator = _navigatorKeys[tabItem]?.currentState;
      if (navigator != null && navigator.canPop()) {
        navigator.popUntil((route) => route.isFirst);
      }
    } else {
      _navigatorKeys.forEach((key, navigatorKey) {
        if (key != tabItem) {
          final navigator = navigatorKey.currentState;
          if (navigator != null && navigator.canPop()) {
            navigator.popUntil((route) => route.isFirst);
          }
        }
      });

      // Update the current tab index
      ref.read(bottomNavProvider.notifier).setIndex(tabItem.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = ref.watch(bottomNavProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator =
            _navigatorKeys[TabItems.values[currentTab]]!.currentState!;
        final canPop = navigator.canPop();

        if (canPop) {
          navigator.pop();
        } else {
          if (currentTab != 0) {
            _selectTab(TabItems.HomeBeprepared);
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.appWhiteColor,
        body: IndexedStack(
          index: currentTab,
          children: <Widget>[
            _buildOffstageNavigator(TabItems.HomeBeprepared, 0),
            _buildOffstageNavigator(TabItems.Favourites, 1),
            _buildOffstageNavigator(TabItems.Downloads, 2),
            _buildOffstageNavigator(TabItems.Settings, 3),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(onTabSelected: _selectTab),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItems tabItem, int index) {
    final currentTab = ref.watch(bottomNavProvider);
    return Offstage(
      offstage: currentTab != index,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
        index: index,
      ),
    );
  }
}

class CustomBottomNavBar extends ConsumerWidget {
  final Function(TabItems) onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          size: Size(ScreenUtil().screenWidth, 70.h),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.1, 0.9],
              colors: AppColors.appGradientColors,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
            ),
          ),
          height: 75.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(context, ref, AppImages.homeIconSVG, tr("home"),
                  TabItems.HomeBeprepared),
              _buildNavItem(context, ref, AppImages.favouriteIconSVG,
                  tr("favourites"), TabItems.Favourites),
              _buildNavItem(context, ref, AppImages.downloadIconSVG,
                  tr("downloads"), TabItems.Downloads),
              _buildNavItem(context, ref, AppImages.settingIcon, tr("settings"),
                  TabItems.Settings),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(BuildContext context, WidgetRef ref, String icon,
      String label, TabItems tabItem) {
    final selectedIndex = ref.watch(bottomNavProvider);
    final isSelected = selectedIndex == tabItem.index;

    return GestureDetector(
      onTap: () => onTabSelected(tabItem),
      child: Container(
        width: MediaQuery.of(context).size.width / 4,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: isSelected
                  ? AppColors.appWhiteColor
                  : AppColors.navBarGreyIconColor,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppColors.appWhiteColor
                    : AppColors.navBarGreyIconColor,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    super.key,
    required this.navigatorKey,
    required this.tabItem,
    required this.index,
  });

  final GlobalKey<NavigatorState>? navigatorKey;
  final TabItems tabItem;
  final int index;

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context) {
    return {
      TabNavigatorRoutes.root: (context) => _getScreen(index),
    };
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const FavouritesScreen();
      case 2:
        return const DownloadsScreen();
      case 3:
        return const SettingScreen();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders(context);
    return Navigator(
      key: navigatorKey,
      initialRoute: TabNavigatorRoutes.root,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => routeBuilders[routeSettings.name!]!(context),
        );
      },
    );
  }
}

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

enum TabItems {
  HomeBeprepared,
  Favourites,
  Downloads,
  Settings,
}
