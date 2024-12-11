import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'amount_of_substance.dart';
import 'energy.dart';
import 'temperature_interval.dart';

/// Entropy content per mole of substance.
/// See the [Wikipedia entry for Standard molar entropy](https://en.wikipedia.org/wiki/Standard_molar_entropy)
/// for more information.
class MolarEntropy extends Quantity {
  /// Constructs a MolarEntropy with joules per mole kelvin.
  /// Optionally specify a relative standard uncertainty.
  MolarEntropy({dynamic joulesPerMoleKelvin, double uncert = 0.0})
      : super(joulesPerMoleKelvin ?? 0.0, MolarEntropy.joulesPerMoleKelvin,
            uncert);

  /// Constructs a instance without preferred units.
  MolarEntropy.misc(dynamic conv)
      : super.misc(conv, MolarEntropy.molarEntropyDimensions);

  /// Constructs a MolarEntropy based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MolarEntropy.inUnits(dynamic value, MolarEntropyUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MolarEntropy.joulesPerMoleKelvin, uncert);

  /// Constructs a constant MolarEntropy.
  const MolarEntropy.constant(Number valueSI,
      {MolarEntropyUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MolarEntropy.molarEntropyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions molarEntropyDimensions =
      Dimensions.constant(<String, int>{
    'Mass': 1,
    'Length': 2,
    'Time': -2,
    'Amount': -1,
    'Temperature': -1
  }, qType: MolarEntropy);

  /// The standard SI unit.
  static final MolarEntropyUnits joulesPerMoleKelvin =
      MolarEntropyUnits.energyAmountTemperature(
          Energy.joules, AmountOfSubstance.moles, TemperatureInterval.kelvins);
}

/// Units acceptable for use in describing MolarEntropy quantities.
class MolarEntropyUnits extends MolarEntropy with Units {
  /// Constructs a instance.
  MolarEntropyUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from energy, amount of substance and temperature interval units.
  MolarEntropyUnits.energyAmountTemperature(
      EnergyUnits eu, AmountOfSubstanceUnits aosu, TemperatureIntervalUnits tu)
      : super.misc(eu.valueSI / (aosu.valueSI * tu.valueSI)) {
    name = '${eu.name} per ${aosu.singular} ${tu.singular}';
    singular = '${eu.singular} per ${aosu.singular} ${tu.singular}';
    convToMKS = eu.valueSI / (aosu.valueSI * tu.valueSI);
    abbrev1 = eu.abbrev1 != null && aosu.abbrev1 != null
        ? '${eu.abbrev1} / ${aosu.abbrev1} ${tu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && aosu.abbrev2 != null
        ? '${eu.abbrev2}/${aosu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => MolarEntropy;

  /// Derive MolarEntropyUnits using this MolarEntropyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MolarEntropyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
