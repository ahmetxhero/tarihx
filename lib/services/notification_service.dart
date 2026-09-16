import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('Handling FCM background message: ${message.messageId}');
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'tarihx_channel',
    'TarihX Bildirimleri',
    description: 'Günlük tarih olayları ve duyuru bildirimleri',
    importance: Importance.max,
  );

  /// Request notification permissions on first app launch (iOS + Android 13+)
  static Future<void> requestInitialPermissions() async {
    try {
      // Request FCM authorization (triggers iOS system dialog)
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      debugPrint('FCM Permission status: ${settings.authorizationStatus}');

      // Android 13+ (API 33) requires POST_NOTIFICATIONS runtime permission
      if (Platform.isAndroid) {
        final androidImpl = _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidImpl?.createNotificationChannel(_channel);
        await androidImpl?.requestNotificationsPermission();
        await androidImpl?.requestExactAlarmsPermission();
      }

      // Initialize the local notification plugin early for both platforms
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );
      await _flutterLocalNotificationsPlugin.initialize(settings: initSettings);
    } catch (e) {
      debugPrint('Notification permission request error: $e');
    }
  }

  /// Initialize FCM Background/Foreground Listeners & Presentation Options
  static Future<void> initFCM(Function(int)? onSelectTab) async {
    try {
      // Background message handler
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Foreground presentation options for iOS
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Listen for foreground FCM messages and trigger local notification banner
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        final android = message.notification?.android;
        if (notification != null) {
          _flutterLocalNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: android?.smallIcon ?? '@mipmap/ic_launcher',
                importance: Importance.max,
                priority: Priority.high,
              ),
              iOS: const DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: message.data['payload'] ?? 'today',
          );
        }
      });

      // Handle notification click when app is in background but opened
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        final payload = message.data['payload'];
        if (onSelectTab != null) {
          if (payload == 'tomorrow') {
            onSelectTab(1);
          } else {
            onSelectTab(0);
          }
        }
      });

      // Handle notification click when app was completely terminated
      final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null && onSelectTab != null) {
        final payload = initialMessage.data['payload'];
        if (payload == 'tomorrow') {
          onSelectTab(1);
        } else {
          onSelectTab(0);
        }
      }
    } catch (e) {
      debugPrint('FCM Init Error: $e');
    }
  }

  /// Setup local time zone
  static Future<void> setupTimezone() async {
    try {
      tz.initializeTimeZones();
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
      debugPrint('Local timezone successfully set to: ${timezoneInfo.identifier}');
    } catch (e) {
      debugPrint('Error setting local timezone: $e');
    }
  }

  /// Update scheduled notifications based on user setting
  static Future<void> updateNotifications(
      bool enabled, int hour, int minute, Function(int) onSelectTab) async {
    if (enabled) {
      await setupNotifications(hour, minute, onSelectTab);
    } else {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  /// Initialize local notification plugin and schedule daily notifications
  static Future<void> setupNotifications(
      int hour, int minute, Function(int) onSelectTab) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload == 'today') {
          onSelectTab(0);
        } else if (details.payload == 'tomorrow') {
          onSelectTab(1);
        }
      },
    );

    if (Platform.isAndroid) {
      final androidImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.createNotificationChannel(_channel);
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      final iosImpl = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    await setupTimezone();
    await _flutterLocalNotificationsPlugin.cancelAll();
    await _scheduleDailyNotification(
      hour,
      minute,
      tr('notification_today_title'),
      tr('notification_today_body'),
      'today',
    );
    int tomorrowHour = (hour + 10) % 24;
    await _scheduleDailyNotification(
      tomorrowHour,
      minute,
      tr('notification_tomorrow_title'),
      tr('notification_tomorrow_body'),
      'tomorrow',
    );
  }

  static Future<void> _scheduleDailyNotification(
      int hour, int minute, String title, String body, String payload) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: hour * 100 + minute,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
