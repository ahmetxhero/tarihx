import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/analytics_service.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';

abstract class ProfileView {
  void onSettingsLoaded({
    required ThemeMode themeMode,
    required bool notificationsEnabled,
    required bool localNotificationsEnabled,
    required TimeOfDay notificationTime,
  });
  void onNotificationStatusChanged(bool enabled);
  void onLocalNotificationStatusChanged(bool enabled);
  void onNotificationTimeChanged(TimeOfDay time);
  void onThemeModeChanged(ThemeMode mode);
  void onAuthSuccess(User user);
  void onAuthError(String message);
  void onSignOut();
}

class ProfilePresenter {
  final ProfileView view;

  ProfilePresenter(this.view);

  Future<void> loadSettings(Function(int) onSelectTab) async {
    final prefs = await SharedPreferences.getInstance();
    final fcmEnabled = prefs.getBool('notifications_enabled') ?? true;
    final localEnabled = prefs.getBool('local_notifications_enabled') ?? true;
    final hour = prefs.getInt('notification_hour') ?? 10;
    final minute = prefs.getInt('notification_minute') ?? 0;
    final time = TimeOfDay(hour: hour, minute: minute);

    view.onSettingsLoaded(
      themeMode: ThemeMode.system,
      notificationsEnabled: fcmEnabled,
      localNotificationsEnabled: localEnabled,
      notificationTime: time,
    );

    // Setup local notifications if enabled
    if (localEnabled) {
      await NotificationService.updateNotifications(true, hour, minute, onSelectTab);
    }

    // Update FCM token if enabled
    if (fcmEnabled) {
      await UserService.updateFcmToken();
    }
  }

  Future<void> signInWithGoogle(Locale locale) async {
    try {
      final userCred = await AuthService.signInWithGoogle();
      if (userCred?.user != null) {
        await UserService.saveUserProfile(userCred!.user!, locale);
        await AnalyticsService.logLogin(loginMethod: 'google');
        view.onAuthSuccess(userCred.user!);
      }
    } catch (e) {
      view.onAuthError(e.toString());
    }
  }

  Future<void> signInWithApple(Locale locale) async {
    try {
      final userCred = await AuthService.signInWithApple();
      if (userCred?.user != null) {
        await UserService.saveUserProfile(userCred!.user!, locale);
        await AnalyticsService.logLogin(loginMethod: 'apple');
        view.onAuthSuccess(userCred.user!);
      }
    } catch (e) {
      view.onAuthError(e.toString());
    }
  }

  Future<void> signOut() async {
    await AnalyticsService.logSignOut();
    await AnalyticsService.setUserId(null);
    await AuthService.signOut();
    view.onSignOut();
  }

  Future<void> syncUserProfile(User user, Locale locale) async {
    await UserService.saveUserProfile(user, locale);
  }

  /// Toggle FCM push notifications — writes/deletes FCM token in Firestore
  Future<void> setNotificationsEnabled({
    required bool enabled,
  }) async {
    view.onNotificationStatusChanged(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);

    if (enabled) {
      await UserService.updateFcmToken();
    } else {
      await UserService.removeFcmToken();
    }
  }

  /// Toggle local daily notifications
  Future<void> setLocalNotificationsEnabled({
    required bool enabled,
    required TimeOfDay currentTime,
    required Function(int) onSelectTab,
  }) async {
    view.onLocalNotificationStatusChanged(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('local_notifications_enabled', enabled);
    await NotificationService.updateNotifications(enabled, currentTime.hour, currentTime.minute, onSelectTab);
  }

  Future<void> setNotificationTime({
    required TimeOfDay time,
    required bool localNotificationsEnabled,
    required Function(int) onSelectTab,
  }) async {
    view.onNotificationTimeChanged(time);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', time.hour);
    await prefs.setInt('notification_minute', time.minute);
    await NotificationService.updateNotifications(localNotificationsEnabled, time.hour, time.minute, onSelectTab);
  }
}
