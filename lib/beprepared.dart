import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/features/data/models/data%20query/graphql_query.dart';
import 'package:beprepared/features/domain/repositories/local_notifications_handler.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MHPSSApp extends StatefulWidget {
  const MHPSSApp({super.key});

  @override
  State<MHPSSApp> createState() => _MHPSSAppState();
}

class _MHPSSAppState extends State<MHPSSApp> {
  final NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    initializeNotificationServices(context);
  }

  Future<void> initializeNotificationServices(BuildContext context) async {
    print("initializeNotificationServices");

    await notificationServices.requestNotificationPermission();
    await notificationServices.getDeviceToken();
    await notificationServices.forgroundMessage();
    await notificationServices.firebaseInit(context);
    await notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: const Size(375, 812),
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GraphQLProvider(
          client: client,
          child: MaterialApp(
            title: 'MHPSS.lk',
            debugShowCheckedModeBanner: false,

            theme: AppTheme.lightTheme(context, context.locale),
            // darkTheme: AppTheme.darkTheme(context, locale),
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            navigatorKey: navigatorKey,
            home: const SplashScreen(),
          ),
        ),
      ),
    );
  }
}
