import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/wiki_event.dart';

class WikiService {
  static Future<List<WikiEvent>> fetchEvents(int day, int month, Locale locale) async {
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

  static String _wikiLang(Locale locale) {
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
}
