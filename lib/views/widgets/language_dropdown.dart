import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/language_option.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedOption = languageOptions.firstWhere(
      (opt) => opt.locale == currentLocale,
      orElse: () => languageOptions[0],
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B1E2B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF2A2E40) : const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<LanguageOption>(
          value: selectedOption,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF14161F) : Colors.white,
          icon: Icon(Icons.unfold_more_rounded, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
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
                  const SizedBox(width: 12),
                  Text(
                    option.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
