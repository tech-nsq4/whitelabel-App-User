import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../utils/app_colors.dart';

/// Registered via `FirebaseMessaging.onBackgroundMessage` in `main.dart`.
/// Must be a top-level/static function (`@pragma('vm:entry-point')`) since
/// it runs in its own isolate when the app is backgrounded/terminated.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  // مفيش حاجة نعملها هنا: فايربيز بيعرض الإشعار تلقائي لما التطبيق يكون
  // في الباك جراوند/مقفول ولو الـ payload فيه "notification" block.
}

const _channelId = 'vivacare_default';
const _channelName = 'Vivacare';
const _channelDesc = 'Vivacare notifications';
const _androidNotificationIcon = 'ic_stat_notification';

/// Wires up FCM (push receiving) + `flutter_local_notifications` (foreground
/// display, since Android/iOS don't show a system banner for a message that
/// arrives while the app is open). Call [init] once, right after
/// `Firebase.initializeApp()` + `FirebaseMessaging.onBackgroundMessage(...)`
/// in `main.dart`.
class NotificationService {
  NotificationService._();

  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    final res =await FirebaseMessaging.instance.getToken();
    print('FCM token: $res');
    await _requestPermissions();
    await _initPlugin();
    await _createAndroidChannel();
    _listenForeground();
  }

  static Future<void> _requestPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static Future<void> _initPlugin() async {
    const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    await _plugin.initialize(settings);
  }

  static Future<void> _createAndroidChannel() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    const channel = AndroidNotificationChannel(
      _channelId, _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );
    await androidPlugin?.createNotificationChannel(channel);
  }

  /// Only Android needs this: iOS already shows a system banner for a
  /// foreground message via `setForegroundNotificationPresentationOptions`
  /// above, so re-displaying it here would double it up.
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isIOS) return;
      final notification = message.notification;
      if (notification == null) return;
      _plugin.show(
        notification.hashCode, notification.title, notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId, _channelName,
            channelDescription: _channelDesc,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            icon: _androidNotificationIcon,
            color: AppColors.primaryColor.light,
          ),
        ),
      );
    });
  }
}
