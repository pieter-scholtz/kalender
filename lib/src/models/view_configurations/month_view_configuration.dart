import 'package:flutter/material.dart';

import 'package:kalender/kalender.dart';
import 'package:kalender/src/extensions.dart';

const defaultFirstDayOfWeek = DateTime.monday;

class MonthViewConfiguration extends ViewConfiguration {
  MonthViewConfiguration({
    required super.name,
    required this.displayRange,
    required this.firstDayOfWeek,
    required this.pageNavigationFunctions,
  }) : assert(
          firstDayOfWeek >= 1 && firstDayOfWeek <= 7,
          'First day of week must be between 1 and 7 (inclusive)\n'
          'Use DateTime.monday ~ DateTime.sunday if unsure.',
        );

  MonthViewConfiguration.month({
    super.name = 'Month',
    DateTimeRange? displayRange,
    this.firstDayOfWeek = defaultFirstDayOfWeek,
  }) {
    this.displayRange = displayRange ?? DateTime.now().yearRange;
    pageNavigationFunctions = PageNavigationFunctions.month(
      this.displayRange,
      firstDayOfWeek,
    );
  }

  /// The functions for navigating the [PageView].
  late final PageNavigationFunctions pageNavigationFunctions;

  /// The [DateTimeRange] that can be displayed by [MultiDayBody] widgets using this configuration.
  late final DateTimeRange displayRange;

  /// The start of the [displayRange].
  DateTime get start => displayRange.start;

  /// The end of the [displayRange].
  DateTime get end => displayRange.end;

  /// The first day of the week.
  late final int firstDayOfWeek;
}