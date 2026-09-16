import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  /// Log user login with auth method ('google', 'apple', etc.)
  static Future<void> logLogin({required String loginMethod}) async {
    try {
      await _analytics.logLogin(loginMethod: loginMethod);
      debugPrint('Analytics: Login logged with method: $loginMethod');
    } catch (e) {
      debugPrint('Analytics Error (logLogin): $e');
    }
  }

  /// Log user sign out
  static Future<void> logSignOut() async {
    try {
      await _analytics.logEvent(name: 'sign_out');
      debugPrint('Analytics: Sign out logged');
    } catch (e) {
      debugPrint('Analytics Error (logSignOut): $e');
    }
  }

  /// Log screen view manually
  static Future<void> logScreenView({required String screenName, String? screenClass}) async {
    try {
      await _analytics.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
      debugPrint('Analytics: Screen view logged: $screenName');
    } catch (e) {
      debugPrint('Analytics Error (logScreenView): $e');
    }
  }

  /// Set User ID for analytics tracking
  static Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      debugPrint('Analytics: User ID set to $userId');
    } catch (e) {
      debugPrint('Analytics Error (setUserId): $e');
    }
  }

  /// Set User Property (e.g., preferred_language, platform)
  static Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
      debugPrint('Analytics: User property set -> $name: $value');
    } catch (e) {
      debugPrint('Analytics Error (setUserProperty): $e');
    }
  }

  /// Log custom event
  static Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
  }) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
      debugPrint('Analytics: Event logged -> $name, params: $parameters');
    } catch (e) {
      debugPrint('Analytics Error (logEvent): $e');
    }
  }
}
