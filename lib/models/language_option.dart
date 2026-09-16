import 'package:flutter/material.dart';

class LanguageOption {
  final Locale locale;
  final String label;
  final String flag;

  LanguageOption({
    required this.locale,
    required this.label,
    required this.flag,
  });
}

final List<LanguageOption> languageOptions = [
  LanguageOption(locale: const Locale('tr'), label: 'Türkçe', flag: '🇹🇷'),
  LanguageOption(locale: const Locale('en'), label: 'English', flag: '🇬🇧'),
  LanguageOption(locale: const Locale('de'), label: 'Deutsch', flag: '🇩🇪'),
  LanguageOption(locale: const Locale('fr'), label: 'Français', flag: '🇫🇷'),
  LanguageOption(locale: const Locale('es'), label: 'Español', flag: '🇪🇸'),
  LanguageOption(locale: const Locale('it'), label: 'Italiano', flag: '🇮🇹'),
  LanguageOption(locale: const Locale('pt'), label: 'Português', flag: '🇵🇹'),
  LanguageOption(locale: const Locale('ru'), label: 'Русский', flag: '🇷🇺'),
  LanguageOption(locale: const Locale('uk'), label: 'Українська', flag: '🇺🇦'),
  LanguageOption(locale: const Locale('sv'), label: 'Svenska', flag: '🇸🇪'),
  LanguageOption(locale: const Locale('ar'), label: 'العربية', flag: '🇸🇦'),
  LanguageOption(locale: const Locale('zh'), label: '中文', flag: '🇨🇳'),
];
