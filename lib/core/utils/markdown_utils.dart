import 'package:flutter/material.dart';

RichText parseBoldMarkdown(String text, BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final normalStyle = TextStyle(
    fontSize: 15,
    height: 1.6,
    color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
    fontWeight: FontWeight.w400,
  );
  final boldStyle = TextStyle(
    fontSize: 15,
    height: 1.6,
    color: isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
    fontWeight: FontWeight.w800,
  );
  final spans = <TextSpan>[];
  final regex = RegExp(r'\*\*(.*?)\*\*');
  int last = 0;
  final matches = regex.allMatches(text);
  for (final match in matches) {
    if (match.start > last) {
      spans.add(TextSpan(text: text.substring(last, match.start), style: normalStyle));
    }
    spans.add(TextSpan(text: match.group(1), style: boldStyle));
    last = match.end;
  }
  if (last < text.length) {
    spans.add(TextSpan(text: text.substring(last), style: normalStyle));
  }
  return RichText(text: TextSpan(children: spans));
}
