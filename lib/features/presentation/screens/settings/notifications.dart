import 'package:beprepared/core/resources/all_imports.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  bool isNotificationsOn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: tr("notifications"),
        isNotificationEnabled: isNotificationsOn,
        onChangeNotification: (value) {
          setState(() {
            isNotificationsOn = value;
            print("isNotificationsOn: $isNotificationsOn");
            storage.clearHiveAll();
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 36.h),
            _buildNotificationCard(
              isActive: isNotificationsOn,
              message: tr('notification_ignore'),
            ),
            SizedBox(height: 16.h),
            _buildNotificationCard(
              isActive: false,
              message: tr('new_message_15min'),
            ),
            SizedBox(height: 16.h),
            _buildNotificationCard(
              isActive: false,
              message: tr('new_message_2days'),
            ),
            SizedBox(height: 16.h),
            _buildNotificationCard(
              isActive: false,
              message: tr('new_message_4days'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard({
    required bool isActive,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isActive
                ? AppColors.appBlueColor
                : AppColors.searchFieldBorderColor,
            width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppImages.notificationBell,
            color: isActive
                ? AppColors.appBlackColor
                : AppColors.searchFieldBorderColor,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w400,
                color: isActive ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
