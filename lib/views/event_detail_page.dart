import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../core/utils/markdown_utils.dart';
import '../models/wiki_event.dart';
import '../services/ad_service.dart';
import '../services/gemini_service.dart';
import 'widgets/banner_ad_widget.dart';
import 'wiki_web_view_page.dart';

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
    InterstitialAdManager.loadAd(null);
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = context.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.year.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
          ),
        ),
        centerTitle: true,
        actions: [
          if (event.pageUrl != null)
            IconButton(
              icon: const Icon(Icons.language_rounded),
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imageUrl != null)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? const Color(0xFF262938) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withValues(alpha: 0.4) : const Color(0xFF0F172A).withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(23),
                    child: Image.network(
                      event.imageUrl!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
            if (event.imageUrl != null) const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF141620) : const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF222533) : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withValues(alpha: 0.25) : const Color(0xFF0F172A).withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                event.text,
                style: TextStyle(
                  fontSize: 16.5,
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                  color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),
            BannerAdWidget(adUnitId: AdService.bannerAdUnitId),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF181B28), const Color(0xFF11131E)]
                      : [const Color(0xFFF8FAFC), const Color(0xFFEDF2F7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? const Color(0xFF2E3346) : const Color(0xFFCBD5E1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF2B2F44) : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          size: 18,
                          color: isDark ? const Color(0xFFF8FAFC) : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tr('ai_explanation'),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                          color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<String>(
                    future: GeminiService.fetchExplanation(event.text, lang),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2.5),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          tr('ai_explanation_error', args: [snapshot.error.toString()]),
                          style: TextStyle(color: Theme.of(context).colorScheme.error),
                        );
                      } else {
                        return parseBoldMarkdown(snapshot.data ?? '', context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
