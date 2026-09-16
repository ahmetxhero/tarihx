import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'presenters/profile_presenter.dart';
import 'services/notification_service.dart';
import 'views/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['4d857f2cc42f85b06387ad053af79a68']),
  );
  await EasyLocalization.ensureInitialized();
  await NotificationService.setupTimezone();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('tr'),
        Locale('en'),
        Locale('de'),
        Locale('fr'),
        Locale('es'),
        Locale('it'),
        Locale('ru'),
        Locale('uk'),
        Locale('zh'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('tr'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> implements ProfileView {
  late final ProfilePresenter _presenter;
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 10, minute: 0);
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _presenter = ProfilePresenter(this);
    _presenter.loadSettings((tab) {
      setState(() {
        _selectedTab = tab;
      });
    });
  }

  @override
  void onSettingsLoaded({
    required ThemeMode themeMode,
    required bool notificationsEnabled,
    required TimeOfDay notificationTime,
  }) {
    setState(() {
      _themeMode = themeMode;
      _notificationsEnabled = notificationsEnabled;
      _notificationTime = notificationTime;
    });
  }

  @override
  void onNotificationStatusChanged(bool enabled) {
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  @override
  void onNotificationTimeChanged(TimeOfDay time) {
    setState(() {
      _notificationTime = time;
    });
  }

  @override
  void onThemeModeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  void onAuthSuccess(User user) {}

  @override
  void onAuthError(String message) {}

  @override
  void onSignOut() {}

  void setThemeMode(ThemeMode mode) {
    onThemeModeChanged(mode);
  }

  void setNotificationsEnabled(bool enabled) async {
    await _presenter.setNotificationsEnabled(
      enabled: enabled,
      currentTime: _notificationTime,
      onSelectTab: (tab) => setState(() => _selectedTab = tab),
    );
  }

  void setNotificationTime(TimeOfDay time) async {
    await _presenter.setNotificationTime(
      time: time,
      notificationsEnabled: _notificationsEnabled,
      onSelectTab: (tab) => setState(() => _selectedTab = tab),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => tr('app_title'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MainScreen(
        themeMode: _themeMode,
        onThemeModeChanged: setThemeMode,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: setNotificationsEnabled,
        notificationTime: _notificationTime,
        onNotificationTimeChanged: setNotificationTime,
        selectedTab: _selectedTab,
        onTabSelected: (tab) => setState(() => _selectedTab = tab),
      ),
    );
  }
}
