import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';
import 'mass.dart';
import 'temperature_interval.dart';

// Also SpecificEntropy

/// The heat capacity per unit mass of a material.
/// See the [Wikipedia entry for Heat capacity](https://en.wikipedia.org/wiki/Heat_capacity)
/// for more information.
class SpecificHeatCapacity extends Quantity {
  /// Constructs a SpecificHeatCapacity with joules per kilogram kelvin.
  /// Optionally specify a relative standard uncertainty.
  SpecificHeatCapacity({dynamic joulesPerKilogramKelvin, double uncert = 0.0})
      : super(joulesPerKilogramKelvin ?? 0.0,
            SpecificHeatCapacity.joulesPerKilogramKelvin, uncert);

  /// Constructs a instance without preferred units.
  SpecificHeatCapacity.misc(dynamic conv)
      : super.misc(conv, SpecificHeatCapacity.specificHeatCapacityDimensions);

  /// Constructs a SpecificHeatCapacity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  SpecificHeatCapacity.inUnits(dynamic value, SpecificHeatCapacityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? SpecificHeatCapacity.joulesPerKilogramKelvin,
            uncert);

  /// Constructs a constant SpecificHeatCapacity.
  const SpecificHeatCapacity.constant(Number valueSI,
      {SpecificHeatCapacityUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            SpecificHeatCapacity.specificHeatCapacityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions specificHeatCapacityDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2, 'Temperature': -1},
      qType: SpecificHeatCapacity);

  /// The standard SI unit.
  static final SpecificHeatCapacityUnits joulesPerKilogramKelvin =
      SpecificHeatCapacityUnits.energyMassTemperature(
          Energy.joules, Mass.kilograms, TemperatureInterval.kelvins);
}

/// Units acceptable for use in describing SpecificHeatCapacity quantities.
class SpecificHeatCapacityUnits extends SpecificHeatCapacity with Units {
  /// Constructs a instance.
  SpecificHeatCapacityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from energy, mass and temperature interval units.
  SpecificHeatCapacityUnits.energyMassTemperature(
      EnergyUnits eu, MassUnits mu, TemperatureIntervalUnits tu)
      : super.misc(eu.valueSI / (mu.valueSI * tu.valueSI)) {
    name = '${eu.name} per ${mu.singular} ${tu.singular}';
    singular = '${eu.singular} per ${mu.singular} ${tu.singular}';
    convToMKS = eu.valueSI / (mu.valueSI * tu.valueSI);
    abbrev1 = eu.abbrev1 != null && mu.abbrev1 != null
        ? '${eu.abbrev1} / ${mu.abbrev1} ${tu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && mu.abbrev2 != null
        ? '${eu.abbrev2}${mu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => SpecificHeatCapacity;

  /// Derive SpecificHeatCapacityUnits using this SpecificHeatCapacityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SpecificHeatCapacityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
