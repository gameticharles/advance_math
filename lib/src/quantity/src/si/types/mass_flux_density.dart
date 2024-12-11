import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'mass.dart';
import 'time.dart';

/// The mass of a substance which passes per unit of time.
/// See the [Wikipedia entry for Mass flow rate](https://en.wikipedia.org/wiki/Mass_flow_rate)
/// for more information.
class MassFluxDensity extends Quantity {
  /// Constructs a MassFluxDensity with kilograms per second per square meter.
  /// Optionally specify a relative standard uncertainty.
  MassFluxDensity(
      {dynamic kilogramsPerSecondPerSquareMeter, double uncert = 0.0})
      : super(kilogramsPerSecondPerSquareMeter ?? 0.0,
            MassFluxDensity.kilogramsPerSecondPerSquareMeter, uncert);

  /// Constructs a instance without preferred units.
  MassFluxDensity.misc(dynamic conv)
      : super.misc(conv, MassFluxDensity.massFluxDensityDimensions);

  /// Constructs a MassFluxDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MassFluxDensity.inUnits(dynamic value, MassFluxDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MassFluxDensity.kilogramsPerSecondPerSquareMeter,
            uncert);

  /// Constructs a constant MassFluxDensity.
  const MassFluxDensity.constant(Number valueSI,
      {MassFluxDensityUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MassFluxDensity.massFluxDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions massFluxDensityDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Time': -1, 'Length': -2},
      qType: MassFluxDensity);

  /// The standard SI unit.
  static final MassFluxDensityUnits kilogramsPerSecondPerSquareMeter =
      MassFluxDensityUnits.massTimeArea(
          Mass.kilograms, Time.seconds, Area.squareMeters);
}

/// Units acceptable for use in describing MassFluxDensity quantities.
class MassFluxDensityUnits extends MassFluxDensity with Units {
  /// Constructs a instance.
  MassFluxDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on mass, time and area units.
  MassFluxDensityUnits.massTimeArea(MassUnits mu, TimeUnits tu, AreaUnits au)
      : super.misc(mu.valueSI / (tu.valueSI * au.valueSI)) {
    name = '${mu.name} per ${tu.singular} per ${au.singular}';
    singular = '${mu.singular} per ${tu.singular} per ${au.singular}';
    convToMKS = mu.valueSI / (tu.valueSI * au.valueSI);
    abbrev1 = mu.abbrev1 != null && tu.abbrev1 != null
        ? '${mu.abbrev1} / ${tu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = mu.abbrev2 != null && tu.abbrev2 != null
        ? '${mu.abbrev2}/${tu.abbrev2}/${au.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => MassFluxDensity;

  /// Derive MassFluxDensityUnits using this MassFluxDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MassFluxDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
