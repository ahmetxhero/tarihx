import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ThemeModeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  const ThemeModeSelector({super.key, required this.themeMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: SegmentedButton<ThemeMode>(
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
      ),
    );
  }
}
