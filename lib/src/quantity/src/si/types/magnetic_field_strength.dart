import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'current.dart';

/// The intensity of a magnetic field.
/// See the [Wikipedia entry for Magnetic field](https://en.wikipedia.org/wiki/Magnetic_field)
/// for more information.
class MagneticFieldStrength extends Quantity {
  /// Constructs a MagneticFieldStrength with amperes per meter.
  /// Optionally specify a relative standard uncertainty.
  MagneticFieldStrength({dynamic amperesPerMeter, double uncert = 0.0})
      : super(amperesPerMeter ?? 0.0, MagneticFieldStrength.amperesPerMeter,
            uncert);

  /// Constructs a instance without preferred units.
  MagneticFieldStrength.misc(dynamic conv)
      : super.misc(conv, MagneticFieldStrength.magneticFieldStrengthDimensions);

  /// Constructs a MagneticFieldStrength based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MagneticFieldStrength.inUnits(
      dynamic value, MagneticFieldStrengthUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MagneticFieldStrength.amperesPerMeter, uncert);

  /// Constructs a constant MagneticFieldStrength.
  const MagneticFieldStrength.constant(Number valueSI,
      {MagneticFieldStrengthUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI,
            MagneticFieldStrength.magneticFieldStrengthDimensions,
            units,
            uncert);

  /// Dimensions for this type of quantity
  static const Dimensions magneticFieldStrengthDimensions = Dimensions.constant(
      <String, int>{'Length': -1, 'Current': 1},
      qType: MagneticFieldStrength);

  /// The standard SI unit.
  static final MagneticFieldStrengthUnits amperesPerMeter =
      MagneticFieldStrengthUnits.currentLength(
          Current.amperes, LengthUnits.meters);
}

/// Units acceptable for use in describing MagneticFieldStrength quantities.
class MagneticFieldStrengthUnits extends MagneticFieldStrength with Units {
  /// Constructs a instance.
  MagneticFieldStrengthUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on electric current and length units.
  MagneticFieldStrengthUnits.currentLength(CurrentUnits ecu, LengthUnits lu)
      : super.misc(ecu.valueSI * lu.valueSI) {
    name = '${ecu.name} per ${lu.singular}';
    singular = '${ecu.singular} per ${lu.singular}';
    convToMKS = ecu.valueSI * lu.valueSI;
    abbrev1 = ecu.abbrev1 != null && lu.abbrev1 != null
        ? '${ecu.abbrev1} / ${lu.abbrev1}'
        : null;
    abbrev2 = ecu.abbrev2 != null && lu.abbrev2 != null
        ? '${ecu.abbrev2}${lu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => MagneticFieldStrength;

  /// Derive MagneticFieldStrengthUnits using this MagneticFieldStrengthUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MagneticFieldStrengthUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
