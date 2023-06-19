import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// The rate of change of angular speed.
/// See the [Wikipedia entry for Angular acceleration](https://en.wikipedia.org/wiki/Angular_acceleration)
/// for more information.
class AngularAcceleration extends Quantity {
  /// Construct an AngularAcceleration with either radians per second squared
  /// or degrees per second squared).
  /// Optionally specify a relative standard uncertainty.
  AngularAcceleration(
      {dynamic radiansPerSecondSquared,
      dynamic degreesPerSecondSquared,
      double uncert = 0.0})
      : super(
            radiansPerSecondSquared ?? (degreesPerSecondSquared ?? 0.0),
            degreesPerSecondSquared != null
                ? AngularAcceleration.degreesPerSecondSquared
                : AngularAcceleration.radiansPerSecondSquared,
            uncert);

  /// Constructs a instance without preferred units.
  AngularAcceleration.misc(dynamic conv)
      : super.misc(conv, AngularAcceleration.angularAccelerationDimensions);

  /// Constructs a AngularAcceleration based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  AngularAcceleration.inUnits(dynamic value, AngularAccelerationUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? AngularAcceleration.radiansPerSecondSquared,
            uncert);

  /// Constructs a constant AngularAcceleration.
  const AngularAcceleration.constant(Number valueSI,
      {AngularAccelerationUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            AngularAcceleration.angularAccelerationDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions angularAccelerationDimensions = Dimensions.constant(
      <String, int>{'Angle': 1, 'Time': -2},
      qType: AngularAcceleration);

  /// The Standard SI unit.
  static final AngularAccelerationUnits radiansPerSecondSquared =
      AngularAccelerationUnits.angleTime(AngleUnits.radians, Time.seconds);

  /// Accepted for use with the SI.
  static final AngularAccelerationUnits degreesPerSecondSquared =
      AngularAccelerationUnits.angleTime(AngleUnits.degrees, Time.seconds);
}

/// Units acceptable for use in describing AngularAcceleration quantities.
class AngularAccelerationUnits extends AngularAcceleration with Units {
  /// Constructs a instance.
  AngularAccelerationUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from angle and time units.
  AngularAccelerationUnits.angleTime(AngleUnits au, TimeUnits tu)
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
  Type get quantityType => AngularAcceleration;

  /// Derive AngularAccelerationUnits using this AngularAccelerationUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AngularAccelerationUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
