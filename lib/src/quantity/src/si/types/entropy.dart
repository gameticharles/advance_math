import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';
import 'temperature_interval.dart';

// Also HeatCapacity.

/// The number of specific ways in which a thermodynamic system may be arranged,
/// commonly understood as a measure of disorder.
/// See the [Wikipedia entry for Entropy](https://en.wikipedia.org/wiki/Entropy)
/// for more information.
class Entropy extends Quantity {
  /// Constructs an Entropy with joules per kelvin.
  /// Optionally specify a relative standard uncertainty.
  Entropy({dynamic joulesPerKelvin, double uncert = 0.0})
      : super(joulesPerKelvin ?? 0.0, Entropy.joulesPerKelvin, uncert);

  /// Constructs a instance without preferred units.
  Entropy.misc(dynamic conv) : super.misc(conv, Entropy.entropyDimensions);

  /// Constructs a Entropy based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Entropy.inUnits(dynamic value, EntropyUnits? units, [double uncert = 0.0])
      : super(value, units ?? Entropy.joulesPerKelvin, uncert);

  /// Constructs a constant Entropy.
  const Entropy.constant(Number valueSI,
      {EntropyUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Entropy.entropyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions entropyDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Temperature': -1, 'Time': -2},
      qType: Entropy);

  /// The standard SI unit.
  static final EntropyUnits joulesPerKelvin = EntropyUnits.energyTemperature(
      Energy.joules, TemperatureInterval.kelvins);
}

/// Units acceptable for use in describing Entropy quantities.
class EntropyUnits extends Entropy with Units {
  /// Constructs a instance.
  EntropyUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance based on energy and temperature interval units.
  EntropyUnits.energyTemperature(EnergyUnits eu, TemperatureIntervalUnits tu)
      : super.misc(eu.valueSI * tu.valueSI) {
    name = '${eu.name} per ${tu.singular}';
    singular = '${eu.singular} per ${tu.singular}';
    convToMKS = eu.valueSI * tu.valueSI;
    abbrev1 = eu.abbrev1 != null && tu.abbrev1 != null
        ? '${eu.abbrev1} / ${tu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && tu.abbrev2 != null
        ? '${eu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Entropy;

  /// Derive EntropyUnits using this EntropyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      EntropyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
