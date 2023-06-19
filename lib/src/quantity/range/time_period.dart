import '../src/si/types/time_instant.dart';
import 'quantity_range.dart';

/// Represents a specific time span.
class TimePeriod extends QuantityRange<TimeInstant> {
  /// Constructs a time period.
  TimePeriod(TimeInstant startTime, TimeInstant endTime) : super(startTime, endTime);
}

/// Constructs a [FiscalYear] time period.
///
/// Defaults to the US Government fiscal year which runs from October of the previous calendar
/// year through September.  This can be changed by setting the optional `monthOffset` parameter.
///
/// If the `year` provided is only 2 digits it will be converted to four digits, assuming anything
/// 70 or over means 19xx and anything under 70 mean 20xx.
class FiscalYear extends TimePeriod {
  /// Constructs a FiscalYear, optionally setting the month offset (which defaults to minus 3).
  FiscalYear(int year, {int monthOffset = -3})
      : _year = year,
        super(TimeInstant.dateTime(DateTime(yr4(year), 1 + monthOffset)),
            TimeInstant.dateTime(DateTime(yr4(year), 13 + monthOffset)));

  final int _year;

  @override
  String toString() => 'FY${'$_year'.substring(2)}';
}

/// The period of 365 days (or 366 days in leap years) starting from the first of January;
/// used for reckoning time in ordinary affairs.
class CalendarYear extends TimePeriod {
  /// Constructs a instance for [year].
  CalendarYear(int year)
      : _year = year,
        super(TimeInstant.dateTime(DateTime(year, 1)), TimeInstant.dateTime(DateTime(year + 1)));

  final int _year;

  @override
  String toString() => '$_year';
}

/// Returns a four digit year from [year] which may be only 2 digits, assuming that
/// anything 70 or more means 19xx and under 70 means 20xx.
int yr4(int year) {
  if (year > 1000) return year;
  if (year > 69) return 1900 + year;
  return 2000 + year;
}
