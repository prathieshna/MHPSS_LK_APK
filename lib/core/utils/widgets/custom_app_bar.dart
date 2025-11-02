import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/presentation/screens/settings/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as painting;

class CustomAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final String? title;
  final double? height;
  final Widget? leadingWidget;
  final Widget? trailing;
  final bool? isFliter;
  final bool? isRemoveBottom;
  final bool isBack;
  final bool isNotificationEnabled;
  final TextEditingController? controller;
  final bool isFavoriteSearch;
  final Function(String)? onSearch;
  final Function()? onFliter;
  final Function()? onBack;
  final Function()? onSetting;
  final Function()? onNotification;
  final Function(bool)? onChangeNotification;

  const CustomAppBar({
    super.key,
    this.title,
    this.height,
    this.leadingWidget,
    this.trailing,
    this.isFliter = false,
    this.isRemoveBottom = false,
    this.isBack = false,
    this.isNotificationEnabled = true,
    this.isFavoriteSearch = false,
    this.controller,
    this.onSearch,
    this.onFliter,
    this.onBack,
    this.onSetting,
    this.onNotification,
    this.onChangeNotification,
  });
  static const double appBarHeight = 175.0;

  @override
  ConsumerState<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class _CustomAppBarState extends ConsumerState<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    //   double width = MediaQuery.of(context).size.width - 16.0;
    //   final TextEditingController menuController = TextEditingController();
    //   MenuItem? selectedMenu;
    return Container(
      height: widget.isRemoveBottom == true
          ? CustomAppBar.appBarHeight - 70
          : widget.height ?? CustomAppBar.appBarHeight,
      decoration:
          const BoxDecoration(color: AppColors.appBarBottomColor, boxShadow: [
        BoxShadow(
          color: AppColors.tagColor,
          blurRadius: 10,
        )
      ]),
      child: Column(
        children: [
          // Gradient AppBar
          Directionality(
            textDirection: painting.TextDirection.ltr,
            child: Container(
              height: widget.height ?? CustomAppBar.appBarHeight - 70,
              padding: EdgeInsets.only(bottom: 18.h, top: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10.r),
                ),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: AppColors.appGradientColors),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      widget.leadingWidget ??
                          Flexible(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'mhpss.lk',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      widget.trailing ?? SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.isRemoveBottom == false)
            SizedBox(
              height: 16.h,
            ),
          if (widget.isRemoveBottom == false)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: widget.title != null
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.h),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isBack
                              ? GestureDetector(
                                  onTap: () {
                                    navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 44.w,
                                    color: Colors.transparent,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 12.h),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: SvgPicture.asset(
                                        AppImages.backSvg,
                                        width: 10.w,
                                      ),
                                    ),
                                  ))
                              : SizedBox(),
                          Center(
                            child: Text(widget.title!,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                          ),
                          widget.onChangeNotification == null
                              ? SizedBox(width: 22.w)
                              : SizedBox(
                                  height: 10.h,
                                  // width: 30.w,
                                  // padding:
                                  //     EdgeInsets.only(right: 24.w, left: 24.w),
                                  child: Switch(
                                    inactiveTrackColor: AppColors.tagColor,
                                    focusColor: AppColors.tagColor,
                                    activeThumbColor: AppColors.textBlueColor,
                                    value: widget.isNotificationEnabled,
                                    onChanged: widget.onChangeNotification,
                                  ),
                                ),
                        ],
                      ),
                    )
                  : Row(
                      children: [
                        if (widget.isBack)
                          GestureDetector(
                            onTap: widget.onBack ??
                                () {
                                  navigator.pop(context);
                                },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.appBlackColor,
                            ),
                          ),
                        Expanded(
                            child: widget.isFavoriteSearch
                                ? CustomSearchField(
                                    controller: widget.controller,
                                    onChanged: widget.onSearch,
                                    hintText: "search".tr(),
                                  )
                                : SearchDropdown()),

                        if (widget.isFliter == true)
                          Row(
                            children: [
                              SizedBox(width: 16.w),
                              GestureDetector(
                                onTap: widget.onFliter ?? () {},
                                child: SvgPicture.asset(
                                  AppImages.filterIcon,
                                ),
                              ),
                            ],
                          ),
                        SizedBox(width: 16.w),
                        // Notification Icon with Badge
                        GestureDetector(
                          onTap: widget.onNotification ??
                              () {
                                navigator.navigateToWithBottomNavBar(
                                    context, const NotificationsScreen());
                              },
                          child: SvgPicture.asset(
                            AppImages.notificationsIcon,
                          ),
                        ),
                        // Settings Icon
                        // if (widget.isFliter == false)
                        //   Row(
                        //     children: [
                        //       SizedBox(width: 16.w),
                        //       GestureDetector(
                        //         onTap: widget.onSetting ??
                        //             () {
                        //               navigator.navigateToWithBottomNavBar(
                        //                   context, const SettingScreen());
                        //             },
                        //         child: SvgPicture.asset(
                        //           AppImages.settingIcon,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}

// class MenuItem {
//   final int id;
//   final String label;
//   final IconData icon;

//   MenuItem(this.id, this.label, this.icon);
// }

// List<MenuItem> menuItems = [
//   MenuItem(1, 'Home', Icons.home),
//   MenuItem(2, 'Profile', Icons.person),
//   MenuItem(3, 'Settings', Icons.settings),
//   MenuItem(4, 'Favorites', Icons.favorite),
//   MenuItem(5, 'Notifications', Icons.notifications),
//   MenuItem(6, 'Homeeeee', Icons.home),
// ];
