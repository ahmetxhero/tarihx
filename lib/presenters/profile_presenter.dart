import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../services/user_service.dart';

abstract class ProfileView {
  void onSettingsLoaded({
    required ThemeMode themeMode,
    required bool notificationsEnabled,
    required TimeOfDay notificationTime,
  });
  void onNotificationStatusChanged(bool enabled);
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
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    final hour = prefs.getInt('notification_hour') ?? 10;
    final minute = prefs.getInt('notification_minute') ?? 0;
    final time = TimeOfDay(hour: hour, minute: minute);

    view.onSettingsLoaded(
      themeMode: ThemeMode.system,
      notificationsEnabled: enabled,
      notificationTime: time,
    );

    await NotificationService.updateNotifications(enabled, hour, minute, onSelectTab);
  }

  Future<void> signInWithGoogle(Locale locale) async {
    try {
      final userCred = await AuthService.signInWithGoogle();
      if (userCred?.user != null) {
        await UserService.saveUserProfile(userCred!.user!, locale);
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
        view.onAuthSuccess(userCred.user!);
      }
    } catch (e) {
      view.onAuthError(e.toString());
    }
  }

  Future<void> signOut() async {
    await AuthService.signOut();
    view.onSignOut();
  }

  Future<void> syncUserProfile(User user, Locale locale) async {
    await UserService.saveUserProfile(user, locale);
  }

  Future<void> setNotificationsEnabled({
    required bool enabled,
    required TimeOfDay currentTime,
    required Function(int) onSelectTab,
  }) async {
    view.onNotificationStatusChanged(enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    await NotificationService.updateNotifications(enabled, currentTime.hour, currentTime.minute, onSelectTab);
  }

  Future<void> setNotificationTime({
    required TimeOfDay time,
    required bool notificationsEnabled,
    required Function(int) onSelectTab,
  }) async {
    view.onNotificationTimeChanged(time);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('notification_hour', time.hour);
    await prefs.setInt('notification_minute', time.minute);
    await NotificationService.updateNotifications(notificationsEnabled, time.hour, time.minute, onSelectTab);
  }
}
