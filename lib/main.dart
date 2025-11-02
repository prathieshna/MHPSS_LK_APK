import 'package:beprepared/beprepared.dart';
import 'package:beprepared/core/resources/all_imports.dart';
import 'package:beprepared/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  // Environment
  await dotenv.load(fileName: ".env");

  // Dependency Injection
  await DependencyInjectionEnvironment.setup();

  // Firebase Init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase notification
  // await appFunctions.notificationPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // App Orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final selectedLanguage = await storage.getHiveValue("language");
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('si', 'LK'), Locale('ta', 'LK'), Locale('ar', 'AE')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en', 'US'),
        startLocale: selectedLanguage == "Sinhala"
            ? Locale('si', 'LK')
            : selectedLanguage == "Tamil"
            ? Locale('ta', 'LK')
            : selectedLanguage == "Arabic"
            ? Locale('ar', 'AE')
            : const Locale('en', 'US'),
        child: const ProviderScope(
          child: MHPSSApp(),
        ),
      ),
    ),
  );
}
