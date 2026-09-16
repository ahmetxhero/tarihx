import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/wiki_event.dart';
import '../../services/ad_service.dart';
import '../../services/wiki_service.dart';
import '../event_detail_page.dart';
import 'banner_ad_widget.dart';

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
    _futureEvents = WikiService.fetchEvents(widget.day, widget.month, widget.locale);
    InterstitialAdManager.loadAd(null);
  }

  @override
  void didUpdateWidget(covariant WikiEventsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.day != widget.day || oldWidget.month != widget.month || oldWidget.locale != widget.locale) {
      _futureEvents = WikiService.fetchEvents(widget.day, widget.month, widget.locale);
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
            return const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    Text('Hata: ${snapshot.error}', textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_mosaic_rounded, size: 48, color: Color(0xFF94A3B8)),
                  SizedBox(height: 12),
                  Text('Kayıt bulunamadı.'),
                ],
              ),
            );
          }
          final events = snapshot.data!;
          final bannerIndexes = [3, 8, 16, 26, 35, 50];
          final itemCount = events.length + bannerIndexes.where((i) => i <= events.length).length;
          return ListView.builder(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 100),
            itemCount: itemCount,
            itemBuilder: (context, i) {
              int eventIndex = i;
              int bannerCount = 0;
              for (final bIndex in bannerIndexes) {
                if (i == bIndex + bannerCount) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: BannerAdWidget(adUnitId: AdService.bannerAdUnitId),
                  );
                }
                if (i > bIndex + bannerCount) {
                  bannerCount++;
                  eventIndex--;
                }
              }
              if (eventIndex >= events.length) return const SizedBox.shrink();
              final event = events[eventIndex];
              final isDark = Theme.of(context).brightness == Brightness.dark;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF14161F) : const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withValues(alpha: 0.3) : const Color(0xFF0F172A).withValues(alpha: 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
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
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E212E) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: event.imageUrl != null
                                    ? Image.network(
                                        event.imageUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Icon(
                                          Icons.history_edu,
                                          size: 26,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                        ),
                                      )
                                    : Icon(
                                        Icons.history_edu,
                                        size: 26,
                                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                      ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                event.text,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                  fontSize: 14.5,
                                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF222533) : const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                event.year.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
