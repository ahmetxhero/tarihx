import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> setupTimezone() async {
    tz.initializeTimeZones();
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
  }

  static Future<void> updateNotifications(bool enabled, int hour, int minute, Function(int) onSelectTab) async {
    if (enabled) {
      await setupNotifications(hour, minute, onSelectTab);
    } else {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  static Future<void> setupNotifications(int hour, int minute, Function(int) onSelectTab) async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
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
      final androidImpl = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.requestNotificationsPermission();
      await androidImpl?.requestExactAlarmsPermission();
    } else if (Platform.isIOS) {
      final iosImpl = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      await iosImpl?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    tz.initializeTimeZones();
    await _flutterLocalNotificationsPlugin.cancelAll();
    await _scheduleDailyNotification(hour, minute, tr('notification_today_title'), tr('notification_today_body'), 'today');
    int tomorrowHour = (hour + 10) % 24;
    await _scheduleDailyNotification(tomorrowHour, minute, tr('notification_tomorrow_title'), tr('notification_tomorrow_body'), 'tomorrow');
  }

  static Future<void> _scheduleDailyNotification(int hour, int minute, String title, String body, String payload) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: hour * 100 + minute,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails('tarihx_channel', 'TarihX Bildirimleri', importance: Importance.max, priority: Priority.high),
        iOS: DarwinNotificationDetails(),
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
