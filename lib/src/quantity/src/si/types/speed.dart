import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'time.dart';

/// The rate of change of position.
/// See the [Wikipedia entry for Speed](https://en.wikipedia.org/wiki/Speed)
/// for more information.
class Speed extends Quantity {
  /// Constructs a Speed with meters per second or [knots].
  /// Optionally specify a relative standard uncertainty.
  Speed({dynamic metersPerSecond, dynamic knots, double uncert = 0.0})
      : super(metersPerSecond ?? (knots ?? 0.0),
            knots != null ? Speed.knots : Speed.metersPerSecond, uncert);

  /// Constructs a instance without preferred units.
  Speed.misc(dynamic conv) : super.misc(conv, Speed.speedDimensions);

  /// Constructs a Speed based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Speed.inUnits(dynamic value, SpeedUnits? units, [double uncert = 0.0])
      : super(value, units ?? Speed.metersPerSecond, uncert);

  /// Constructs a constant Speed.
  const Speed.constant(Number valueSI, {SpeedUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Speed.speedDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions speedDimensions =
      Dimensions.constant(<String, int>{'Length': 1, 'Time': -1}, qType: Speed);

  /// The standard SI unit.
  static final SpeedUnits metersPerSecond =
      SpeedUnits.lengthTime(LengthUnits.meters, Time.seconds);

  /// Accepted for use with the SI, subject to further review.
  static final SpeedUnits knots =
      SpeedUnits('knots', null, null, null, 5.144444444e-1, false);
}

/// Units acceptable for use in describing Speed quantities.
class SpeedUnits extends Speed with Units {
  /// Constructs a instance.
  SpeedUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance based on length and time units.
  SpeedUnits.lengthTime(LengthUnits lu, TimeUnits tu)
      : super.misc(lu.valueSI / tu.valueSI) {
    name = '${lu.name} per ${tu.singular}';
    singular = '${lu.singular} per ${tu.singular}';
    convToMKS = lu.valueSI / tu.valueSI;
    abbrev1 = lu.abbrev1 != null && tu.abbrev1 != null
        ? '${lu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = lu.abbrev2 != null && tu.abbrev2 != null
        ? '${lu.abbrev2}/${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Speed;

  /// Derive SpeedUnits using this SpeedUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SpeedUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
