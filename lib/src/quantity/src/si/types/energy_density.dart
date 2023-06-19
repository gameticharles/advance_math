import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';
import 'volume.dart';

/// The amount of energy stored in a given system or region of space per unit volume.
/// See the [Wikipedia entry for Energy density](https://en.wikipedia.org/wiki/Energy_density)
/// for more information.
class EnergyDensity extends Quantity {
  /// Construct an EnergyDensity with joules per cubic meter.
  /// Optionally specify a relative standard uncertainty.
  EnergyDensity({dynamic joulesPerCubicMeter, double uncert = 0.0})
      : super(joulesPerCubicMeter ?? 0.0, EnergyDensity.joulesPerCubicMeter,
            uncert);

  /// Constructs a instance without preferred units.
  EnergyDensity.misc(dynamic conv)
      : super.misc(conv, EnergyDensity.energyDensityDimensions);

  /// Constructs a EnergyDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  EnergyDensity.inUnits(dynamic value, EnergyDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? EnergyDensity.joulesPerCubicMeter, uncert);

  /// Constructs a constant EnergyDensity.
  const EnergyDensity.constant(Number valueSI,
      {EnergyDensityUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, EnergyDensity.energyDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions energyDensityDimensions = Dimensions.constant(
      <String, int>{'Length': -1, 'Mass': 1, 'Time': -2},
      qType: EnergyDensity);

  /// The standard SI unit.
  static final EnergyDensityUnits joulesPerCubicMeter =
      EnergyDensityUnits.energyVolume(Energy.joules, Volume.cubicMeters);
}

/// Units acceptable for use in describing EnergyDensity quantities.
class EnergyDensityUnits extends EnergyDensity with Units {
  /// Constructs a instance.
  EnergyDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on energy and volume units.
  EnergyDensityUnits.energyVolume(EnergyUnits eu, VolumeUnits vu)
      : super.misc(eu.valueSI * vu.valueSI) {
    name = '${eu.name} per ${vu.singular}';
    singular = '${eu.singular} per ${vu.singular}';
    convToMKS = eu.valueSI * vu.valueSI;
    abbrev1 = eu.abbrev1 != null && vu.abbrev1 != null
        ? '${eu.abbrev1} / ${vu.abbrev1}'
        : null;
    abbrev2 = eu.abbrev2 != null && vu.abbrev2 != null
        ? '${eu.abbrev2}/${vu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => EnergyDensity;

  /// Derive EnergyDensityUnits using this EnergyDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      EnergyDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
