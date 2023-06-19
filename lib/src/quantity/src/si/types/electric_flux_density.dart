import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'charge.dart';

/// A measure of the intensity of an electric field generated by a free electric charge,
/// corresponding to the number of electric field lines passing through a given area.
/// See the [Wikipedia entry for Electric_flux](https://en.wikipedia.org/wiki/Electric_flux)
/// for more information.
class ElectricFluxDensity extends Quantity {
  /// Construct an ElectricFluxDensity with coulombs per square meter.
  /// Optionally specify a relative standard uncertainty.
  ElectricFluxDensity({dynamic coulombsPerSquareMeter, double uncert = 0.0})
      : super(coulombsPerSquareMeter ?? 0.0,
            ElectricFluxDensity.coulombsPerSquareMeter, uncert);

  /// Constructs a instance without preferred units.
  ElectricFluxDensity.misc(dynamic conv)
      : super.misc(conv, ElectricFluxDensity.electricFluxDensityDimensions);

  /// Constructs a ElectricFluxDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ElectricFluxDensity.inUnits(dynamic value, ElectricFluxDensityUnits? units,
      [double uncert = 0.0])
      : super(
            value, units ?? ElectricFluxDensity.coulombsPerSquareMeter, uncert);

  /// Constructs a constant ElectricFluxDensity.
  const ElectricFluxDensity.constant(Number valueSI,
      {ElectricFluxDensityUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            ElectricFluxDensity.electricFluxDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricFluxDensityDimensions = Dimensions.constant(
      <String, int>{'Current': 1, 'Time': 1, 'Length': -2},
      qType: ElectricFluxDensity);

  /// The standard SI unit.
  static final ElectricFluxDensityUnits coulombsPerSquareMeter =
      ElectricFluxDensityUnits.chargeArea(Charge.coulombs, Area.squareMeters);
}

/// Units acceptable for use in describing ElectricFluxDensity quantities.
class ElectricFluxDensityUnits extends ElectricFluxDensity with Units {
  /// Constructs a instance.
  ElectricFluxDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from a charge and an area.
  ElectricFluxDensityUnits.chargeArea(ChargeUnits ecu, AreaUnits au)
      : super.misc(ecu.valueSI * au.valueSI) {
    name = '${ecu.name} per ${au.singular}';
    singular = '${ecu.singular} per ${au.singular}';
    convToMKS = ecu.valueSI * au.valueSI;
    abbrev1 = ecu.abbrev1 != null && au.abbrev1 != null
        ? '${ecu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = ecu.abbrev2 != null && au.abbrev2 != null
        ? '${ecu.abbrev2}/${au.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => ElectricFluxDensity;

  /// Derive ElectricFluxDensityUnits using this ElectricFluxDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ElectricFluxDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
