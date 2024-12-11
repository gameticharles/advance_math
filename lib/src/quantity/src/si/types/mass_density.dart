import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'mass.dart';
import 'volume.dart';

/// Mass per unit volume.
/// See the [Wikipedia entry for Density](https://en.wikipedia.org/wiki/Density)
/// for more information.
class MassDensity extends Quantity {
  /// Constructs a MassDensity with kilograms per cubic meter.
  /// Optionally specify a relative standard uncertainty.
  MassDensity({dynamic kilogramsPerCubicMeter, double uncert = 0.0})
      : super(kilogramsPerCubicMeter ?? 0.0, MassDensity.kilogramsPerCubicMeter,
            uncert);

  /// Constructs a instance without preferred units.
  MassDensity.misc(dynamic conv)
      : super.misc(conv, MassDensity.massDensityDimensions);

  /// Constructs a MassDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MassDensity.inUnits(dynamic value, MassDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MassDensity.kilogramsPerCubicMeter, uncert);

  /// Constructs a constant MassDensity.
  const MassDensity.constant(Number valueSI,
      {MassDensityUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MassDensity.massDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions massDensityDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Length': -3},
      qType: MassDensity);

  /// The standard SI unit.
  static final MassDensityUnits kilogramsPerCubicMeter =
      MassDensityUnits.massVolume(Mass.kilograms, Volume.cubicMeters);
}

/// Units acceptable for use in describing MassDensity quantities.
class MassDensityUnits extends MassDensity with Units {
  /// Constructs a instance.
  MassDensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance from mass and volume units.
  MassDensityUnits.massVolume(MassUnits mu, VolumeUnits vu)
      : super.misc(mu.valueSI * vu.valueSI) {
    name = '${mu.name} per ${vu.singular}';
    singular = '${mu.singular} per ${vu.singular}';
    convToMKS = mu.valueSI * vu.valueSI;
    abbrev1 = mu.abbrev1 != null && vu.abbrev1 != null
        ? '${mu.abbrev1} / ${vu.abbrev1}'
        : null;
    abbrev2 = mu.abbrev2 != null && vu.abbrev2 != null
        ? '${mu.abbrev2}${vu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => MassDensity;

  /// Derive MassDensityUnits using this MassDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MassDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
