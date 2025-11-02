import 'package:beprepared/core/resources/all_imports.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  //initialising firebase message plugin
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  //initialising firebase message plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //function to initialise flutter local notification plugin to show notifications for android when app is active
  Future<void> initLocalNotifications(RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings =
        const DarwinInitializationSettings(requestBadgePermission: false);
    var initializationSetting = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      // handle interaction when app is active for android
      goToPageAfterMessage(message);
    });
  }

  Future<void> firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) async {
      print("Notification Received${message.data}");
      if (message.data['notificationType'] != null) {
        print("Notification Received${message.data}");
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification!.android;

      if (kDebugMode) {
        print("notifications title:${notification.title}");
        print("notifications body:${notification.body}");
        print('data:${message.data.toString()}');
      }
      print("token---> ccccccccccccc${message.data['notificationType']}");

      if (Platform.isIOS) {
        forgroundMessage();
      }

      if (Platform.isAndroid) {
        initLocalNotifications(message);
        showNotification(message);
      }
    });
  }

  Future<void> requestNotificationPermission() async {
    print("permission request====================");
    if (Platform.isIOS) {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');
        // Get APNs token
        String? apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) {
          print("APNs Token: $apnsToken");

          // Now get FCM token
          String? fcmToken = await messaging.getToken();
          print("FCM Token: $fcmToken");
        } else {
          print("APNs token not available");
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    }
  }

  // function to show visible notification when app is active
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: false,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('jetsons_doorbell'));

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('Channel ID', 'Channel title',
            priority: Priority.high,
            importance: Importance.max,
            ticker: 'test');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title.toString(),
        message.notification?.body.toString(),
        notificationDetails,
      );
    });
  }

  //function to get device token on which we will send the notifications
  Future getDeviceToken() async {
    log("we here here for token");
    try {
      String? token = await messaging.getToken();
      // final fcmToken = await storage.getHiveValue("FCMToken");
      print('FCM TOKEN $token');
      // print('fcmToken Storage: $fcmToken');
      // if (token != null) {
      //   // SharedPreferencesManger().saveUserFcmToken(token);

      //   storage.setHiveValue("FCMToken", token);
      // } else {
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print("APNs Token: $apnsToken");
      // }
    } catch (e) {
      log("we got an exception ${e.toString()}");
    }
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("event.toString()      ------      ${event.toString()}");
      refreshTokenApi(refreshToken: event.toString());
      if (kDebugMode) {
        print('refresh');
      }
    });
  }

  void refreshTokenApi({String? refreshToken}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Provider.of<AuthProvider>(navigatorKey.currentContext!, listen: false)
      //     .refreshToken(refreshToken: refreshToken);
    });
  }

  //handle tap on notification when app is in background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    // when app is terminated
    RemoteMessage? initialMessage = await messaging.getInitialMessage();

    if (initialMessage != null) {
      goToPageAfterMessage(initialMessage);
    }

    //when app ins background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      goToPageAfterMessage(event);
    });
  }

  void handleMessage(RemoteMessage message) {
    print("this is message handler");
    print('data:${message.data.toString()}');
  }

  Future forgroundMessage() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: false,
      sound: true,
    );
  }

  Future<void> goToPageAfterMessage(message) async {
    // ApiConst.isUserProfileFetch = true;
    // print("My Api Constant value is ${ApiConst.isUserProfileFetch}");

    log("why not this");
    print('<<<<<<<<<<<<<${message.data}');

    print('<<<<<<<<<<<<<${message.data['notificationType']}');
    print('<<<<<<<<<<<<<timestamp>>>>>>>>>>>>>${message.data['timestamp']}');

    // if (storage.isAppActive == false) {
    //   await AppFunctions.instance.bioMetricCheck();
    // }

    if (message.data['notificationType'] == 'callNotification') {
      print(
          '<<<<<<notificationType--callNotification>>>>>>>${message.data['notificationType']}');

      // final fcmToken =
      //     await AppFunctions().getDataInSharePreference('fcmToken');
      // print('<<<<<<fcmToken--callNotification>>>>>>>$fcmToken');
      // if (fcmToken == null) {
      //   return navigatorKey.currentState!.pushAndRemoveUntil(
      //       MaterialPageRoute(
      //         builder: (_) => const LoginScreen(),
      //       ),
      //       (Route<dynamic> route) => false);
      // }

      // navigatorKey.currentState!.pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => HomeScreen(
      //         notificationType: message.data['notificationType'],
      //         destinationNumber: message.data["destination_number"],
      //         uuid: message.data["uuid"],
      //         notificationBody: message.notification?.body,
      //         notificationTitle: message.notification?.title,
      //       ),
      //     ),
      //     (Route<dynamic> route) => false);
    } else if (message.data['notificationType'] == 'messageNotification') {
      print(
          '<<<<<<notificationType--messageNotification>>>>>${message.data['notificationType']}');
      int? number = int.tryParse(message.data["destination"]);
      // navigatorKey.currentState!.pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => MessagesScreen(
      //         convId: message.data["conversationId"],
      //         chatNumber: message.data["source"],
      //         isNotification: true,
      //         receivingName:
      //             number != null ? null : message.data["destination"],
      //         receivingNumber: number?.toString(),
      //       ),
      //     ),
      //     (Route<dynamic> route) => false);
    } else if (message.data['notificationType'] == 'failedCallNotification') {
      print(
          '<<<<<<notificationType--failedCallNotification>>>>>${message.data['notificationType']}');
      // navigatorKey.currentState!.pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => const NotificationScreen(
      //         isNotification: true,
      //       ),
      //     ),
      //     (Route<dynamic> route) => false);
    }
  }
}
