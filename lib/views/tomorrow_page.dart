import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'widgets/wiki_events_list.dart';

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
