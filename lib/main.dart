import 'package:easy_localization/easy_localization.dart' as tr;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/services/notification_service.dart';
import 'firebase_options.dart';
///18/8/2026
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await tr.EasyLocalization.ensureInitialized();
  await setupDi();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler);
  await NotificationService.init();

  runApp(
    tr.EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('ar'),
      child: const SafeArea(top: false, child: MyApp()),
    ),
  );
}
