import 'package:kalender/src/widgets/components/day_header.dart';
import 'package:kalender/src/widgets/components/day_separator.dart';
import 'package:kalender/src/widgets/components/hour_lines.dart';
import 'package:kalender/src/widgets/components/time_indicator.dart';
import 'package:kalender/src/widgets/components/time_line.dart';
import 'package:kalender/src/widgets/components/week_number.dart';

/// The styles of the default components used by the [MultiDayHeader].
class MultiDayHeaderComponentStyles {
  final DayHeaderStyle? dayHeaderStyle;
  final WeekNumberStyle? weekNumberStyle;

  const MultiDayHeaderComponentStyles({
    this.dayHeaderStyle,
    this.weekNumberStyle,
  });
}

/// The styles of the default components used by the [MultiDayBody].
class MultiDayBodyComponentStyles {
  final DaySeparatorStyle? daySeparatorStyle;
  final TimeIndicatorStyle? timeIndicatorStyle;
  final HourLinesStyle? hourLinesStyle;
  final TimelineStyle? timelineStyle;

  const MultiDayBodyComponentStyles({
    this.daySeparatorStyle,
    this.timeIndicatorStyle,
    this.hourLinesStyle,
    this.timelineStyle,
  });
}