import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Represents the _time interval_ physical quantity (one of the seven
/// base SI quantities).
///
/// The class is named Time, rather than Duration, to avoid conflict with
/// the [dart:core] `Duration` class.
///
/// Use the `TimeInstant` class to specify a specific moment in time.
///
/// See the [Wikipedia entry for Time](https://en.wikipedia.org/wiki/Time)
/// for more information.
class Time extends Quantity {
  /// Constructs a Time with seconds ([s]), milliseconds ([ms]), nanoseconds ([ns]), mean solar days ([d]), mean solar hours ([h])
  /// or mean solar minutes ([min]).
  /// Optionally specify a relative standard uncertainty.
  Time(
      {dynamic s,
      dynamic ms,
      dynamic ns,
      dynamic d,
      dynamic h,
      dynamic min,
      double uncert = 0.0})
      : super(
            s ?? (ms ?? (ns ?? (d ?? (h ?? (min ?? 0.0))))),
            ms != null
                ? Time.milliseconds
                : (ns != null
                    ? Time.nanoseconds
                    : (d != null
                        ? Time.daysMeanSolar
                        : (h != null
                            ? Time.hoursMeanSolar
                            : (min != null
                                ? Time.minutesMeanSolar
                                : Time.seconds)))),
            uncert);

  /// Constructs a instance without preferred units.
  Time.misc(dynamic conv) : super.misc(conv, Time.timeDimensions);

  /// Constructs a Time based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Time.inUnits(dynamic value, TimeUnits? units, [double uncert = 0.0])
      : super(value, units ?? Time.seconds, uncert);

  /// Constructs a constant Time.
  const Time.constant(Number valueSI, {TimeUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Time.timeDimensions, units, uncert);

  /// Constructs a Time object from an existing dart:core Duration object.
  Time.fromDuration(Duration d)
      : super(d.inMicroseconds.toDouble() / 1.0e6, Time.seconds);

  /// Dimensions for this type of quantity
  static const Dimensions timeDimensions =
      Dimensions.constant(<String, int>{'Time': 1}, qType: Time);

  // Units.

  /// The standard SI unit.
  static final TimeUnits seconds =
      TimeUnits('seconds', 'sec', 's', null, Double.one, true);

  /// Accepted for use with the SI.
  // ignore: prefer_int_literals
  static final TimeUnits daysMeanSolar = TimeUnits(
      'days', 'days', 'd', null, const Double.constant(8.64e4), false);

  /// Accepted for use with the SI.
  static final TimeUnits hoursMeanSolar =
      TimeUnits('hours', 'hrs', 'h', null, const Double.constant(3600), false);

  /// Accepted for use with the SI.
  static final TimeUnits minutesMeanSolar = TimeUnits(
      'minutes', 'minutes', 'min', null, const Double.constant(60), false);

  // Common metric derivations.

  /// One thousandth of a second.
  static final TimeUnits milliseconds = Time.seconds.milli() as TimeUnits;

  /// One millionth of a second.
  static final TimeUnits microseconds = Time.seconds.micro() as TimeUnits;

  /// One billionth of a second.
  static final TimeUnits nanoseconds = Time.seconds.nano() as TimeUnits;

  // Convenience units.

  /// Accepted for use with the SI.
  static final TimeUnits minutes = minutesMeanSolar;

  /// Accepted for use with the SI.
  static final TimeUnits hours = hoursMeanSolar;

  /// Accepted for use with the SI.
  static final TimeUnits days = daysMeanSolar;

  /// Create a dart:core Duration object with the same time interval as this
  /// Time object, to microsecond precision (the maximum precision of the
  /// Duration object).
  Duration toDuration() =>
      Duration(microseconds: (valueSI.toDouble() * 1000000.0).round());
}

/// Units acceptable for use in describing [Time] quantities.
class TimeUnits extends Time with Units {
  /// Constructs a instance.
  TimeUnits(String name, String? abbrev1, String? abbrev2, String? singular,
      dynamic conv,
      [bool metricBase = false, num offset = 0.0])
      : super.misc(conv) {
    this.name = name;
    this.singular = singular;
    convToMKS = objToNumber(conv);
    this.abbrev1 = abbrev1;
    this.abbrev2 = abbrev2;
    this.metricBase = metricBase;
    this.offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Time;

  /// Derive TimeUnits using this TimeUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      TimeUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
