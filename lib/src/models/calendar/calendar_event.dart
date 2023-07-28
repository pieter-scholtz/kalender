import 'package:flutter/material.dart';
import 'package:kalender/src/extentions.dart';

/// [CalendarEvent] is a [ChangeNotifier] that contains a [DateTimeRange] and an optional [eventData].
class CalendarEvent<T extends Object?> with ChangeNotifier {
  CalendarEvent({
    required DateTimeRange dateTimeRange,
    T? eventData,
  }) {
    _dateTimeRange = dateTimeRange;
    _eventData = eventData;
  }

  /// The [DateTimeRange] of the [CalendarEvent].
  late DateTimeRange _dateTimeRange;
  DateTimeRange get dateTimeRange => _dateTimeRange;
  set dateTimeRange(DateTimeRange newDateTimeRange) {
    _dateTimeRange = newDateTimeRange;
    notifyListeners();
  }

  /// The start [DateTime] of the [CalendarEvent].
  DateTime get start => _dateTimeRange.start;
  set start(DateTime newStart) {
    assert(newStart.isBefore(_dateTimeRange.end), 'CalendarEvent start must be before end');
    _dateTimeRange = DateTimeRange(
      start: newStart,
      end: _dateTimeRange.end,
    );
    notifyListeners();
  }

  /// The end [DateTime] of the [CalendarEvent].
  DateTime get end => _dateTimeRange.end;
  set end(DateTime newEnd) {
    assert(newEnd.isAfter(_dateTimeRange.start), 'CalendarEvent end must be after start');
    _dateTimeRange = DateTimeRange(
      start: _dateTimeRange.start,
      end: newEnd,
    );
    notifyListeners();
  }

  /// EventData of the [CalendarEvent].
  late T? _eventData;
  T? get eventData => _eventData;
  set eventData(T? newEvent) {
    _eventData = newEvent;
    notifyListeners();
  }

  /// Whether the [CalendarEvent] is a multiday event.
  bool get isMultidayEvent => duration.inDays >= 1;

  /// Whether the [CalendarEvent] is split across days.
  bool get isSplitAcrossDays => !start.isSameDay(end);

  /// Whether the [CalendarEvent] has a date counter.
  bool get hasDateCounter {
    // Check if the start and end are the same day.
    if (start.isSameDay(end)) return false;

    // Check if the event's end is the is the start's endOfDay.
    if (end == start.endOfDay) return false;

    return true;
  }

  /// The number of days since the start of the [CalendarEvent].
  int dayNumber(DateTime date) {
    return date.difference(start.startOfDay).inDays + 1;
  }

  /// The number of days spanned in the [CalendarEvent].
  int get daySpan => dateTimeRange.dayDifference;

  /// The total duration of the [CalendarEvent].
  Duration get duration => _dateTimeRange.duration;

  /// The [DateTimeRange] of the [CalendarEvent] on a specific date.
  DateTimeRange dateTimeRangeOnDate(DateTime date) {
    if (start.isSameDay(end)) {
      // The start and end are on same day.
      return dateTimeRange;
    } else {
      if (date.isSameDay(start)) {
        // The date is the same as the start.
        return DateTimeRange(start: start, end: start.endOfDay);
      } else {
        // The date is the same as the end.
        return DateTimeRange(start: end.startOfDay, end: end);
      }
    }
  }

  /// The duration of the [CalendarEvent] on a specific date.
  Duration durationOnDate(DateTime date) {
    return dateTimeRangeOnDate(date).duration;
  }

  /// The [DateTime]s that the [CalendarEvent] spans.
  List<DateTime> get datesSpanned => dateTimeRange.datesSpanned;

  /// Whether the [CalendarEvent] is on a specific date.
  bool isOnDate(DateTime date) {
    return (start.isBefore(date.endOfDay) && end.isAfter(date.startOfDay)) ||
        start == date.startOfDay ||
        end == date.endOfDay;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'Start': start,
        'End': end,
        'Event': eventData.toString(),
      };

  CalendarEvent<T> copyWith({
    DateTimeRange? dateTimeRange,
    T? eventData,
    String? title,
    String? description,
    Color? color,
  }) {
    return CalendarEvent<T>(
      dateTimeRange: dateTimeRange ?? _dateTimeRange,
      eventData: eventData ?? _eventData,
    );
  }

  void repalceWith({
    required CalendarEvent<T> event,
  }) {
    _dateTimeRange = event.dateTimeRange;
    _eventData = event.eventData;
  }

  @override
  String toString() => toJson().toString();

  @override
  bool operator ==(Object other) {
    return other is CalendarEvent<T> &&
        other._dateTimeRange == _dateTimeRange &&
        other.eventData == _eventData;
  }

  @override
  int get hashCode => Object.hash(_dateTimeRange, _eventData);
}