import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'widgets/wiki_events_list.dart';

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
