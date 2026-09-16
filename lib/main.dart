import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    WebViewPlatform.instance = AndroidWebViewPlatform();
  }
  await MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  tz.initializeTimeZones();
  await setupTimezone();
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

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    // Bildirim ayarını kaydetmek için SharedPreferences kullan
    SharedPreferences.getInstance().then((prefs) {
      final enabled = prefs.getBool('notifications_enabled') ?? true;
      setState(() {
        _notificationsEnabled = enabled;
      });
      updateNotifications(enabled, (tab) {
        setState(() {
          _selectedTab = tab;
        });
      });
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void setNotificationsEnabled(bool enabled) async {
    setState(() {
      _notificationsEnabled = enabled;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    await updateNotifications(enabled, (tab) {
      setState(() {
        _selectedTab = tab;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String fontFamily = 'Inter';
    const lightColorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF6750A4), // Modern mor
      onPrimary: Colors.white,
      secondary: Color(0xFF0066CC), // Modern mavi
      onSecondary: Colors.white,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      surface: Color(0xFFF5F5FA), // Yumuşak açık gri
      onSurface: Color(0xFF1C1B1F),
    );
    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF8D7FC7), // Açık mor
      onPrimary: Color(0xFF1C1B1F),
      secondary: Color(0xFF66A6FF), // Açık mavi
      onSecondary: Color(0xFF1C1B1F),
      error: Color(0xFFF2B8B5),
      onError: Color(0xFF601410),
      surface: Color(0xFF232336),
      onSurface: Colors.white,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: tr('app_title'),
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        fontFamily: fontFamily,
        textTheme: ThemeData.light().textTheme.apply(fontFamily: fontFamily),
        cardTheme: CardThemeData(
          color: lightColorScheme.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: lightColorScheme.surface,
          indicatorColor: lightColorScheme.primary.withValues(alpha: 0.1),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: lightColorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(lightColorScheme.primary),
          trackColor: WidgetStateProperty.all(lightColorScheme.primary.withValues(alpha: 0.3)),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return lightColorScheme.primary.withValues(alpha: 0.15);
              }
              return lightColorScheme.surface;
            }),
            foregroundColor: WidgetStateProperty.all(lightColorScheme.primary),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        fontFamily: fontFamily,
        textTheme: ThemeData.dark().textTheme.apply(fontFamily: fontFamily),
        cardTheme: CardThemeData(
          color: darkColorScheme.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
          elevation: 0,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkColorScheme.surface,
          indicatorColor: darkColorScheme.primary.withValues(alpha: 0.15),
          labelTextStyle: WidgetStateProperty.all(
            TextStyle(color: darkColorScheme.primary, fontWeight: FontWeight.w600),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(darkColorScheme.primary),
          trackColor: WidgetStateProperty.all(darkColorScheme.primary.withValues(alpha: 0.3)),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return darkColorScheme.primary.withValues(alpha: 0.25);
              }
              return darkColorScheme.surface;
            }),
            foregroundColor: WidgetStateProperty.all(darkColorScheme.primary),
          ),
        ),
      ),
      themeMode: _themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: MainScreen(
        themeMode: _themeMode,
        onThemeModeChanged: setThemeMode,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: setNotificationsEnabled,
        selectedTab: _selectedTab,
        onTabSelected: (tab) => setState(() => _selectedTab = tab),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;

  const MainScreen({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    this.selectedTab = 0,
    required this.onTabSelected,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      TodayPage(),
      TomorrowPage(),
      SettingsPage(
        themeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
        notificationsEnabled: widget.notificationsEnabled,
        onNotificationsChanged: widget.onNotificationsChanged,
      ),
    ];
    return Scaffold(
      body: pages[widget.selectedTab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.selectedTab,
        onDestinationSelected: widget.onTabSelected,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today),
            label: tr('today'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today),
            label: tr('tomorrow'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: tr('settings'),
          ),
        ],
      ),
    );
  }
}

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return WikiEventsList(
      day: now.day,
      month: now.month,
      locale: context.locale,
      title: tr('today_page'),
    );
  }
}

class TomorrowPage extends StatelessWidget {
  const TomorrowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return WikiEventsList(
      day: tomorrow.day,
      month: tomorrow.month,
      locale: context.locale,
      title: tr('tomorrow_page'),
    );
  }
}

class WikiEventsList extends StatefulWidget {
  final int day;
  final int month;
  final Locale locale;
  final String title;
  const WikiEventsList({super.key, required this.day, required this.month, required this.locale, required this.title});

  @override
  State<WikiEventsList> createState() => _WikiEventsListState();
}

class _WikiEventsListState extends State<WikiEventsList> {
  late Future<List<WikiEvent>> _futureEvents;

  @override
  void initState() {
    super.initState();
    _futureEvents = fetchWikiEvents(widget.day, widget.month, widget.locale);
    InterstitialAdManager.loadAd(null);
  }

  @override
  void didUpdateWidget(covariant WikiEventsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day || oldWidget.month != widget.month || oldWidget.locale != widget.locale) {
      _futureEvents = fetchWikiEvents(widget.day, widget.month, widget.locale);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<WikiEvent>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kayıt bulunamadı.'));
          }
          final events = snapshot.data!;
          // Banner reklamlarının gösterileceği event indexleri (1 tabanlı): 3, 8, 16, 26, 35, 50
          final bannerIndexes = [3, 8, 16, 26, 35, 50];
          final itemCount = events.length + bannerIndexes.where((i) => i <= events.length).length;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: itemCount,
            itemBuilder: (context, i) {
              // Banner eklenmesi gereken pozisyonları hesapla
              int eventIndex = i;
              int bannerCount = 0;
              for (final bIndex in bannerIndexes) {
                if (i == bIndex + bannerCount) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: BannerAdWidget(adUnitId: bannerAdUnitId),
                  );
                }
                if (i > bIndex + bannerCount) {
                  bannerCount++;
                  eventIndex--;
                }
              }
              if (eventIndex >= events.length) return const SizedBox.shrink();
              final event = events[eventIndex];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    int openCount = prefs.getInt('detail_open_count') ?? 0;
                    openCount++;
                    await prefs.setInt('detail_open_count', openCount);
                    debugPrint('DEBUG: detail_open_count = $openCount');
                    final adShowIndexes = [1, 3, 7, 10];
                    if (!context.mounted) return;
                    if (adShowIndexes.contains(openCount)) {
                      bool navigated = false;
                      void navigateOnce() {
                        if (navigated || !context.mounted) return;
                        navigated = true;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WikiEventDetailPage(event: event),
                          ),
                        );
                      }
                      RewardedInterstitialAdManager.loadAd(
                        onRewarded: navigateOnce,
                        onClosed: navigateOnce,
                        onFailed: navigateOnce,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WikiEventDetailPage(event: event),
                        ),
                      );
                    }
                  },
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 72),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withValues(alpha: 0.98),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (event.imageUrl != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              event.imageUrl!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, size: 40),
                            ),
                          )
                        else
                          Icon(Icons.event, size: 40),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            event.text,
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          event.year.toString(),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WikiEvent {
  final int year;
  final String text;
  final String? pageUrl;
  final String? imageUrl;
  WikiEvent({required this.year, required this.text, this.pageUrl, this.imageUrl});
}

Future<List<WikiEvent>> fetchWikiEvents(int day, int month, Locale locale) async {
  final lang = _wikiLang(locale);
  final url = 'https://$lang.wikipedia.org/api/rest_v1/feed/onthisday/events/${month.toString().padLeft(2, '0')}/$day';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode != 200) {
    throw Exception('Wikipedia API hatası: ${response.statusCode}');
  }
  final data = json.decode(response.body);
  final List events = data['events'] ?? [];
  return events.map<WikiEvent>((e) {
    final year = e['year'] ?? 0;
    final text = (e['text'] ?? '').toString();
    String? pageUrl;
    String? imageUrl;
    if (e['pages'] != null && e['pages'].isNotEmpty) {
      final page = e['pages'][0];
      if (page['content_urls'] != null && page['content_urls']['desktop'] != null) {
        pageUrl = page['content_urls']['desktop']['page'];
      }
      if (page['thumbnail'] != null && page['thumbnail']['source'] != null) {
        imageUrl = page['thumbnail']['source'];
      }
    }
    return WikiEvent(year: year, text: text, pageUrl: pageUrl, imageUrl: imageUrl);
  }).toList();
}

String _wikiLang(Locale locale) {
  switch (locale.languageCode) {
    case 'en': return 'en';
    case 'ceb': return 'ceb';
    case 'de': return 'de';
    case 'fr': return 'fr';
    case 'sv': return 'sv';
    case 'nl': return 'nl';
    case 'ru': return 'ru';
    case 'es': return 'es';
    case 'it': return 'it';
    case 'pl': return 'pl';
    case 'arz': return 'arz';
    case 'zh': return 'zh';
    case 'ja': return 'ja';
    case 'uk': return 'uk';
    case 'vi': return 'vi';
    case 'ar': return 'ar';
    case 'war': return 'war';
    case 'pt': return 'pt';
    case 'fa': return 'fa';
    case 'ca': return 'ca';
    case 'id': return 'id';
    case 'ko': return 'ko';
    case 'sr': return 'sr';
    case 'no': return 'no';
    case 'tr': return 'tr';
    case 'ce': return 'ce';
    case 'fi': return 'fi';
    case 'cs': return 'cs';
    case 'hu': return 'hu';
    case 'ro': return 'ro';
    case 'tt': return 'tt';
    case 'eu': return 'eu';
    case 'sh': return 'sh';
    case 'zh-min-nan': return 'zh-min-nan';
    case 'ms': return 'ms';
    case 'he': return 'he';
    case 'eo': return 'eo';
    case 'hy': return 'hy';
    case 'da': return 'da';
    case 'bg': return 'bg';
    case 'uz': return 'uz';
    case 'cy': return 'cy';
    case 'simple': return 'simple';
    case 'el': return 'el';
    case 'be': return 'be';
    case 'sk': return 'sk';
    case 'et': return 'et';
    case 'azb': return 'azb';
    case 'kk': return 'kk';
    case 'ur': return 'ur';
    case 'min': return 'min';
    case 'hr': return 'hr';
    case 'gl': return 'gl';
    case 'lt': return 'lt';
    case 'az': return 'az';
    case 'sl': return 'sl';
    case 'ka': return 'ka';
    case 'lld': return 'lld';
    case 'nn': return 'nn';
    case 'ta': return 'ta';
    case 'th': return 'th';
    case 'bn': return 'bn';
    case 'hi': return 'hi';
    case 'mk': return 'mk';
    case 'zh-yue': return 'zh-yue';
    case 'la': return 'la';
    case 'ast': return 'ast';
    case 'lv': return 'lv';
    case 'af': return 'af';
    case 'tg': return 'tg';
    case 'te': return 'te';
    case 'my': return 'my';
    case 'sq': return 'sq';
    case 'mg': return 'mg';
    case 'sw': return 'sw';
    case 'mr': return 'mr';
    case 'bs': return 'bs';
    case 'ku': return 'ku';
    case 'oc': return 'oc';
    case 'be-tarask': return 'be-tarask';
    case 'br': return 'br';
    case 'ml': return 'ml';
    case 'nds': return 'nds';
    case 'lmo': return 'lmo';
    case 'ckb': return 'ckb';
    case 'ky': return 'ky';
    case 'jv': return 'jv';
    case 'pnb': return 'pnb';
    case 'new': return 'new';
    case 'ht': return 'ht';
    case 'pms': return 'pms';
    case 'vec': return 'vec';
    case 'lb': return 'lb';
    case 'mzn': return 'mzn';
    case 'ba': return 'ba';
    case 'ga': return 'ga';
    case 'su': return 'su';
    case 'is': return 'is';
    case 'ha': return 'ha';
    case 'szl': return 'szl';
    default: return 'en';
  }
}

class SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const SettingsPage({
    super.key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.settings, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(tr('settings_page'), style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
              const Divider(height: 32),
              Text(tr('theme'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              ThemeModeSelector(
                themeMode: themeMode,
                onChanged: onThemeModeChanged,
              ),
              const SizedBox(height: 24),
              Text(tr('notifications'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.notifications_active_outlined),
                  const SizedBox(width: 8),
                  Expanded(child: Text(notificationsEnabled ? tr('notifications_on') : tr('notifications_off'))),
                  Switch(
                    value: notificationsEnabled,
                    onChanged: onNotificationsChanged,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(tr('language'), style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              LanguageDropdown(),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeModeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  const ThemeModeSelector({super.key, required this.themeMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemeMode>(
      segments: [
        ButtonSegment(value: ThemeMode.system, label: Text(tr('system'))),
        ButtonSegment(value: ThemeMode.light, label: Text(tr('light'))),
        ButtonSegment(value: ThemeMode.dark, label: Text(tr('dark'))),
      ],
      selected: <ThemeMode>{themeMode},
      onSelectionChanged: (Set<ThemeMode> newSelection) {
        if (newSelection.isNotEmpty) {
          onChanged(newSelection.first);
        }
      },
      showSelectedIcon: false,
    );
  }
}

class LanguageOption {
  final Locale locale;
  final String label;
  final String flag;
  LanguageOption({required this.locale, required this.label, required this.flag});
}

final List<LanguageOption> languageOptions = [
  LanguageOption(locale: Locale('tr'), label: 'Türkçe', flag: '🇹🇷'),
  LanguageOption(locale: Locale('en'), label: 'English', flag: '🇬🇧'),
  LanguageOption(locale: Locale('de'), label: 'Deutsch', flag: '🇩🇪'),
  LanguageOption(locale: Locale('fr'), label: 'Français', flag: '🇫🇷'),
  LanguageOption(locale: Locale('es'), label: 'Español', flag: '🇪🇸'),
  LanguageOption(locale: Locale('it'), label: 'Italiano', flag: '🇮🇹'),
  LanguageOption(locale: Locale('ru'), label: 'Русский', flag: '🇷🇺'),
  LanguageOption(locale: Locale('uk'), label: 'Українська', flag: '🇺🇦'),
  LanguageOption(locale: Locale('zh'), label: '中文', flag: '🇨🇳'),
];

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return DropdownButton<LanguageOption>(
      value: languageOptions.firstWhere((opt) => opt.locale == currentLocale, orElse: () => languageOptions[0]),
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(height: 2, color: Theme.of(context).colorScheme.primary),
      onChanged: (LanguageOption? newValue) {
        if (newValue != null) {
          context.setLocale(newValue.locale);
        }
      },
      items: languageOptions.map<DropdownMenuItem<LanguageOption>>((LanguageOption option) {
        return DropdownMenuItem<LanguageOption>(
          value: option,
          child: Row(
            children: [
              Text(option.flag, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(option.label),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Future<String> fetchGeminiExplanation(String text, String lang) async {
  const apiKey = 'AIzaSyArsQazZK1-V9KudsdDlbmriLnSluBkQL4';
  final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent');
  String prompt;
  switch (lang) {
    case 'tr':
      prompt = 'Aşağıdaki tarihi olay hakkında kısa, anlaşılır ve eğitici bir açıklama yaz.\n\nOlay: $text';
      break;
    case 'de':
      prompt = 'Schreibe eine kurze, verständliche und lehrreiche Erklärung zu folgendem historischen Ereignis.\n\nEreignis: $text';
      break;
    case 'fr':
      prompt = 'Rédigez une explication courte, claire et éducative sur l\'événement historique suivant.\n\nÉvénement : $text';
      break;
    case 'es':
      prompt = 'Escribe una explicación breve, clara y educativa sobre el siguiente evento histórico.\n\nEvento: $text';
      break;
    case 'it':
      prompt = 'Scrivi una spiegazione breve, chiara ed educativa sul seguente evento storico.\n\nEvento: $text';
      break;
    case 'pl':
      prompt = 'Napisz krótkie, jasne i edukacyjne wyjaśnienie dotyczące następującego wydarzenia historycznego.\n\nWydarzenie: $text';
      break;
    case 'ru':
      prompt = 'Напишите краткое, понятное и познавательное объяснение следующего исторического события.\n\nСобытие: $text';
      break;
    case 'uk':
      prompt = 'Напишіть коротке, зрозуміле та пізнавальне пояснення до наступної історичної події.\n\nПодія: $text';
      break;
    case 'ja':
      prompt = '次の歴史的な出来事について、短くて分かりやすい教育的な説明を書いてください。\n\n出来事: $text';
      break;
    case 'zh':
      prompt = '请对以下历史事件写一个简短、清晰且有教育意义的说明。\n\n事件：$text';
      break;
    default:
      prompt = 'Write a short, clear and educational explanation about the following historical event.\n\nEvent: $text';
      break;
  }
  final body = {
    "contents": [
      {
        "parts": [
          {"text": prompt}
        ]
      }
    ]
  };
  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "X-goog-api-key": apiKey,
    },
    body: json.encode(body),
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final candidates = data['candidates'] as List?;
    if (candidates != null && candidates.isNotEmpty) {
      final parts = candidates[0]['content']['parts'] as List?;
      if (parts != null && parts.isNotEmpty) {
        return parts[0]['text'] ?? '';
      }
    }
    return tr('ai_explanation_not_found');
  } else {
    return tr('ai_explanation_api_error', args: [response.statusCode.toString(), response.body.toString()]);
  }
}

class WikiEventDetailPage extends StatefulWidget {
  final WikiEvent event;
  const WikiEventDetailPage({super.key, required this.event});

  @override
  State<WikiEventDetailPage> createState() => _WikiEventDetailPageState();
}

class _WikiEventDetailPageState extends State<WikiEventDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final lang = context.locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text(event.year.toString()),
        actions: [
          if (event.pageUrl != null)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              tooltip: 'Wikipedia',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WikiWebViewPage(url: event.pageUrl!),
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    event.imageUrl!,
                    width: 240,
                    height: 240,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported, size: 80),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            Text(
              event.text,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            BannerAdWidget(adUnitId: bannerAdUnitId),
            const SizedBox(height: 24),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.smart_toy_outlined, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    tr('ai_explanation'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<String>(
              future: fetchGeminiExplanation(event.text, lang),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text(tr('ai_explanation_error', args: [snapshot.error.toString()]));
                } else {
                  return parseBoldMarkdown(snapshot.data ?? '', context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WikiWebViewPage extends StatelessWidget {
  final String url;
  const WikiWebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wikipedia'),
      ),
      body: Column(
        children: [
          Expanded(child: WebViewWidget(controller: controller)),
          BannerAdWidget(adUnitId: bannerAdUnitId),
        ],
      ),
    );
  }
}

class BannerAdWidget extends StatefulWidget {
  final String adUnitId;
  final AdSize adSize;
  const BannerAdWidget({super.key, required this.adUnitId, this.adSize = AdSize.banner});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox(height: 50);
    return Center(
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}

const String bannerAdUnitIdAndroid = 'ca-app-pub-9590009775953981/5527435443';
const String bannerAdUnitIdIOS = 'ca-app-pub-9590009775953981/8829785007';
String get bannerAdUnitId => Platform.isAndroid ? bannerAdUnitIdAndroid : bannerAdUnitIdIOS;

const String interstitialAdUnitIdAndroid = 'ca-app-pub-9590009775953981/9518651347';
const String interstitialAdUnitIdIOS = 'ca-app-pub-9590009775953981/8087834388';
String get interstitialAdUnitId => Platform.isAndroid ? interstitialAdUnitIdAndroid : interstitialAdUnitIdIOS;

class InterstitialAdManager {
  static InterstitialAd? _ad;
  static bool _isLoading = false;

  static void loadAd(VoidCallback? onLoaded) {
    if (_ad != null || _isLoading) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isLoading = false;
          onLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          _ad = null;
          _isLoading = false;
          onLoaded?.call();
        },
      ),
    );
  }

  static void showAd(VoidCallback onClosed) {
    if (_ad == null) {
      onClosed();
      return;
    }
    _ad!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _ad = null;
        loadAd(null); // Sonraki için yükle
        onClosed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _ad = null;
        loadAd(null);
        onClosed();
      },
    );
    _ad!.show();
  }
}

// Rewarded Interstitial reklam yönetimi:
const String testRewardedInterstitialAdUnitIdAndroid = 'ca-app-pub-9590009775953981/9518651347';
const String testRewardedInterstitialAdUnitIdIOS = 'ca-app-pub-9590009775953981/8087834388';
String get rewardedInterstitialAdUnitId => Platform.isAndroid ? testRewardedInterstitialAdUnitIdAndroid : testRewardedInterstitialAdUnitIdIOS;

class RewardedInterstitialAdManager {
  static bool _isLoading = false;

  static void loadAd({required VoidCallback onRewarded, required VoidCallback onClosed, required VoidCallback onFailed}) {
    if (_isLoading) return;
    _isLoading = true;
    RewardedInterstitialAd.load(
      adUnitId: rewardedInterstitialAdUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _isLoading = false;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onClosed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              onFailed();
            },
          );
          ad.show(onUserEarnedReward: (ad, reward) {
            onRewarded();
          });
        },
        onAdFailedToLoad: (error) {
          _isLoading = false;
          onFailed();
        },
      ),
    );
  }
}

// Yapay zeka açıklamasını bold işaretli kısımları algılayıp RichText ile göster:
RichText parseBoldMarkdown(String text, BuildContext context) {
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*');
  int last = 0;
  final matches = regex.allMatches(text);
  for (final match in matches) {
    if (match.start > last) {
      spans.add(TextSpan(text: text.substring(last, match.start), style: Theme.of(context).textTheme.bodyLarge));
    }
    spans.add(TextSpan(text: match.group(1), style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)));
    last = match.end;
  }
  if (last < text.length) {
    spans.add(TextSpan(text: text.substring(last), style: Theme.of(context).textTheme.bodyLarge));
  }
  return RichText(text: TextSpan(children: spans));
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> updateNotifications(bool enabled, Function(int) onSelectTab) async {
  if (enabled) {
    await setupNotifications(onSelectTab);
  } else {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future<void> setupNotifications(Function(int) onSelectTab) async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    settings: initializationSettings,
    onDidReceiveNotificationResponse: (details) {
      if (details.payload == 'today') {
        onSelectTab(0);
      } else if (details.payload == 'tomorrow') {
        onSelectTab(1);
      }
    },
  );
  tz.initializeTimeZones();
  await scheduleDailyNotification(10, 0, 'Tarihte Bugün Ne Oldu?', 'Bugünün tarihiyle ilgili olayları görmek için tıkla.', 'today');
  await scheduleDailyNotification(20, 0, 'Tarihte Yarın Ne Oldu?', 'Yarının tarihiyle ilgili olayları görmek için tıkla.', 'tomorrow');
}

Future<void> scheduleDailyNotification(int hour, int minute, String title, String body, String payload) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
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

tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
  final now = tz.TZDateTime.now(tz.local);
  var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
  if (scheduled.isBefore(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }
  return scheduled;
}

Future<void> setupTimezone() async {
  final timezoneInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
}
