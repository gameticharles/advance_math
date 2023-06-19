import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// The rate of change of speed of an object.
/// See the [Wikipedia entry for Acceleration](https://en.wikipedia.org/wiki/Acceleration)
/// for more information.
class Acceleration extends Quantity {
  /// Construct an Acceleration with meters per second squared.
  /// Optionally specify a relative standard uncertainty.
  Acceleration({dynamic metersPerSecondSquared, double uncert = 0.0})
      : super(metersPerSecondSquared ?? 0.0,
            Acceleration.metersPerSecondSquared, uncert);

  /// Constructs a instance without preferred units.
  Acceleration.misc(dynamic conv)
      : super.misc(conv, Acceleration.accelerationDimensions);

  /// Constructs a Acceleration based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Acceleration.inUnits(dynamic value, AccelerationUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Acceleration.metersPerSecondSquared, uncert);

  /// Constructs a constant Acceleration.
  const Acceleration.constant(Number valueSI,
      {AccelerationUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Acceleration.accelerationDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions accelerationDimensions = Dimensions.constant(
      <String, int>{'Length': 1, 'Time': -2},
      qType: Acceleration);

  /// The standard SI unit.
  static final AccelerationUnits metersPerSecondSquared =
      AccelerationUnits.lengthTimeUnits(LengthUnits.meters, Time.seconds);
}

/// Units acceptable for use in describing Acceleration quantities.
class AccelerationUnits extends Acceleration with Units {
  /// Constructs a instance.
  AccelerationUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on length and time units.
  AccelerationUnits.lengthTimeUnits(LengthUnits lu, TimeUnits su)
      : super.misc(lu.valueSI * su.valueSI) {
    name = '${lu.name} per ${su.singular} squared';
    singular = '${lu.singular} per ${su.singular} squared';
    convToMKS = lu.valueSI * su.valueSI;
    abbrev1 = lu.abbrev1 != null && su.abbrev1 != null
        ? '${lu.abbrev1} / ${su.abbrev1}'
        : null;
    abbrev2 = lu.abbrev2 != null && su.abbrev2 != null
        ? '${lu.abbrev2}${su.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Acceleration;

  /// Derive AccelerationUnits using this AccelerationUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AccelerationUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
