import '../../../quantity_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';
import 'mass.dart';
import 'speed.dart';
import 'time.dart';

// Also ImpartedSpecificEnergy, Kerma

/// Energy per unit mass.
/// See the [Wikipedia entry for Specific energy](https://en.wikipedia.org/wiki/Specific_energy)
/// for more information.
class SpecificEnergy extends Quantity {
  /// Constructs a SpecificEnergy with joules per kilogram.
  /// Optionally specify a relative standard uncertainty.
  SpecificEnergy({dynamic joulesPerKilogram, double uncert = 0.0})
      : super(
            joulesPerKilogram ?? 0.0, SpecificEnergy.joulesPerKilogram, uncert);

  /// Constructs a instance without preferred units.
  SpecificEnergy.misc(dynamic conv)
      : super.misc(conv, SpecificEnergy.specificEnergyDimensions);

  /// Constructs a SpecificEnergy based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  SpecificEnergy.inUnits(dynamic value, SpecificEnergyUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? SpecificEnergy.joulesPerKilogram, uncert);

  /// Constructs a constant SpecificEnergy.
  const SpecificEnergy.constant(Number valueSI,
      {SpecificEnergyUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, SpecificEnergy.specificEnergyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions specificEnergyDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2},
      qType: SpecificEnergy);

  /// The standard SI unit.
  static final SpecificEnergyUnits joulesPerKilogram =
      SpecificEnergyUnits.energyMass(Energy.joules, Mass.kilograms);
}

/// Units acceptable for use in describing SpecificEnergy quantities.
class SpecificEnergyUnits extends SpecificEnergy with Units {
  /// Constructs a instance.
  SpecificEnergyUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on energy and mass units.
  SpecificEnergyUnits.energyMass(EnergyUnits eu, MassUnits mu)
      : super.misc(eu.valueSI / mu.valueSI) {
    name = '${eu.name} per ${mu.singular}';
    singular = '${eu.singular} per ${mu.singular}';
    convToMKS = eu.valueSI / mu.valueSI;
    abbrev1 = eu.abbrev1 != null && mu.abbrev1 != null
        ? '${eu.abbrev1} / ${mu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && mu.abbrev2 != null
        ? '${eu.abbrev2}/${mu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Constructs a instance based on length and time units.
  SpecificEnergyUnits.lengthTime(LengthUnits lu, TimeUnits tu)
      : super.misc(lu.valueSI * lu.valueSI / (tu.valueSI * tu.valueSI)) {
    name = '${lu.name} squared per ${tu.singular} squared';
    singular = '${lu.singular} squared per ${tu.singular} squared';
    convToMKS = lu.valueSI * lu.valueSI / (tu.valueSI * tu.valueSI);
    abbrev1 = lu.abbrev1 != null && tu.abbrev1 != null
        ? '${lu.abbrev1} sq./ ${tu.abbrev1} sq.'
        : null;
    abbrev2 = lu.abbrev2 != null && tu.abbrev2 != null
        ? '${lu.abbrev2}^2/${tu.abbrev2}^2'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Constructs a instance based on speed units.
  SpecificEnergyUnits.speed(SpeedUnits su) : super.misc(su.valueSI) {
    name = '${su.name} squared';
    singular = '${su.singular} squared';
    convToMKS = su.valueSI;
    abbrev1 = su.abbrev1 != null ? '${su.abbrev1} sq.' : null;
    abbrev2 = su.abbrev2 != null ? '${su.abbrev2}^2' : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => SpecificEnergy;

  /// Derive SpecificEnergyUnits using this SpecificEnergyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SpecificEnergyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
