import '../../../quantity_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// The rate of change of an angle.
/// See the [Wikipedia entry for Angular_velocity](https://en.wikipedia.org/wiki/Angular_velocity)
/// for more information.
class AngularSpeed extends Quantity {
  /// Construct an AngularSpeed with either radians per second or degrees per second.
  /// Optionally specify a relative standard uncertainty.
  AngularSpeed(
      {dynamic radiansPerSecond, dynamic degreesPerSecond, double uncert = 0.0})
      : super(
            radiansPerSecond ?? (degreesPerSecond ?? 0.0),
            degreesPerSecond != null
                ? AngularSpeed.degreesPerSecond
                : AngularSpeed.radiansPerSecond,
            uncert);

  /// Constructs a instance without preferred units.
  AngularSpeed.misc(dynamic conv)
      : super.misc(conv, AngularSpeed.angularSpeedDimensions);

  /// Constructs a AngularSpeed based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  AngularSpeed.inUnits(dynamic value, AngularSpeedUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? AngularSpeed.radiansPerSecond, uncert);

  /// Constructs a constant AngularSpeed.
  const AngularSpeed.constant(Number valueSI,
      {AngularSpeedUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, AngularSpeed.angularSpeedDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions angularSpeedDimensions = Dimensions.constant(
      <String, int>{'Angle': 1, 'Time': -1},
      qType: AngularSpeed);

  /// The standard SI unit.
  static final AngularSpeedUnits radiansPerSecond =
      AngularSpeedUnits.angleTime(AngleUnits.radians, Time.seconds);

  /// Accepted for use with the SI.
  static final AngularSpeedUnits degreesPerSecond =
      AngularSpeedUnits.angleTime(AngleUnits.degrees, Time.seconds);
}

/// Units acceptable for use in describing AngularSpeed quantities.
class AngularSpeedUnits extends AngularSpeed with Units {
  /// Constructs a instance.
  AngularSpeedUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
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

  /// Constructs a instance based on angle and time units.
  AngularSpeedUnits.angleTime(AngleUnits au, TimeUnits tu)
      : super.misc(au.valueSI * tu.valueSI) {
    name = '${au.name} per ${tu.singular} squared';
    singular = '${au.singular} per ${tu.singular} squared';
    convToMKS = au.valueSI * tu.valueSI;
    abbrev1 = au.abbrev1 != null && tu.abbrev1 != null
        ? '${au.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = au.abbrev2 != null && tu.abbrev2 != null
        ? '${au.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => AngularSpeed;

  /// Derive AngularSpeedUnits using this AngularSpeedUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AngularSpeedUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);

  /// The standard SI unit.
  static AngularSpeedUnits radiansPerSecond = AngularSpeed.radiansPerSecond;

  /// Accepted for use with the SI.
  static AngularSpeedUnits degreesPerSecond = AngularSpeed.degreesPerSecond;

  /// Rotation frequency.
  static AngularSpeedUnits revolutionsPerMinute =
      AngularSpeedUnits.angleTime(AngleUnits.revolutions, Time.minutes);

  /// A synonym for [revolutionsPerMinute].
  static AngularSpeedUnits rpm = revolutionsPerMinute;
}
