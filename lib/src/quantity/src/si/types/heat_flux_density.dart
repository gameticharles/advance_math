import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'power.dart';

// Also EnergyFluxDensity, Irradiance, PowerFluxDensity

/// Heat rate per unit area.
/// See the [Wikipedia entry for Heat flux](https://en.wikipedia.org/wiki/Heat_flux)
/// for more information.
class HeatFluxDensity extends Quantity {
  /// Constructs a HeatFluxDensity with watts per square meter.
  /// Optionally specify a relative standard uncertainty.
  HeatFluxDensity({dynamic wattsPerSquareMeter, double uncert = 0.0})
      : super(wattsPerSquareMeter ?? 0.0, HeatFluxDensity.wattsPerSquareMeter,
            uncert);

  /// Constructs a instance without preferred units.
  HeatFluxDensity.misc(dynamic conv)
      : super.misc(conv, HeatFluxDensity.heatFluxDensityDimensions);

  /// Constructs a HeatFluxDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  HeatFluxDensity.inUnits(dynamic value, HeatFluxDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? HeatFluxDensity.wattsPerSquareMeter, uncert);

  /// Constructs a constant HeatFluxDensity.
  const HeatFluxDensity.constant(Number valueSI,
      {HeatFluxDensityUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, HeatFluxDensity.heatFluxDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions heatFluxDensityDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Time': -3},
      qType: HeatFluxDensity);

  /// The standard SI unit.
  static final HeatFluxDensityUnits wattsPerSquareMeter =
      HeatFluxDensityUnits.powerArea(Power.watts, Area.squareMeters);
}

/// Units acceptable for use in describing HeatFluxDensity quantities.
class HeatFluxDensityUnits extends HeatFluxDensity with Units {
  /// Constructs a instance.
  HeatFluxDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from power and area units.
  HeatFluxDensityUnits.powerArea(PowerUnits pu, AreaUnits au)
      : super.misc(pu.valueSI * au.valueSI) {
    name = '${pu.name} per ${au.singular}';
    singular = '${pu.singular} per ${au.singular}';
    convToMKS = pu.valueSI * au.valueSI;
    abbrev1 = pu.abbrev1 != null && au.abbrev1 != null
        ? '${pu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = pu.abbrev2 != null && au.abbrev2 != null
        ? '${pu.abbrev2}${au.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => HeatFluxDensity;

  /// Derive HeatFluxDensityUnits using this HeatFluxDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      HeatFluxDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
