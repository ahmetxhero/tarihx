import 'package:flutter/material.dart';
import '../models/wiki_event.dart';
import '../services/wiki_service.dart';

abstract class EventsView {
  void onEventsLoaded(List<WikiEvent> events);
  void onEventsError(String error);
  void onEventsLoading();
}

class EventsPresenter {
  final EventsView view;

  EventsPresenter(this.view);

  Future<List<WikiEvent>> loadEvents(int day, int month, Locale locale) async {
    view.onEventsLoading();
    try {
      final events = await WikiService.fetchEvents(day, month, locale);
      view.onEventsLoaded(events);
      return events;
    } catch (e) {
      view.onEventsError(e.toString());
      rethrow;
    }
  }
}
