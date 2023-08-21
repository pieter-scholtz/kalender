import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:kalender/src/extentions.dart';

/// A [ChangeNotifier] that manages [CalendarEvent]s.
class CalendarEventsController<T> with ChangeNotifier {
  CalendarEventsController();

  /// The list of [CalendarEvent]s.
  final List<CalendarEvent<T>> _events = <CalendarEvent<T>>[];
  List<CalendarEvent<T>> get events => _events;

  /// The moving [CalendarEvent].
  CalendarEvent<T>? _selectedEvent;
  CalendarEvent<T>? get selectedEvent => _selectedEvent;

  void deselectEvent() {
    _selectedEvent = null;
    _isSelectedEventMultiday = false;
    _isResizing = false;
    _isMoving = false;
    notifyListeners();
  }

  void setSelectedEvent(
    CalendarEvent<T> value,
  ) {
    _selectedEvent = value;
    _isSelectedEventMultiday = value.isMultidayEvent;
    notifyListeners();
  }

  /// Whether the [CalendarController] has a [_selectedEvent].
  bool get hasChaningEvent => _selectedEvent != null;

  bool _isSelectedEventMultiday = false;
  bool get isSelectedEventMultiday => _isSelectedEventMultiday;

  bool _isResizing = false;
  bool get isResizing => _isResizing;
  set isResizing(bool value) {
    _isResizing = value;
    notifyListeners();
  }

  bool _isMoving = false;
  bool get isMoving => _isMoving;
  set isMoving(bool value) {
    _isMoving = value;
    notifyListeners();
  }

  void updateUI() {
    notifyListeners();
  }

  /// Adds an [CalendarEvent] to the list of [CalendarEvent]s.
  void addEvent(CalendarEvent<T> event) {
    _events.add(event);
    notifyListeners();
  }

  /// Adds a list of [CalendarEvent]s to the list of [CalendarEvent]s.
  void addEvents(List<CalendarEvent<T>> events) {
    _events.addAll(events);
    notifyListeners();
  }

  /// Removes an [CalendarEvent] from the list of [CalendarEvent]s.
  void removeEvent(CalendarEvent<T> event) {
    _events.remove(event);
    _selectedEvent = null;
    notifyListeners();
  }

  /// Removes a list of [CalendarEvent]s from the list of [CalendarEvent]s.
  ///
  /// The events will be removed where [test] returns true.
  void removeWhere(bool Function(CalendarEvent<T> element) test) {
    _events.removeWhere(test);
    notifyListeners();
  }

  /// Removes all [CalendarEvent]s from [_events].
  void clearEvents() {
    _events.clear();
    notifyListeners();
  }

  /// Updates an [CalendarEvent] in the list of [CalendarEvent]s.
  ///
  /// The event where [test] returns true will be updated.
  void updateEvent({
    T? newEventData,
    DateTimeRange? newDateTimeRange,
    bool? modifyable,
    required bool Function(CalendarEvent<T> calendarEvent) test,
  }) {
    int index = _events.indexWhere((CalendarEvent<T> element) => test(element));
    if (index == -1) return;
    if (newEventData != null) {
      _events[index].eventData = newEventData;
    }
    if (newDateTimeRange != null) {
      _events[index].dateTimeRange = newDateTimeRange;
    }
    if (modifyable != null) {
      _events[index].canModify = modifyable;
    }

    notifyListeners();
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This exludes [CalendarEvent]s that are displayed on single days.
  Iterable<CalendarEvent<T>> getMultidayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (CalendarEvent<T> element) =>
          ((element.start.isBefore(dateRange.start) &&
                  element.end.isAfter(dateRange.end)) ||
              element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange) ||
              element.start == dateRange.start ||
              element.end == dateRange.end) &&
          element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  /// * This excludes [CalendarEvent]s that are displayed on multiple days.
  Iterable<CalendarEvent<T>> getEventsFromDateRange(DateTimeRange dateRange) {
    return _events.where(
      (CalendarEvent<T> element) => (element.start.isWithin(dateRange) ||
          element.end.isWithin(dateRange)),
    );
  }

  /// Returns a iterable of [CalendarEvent]s for that will be visible on the given date range.
  Iterable<CalendarEvent<T>> getDayEventsFromDateRange(
    DateTimeRange dateRange,
  ) {
    return _events.where(
      (CalendarEvent<T> element) =>
          (element.start.isWithin(dateRange) ||
              element.end.isWithin(dateRange)) &&
          !element.isMultidayEvent,
    );
  }

  /// Returns a iterable of [DateTime]s which is the [CalendarEvent.start] and [CalendarEvent.end]
  /// of the [CalendarEvent]s that are visible on the given date range.
  Iterable<DateTime> getSnapPointsFromDateTimeRange(DateTimeRange dateRange) {
    Iterable<CalendarEvent<T>> eventsInDateTimeRange =
        getEventsFromDateRange(dateRange);
    List<DateTime> snapPoints = <DateTime>[];
    for (CalendarEvent<T> event in eventsInDateTimeRange) {
      snapPoints.add(event.start);
      snapPoints.add(event.end);
    }
    return snapPoints;
  }

  Iterable<CalendarEvent<T>> getEventsFromDate(DateTime date) {
    return _events.where((CalendarEvent<T> element) => element.isOnDate(date));
  }

  @override
  bool operator ==(Object other) {
    return other is CalendarEventsController &&
        listEquals(other._events, _events);
  }

  @override
  int get hashCode => _events.hashCode;
}
