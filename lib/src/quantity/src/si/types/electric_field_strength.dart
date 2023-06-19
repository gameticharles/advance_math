import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'electric_potential_difference.dart';

/// The magnitude of the force per unit charge that an electric field exerts.
/// See the [Wikipedia entry for Electric field](https://en.wikipedia.org/wiki/Electric_field)
/// for more information.
class ElectricFieldStrength extends Quantity {
  /// Constructs an ElectricFieldStrength with volts per meter.
  /// Optionally specify a relative standard uncertainty.
  ElectricFieldStrength({dynamic voltsPerMeter, double uncert = 0.0})
      : super(
            voltsPerMeter ?? 0.0, ElectricFieldStrength.voltsPerMeter, uncert);

  /// Constructs a instance without preferred units.
  ElectricFieldStrength.misc(dynamic conv)
      : super.misc(conv, ElectricFieldStrength.electricFieldStrengthDimensions);

  /// Constructs an ElectricFieldStrength based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ElectricFieldStrength.inUnits(
      dynamic value, ElectricFieldStrengthUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? ElectricFieldStrength.voltsPerMeter, uncert);

  /// Constructs a constant ElectricFieldStrength.
  const ElectricFieldStrength.constant(Number valueSI,
      {ElectricFieldStrengthUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI,
            ElectricFieldStrength.electricFieldStrengthDimensions,
            units,
            uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricFieldStrengthDimensions = Dimensions.constant(
      <String, int>{'Current': -1, 'Time': -3, 'Length': 1, 'Mass': 1},
      qType: ElectricFieldStrength);

  /// The standard SI unit.
  static final ElectricFieldStrengthUnits voltsPerMeter =
      ElectricFieldStrengthUnits.potentialLength(
          ElectricPotentialDifference.volts, LengthUnits.meters);
}

/// Units acceptable for use in describing ElectricFieldStrength quantities.
class ElectricFieldStrengthUnits extends ElectricFieldStrength with Units {
  /// Constructs a instance.
  ElectricFieldStrengthUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from a potential difference and length.
  ElectricFieldStrengthUnits.potentialLength(
      ElectricPotentialDifferenceUnits epdu, LengthUnits lu)
      : super.misc(epdu.valueSI * lu.valueSI) {
    name = '${epdu.name} per ${lu.singular}';
    singular = '${epdu.singular} per ${lu.singular}';
    convToMKS = epdu.valueSI * lu.valueSI;
    abbrev1 = epdu.abbrev1 != null && lu.abbrev1 != null
        ? '${epdu.abbrev1} / ${lu.abbrev1}'
        : null;
    abbrev2 = epdu.abbrev2 != null && lu.abbrev2 != null
        ? '${epdu.abbrev2}/${lu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => ElectricFieldStrength;

  /// Derive ElectricFieldStrengthUnits using this ElectricFieldStrengthUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ElectricFieldStrengthUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
