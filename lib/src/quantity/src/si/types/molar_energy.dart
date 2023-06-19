import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'amount_of_substance.dart';
import 'energy.dart';

/// Energy per mole of a substance.
/// See the [Wikipedia entry for Specific energy](https://en.wikipedia.org/wiki/Specific_energy)
/// for more information.
class MolarEnergy extends Quantity {
  /// Constructs a MolarEnergy with joules per mole.
  /// Optionally specify a relative standard uncertainty.
  MolarEnergy({dynamic joulesPerMole, double uncert = 0.0})
      : super(joulesPerMole ?? 0.0, MolarEnergy.joulesPerMole, uncert);

  /// Constructs a instance without preferred units.
  MolarEnergy.misc(dynamic conv)
      : super.misc(conv, MolarEnergy.molarEnergyDimensions);

  /// Constructs a MolarEnergy based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MolarEnergy.inUnits(dynamic value, MolarEnergyUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MolarEnergy.joulesPerMole, uncert);

  /// Constructs a constant MolarEnergy.
  const MolarEnergy.constant(Number valueSI,
      {MolarEnergyUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MolarEnergy.molarEnergyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions molarEnergyDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Length': 2, 'Time': -2, 'Amount': -1},
      qType: MolarEnergy);

  /// The standard SI unit.
  static final MolarEnergyUnits joulesPerMole =
      MolarEnergyUnits.energyAmount(Energy.joules, AmountOfSubstance.moles);
}

/// Units acceptable for use in describing MolarEnergy quantities.
class MolarEnergyUnits extends MolarEnergy with Units {
  /// Constructs a instance.
  MolarEnergyUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on energy and amount of substance units.
  MolarEnergyUnits.energyAmount(EnergyUnits eu, AmountOfSubstanceUnits aosu)
      : super.misc(eu.valueSI * aosu.valueSI) {
    name = '${eu.name} per ${aosu.singular}';
    singular = '${eu.singular} per ${aosu.singular}';
    convToMKS = eu.valueSI * aosu.valueSI;
    abbrev1 = eu.abbrev1 != null && aosu.abbrev1 != null
        ? '${eu.abbrev1} / ${aosu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && aosu.abbrev2 != null
        ? '${eu.abbrev2}${aosu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => MolarEnergy;

  /// Derive MolarEnergyUnits using this MolarEnergyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MolarEnergyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
