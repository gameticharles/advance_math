import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'mass.dart';

/// The ratio of the substance's volume to its mass.
/// See the [Wikipedia entry for Specific volume](https://en.wikipedia.org/wiki/Specific_volume)
/// for more information.
class SpecificVolume extends Quantity {
  /// Constructs a SpecificVolume with cubic meters per kilogram.
  /// Optionally specify a relative standard uncertainty.
  SpecificVolume({dynamic cubicMetersPerKilogram, double uncert = 0.0})
      : super(cubicMetersPerKilogram ?? 0.0,
            SpecificVolume.cubicMetersPerKilogram, uncert);

  /// Constructs a instance without preferred units.
  SpecificVolume.misc(dynamic conv)
      : super.misc(conv, SpecificVolume.specificVolumeDimensions);

  /// Constructs a SpecificVolume based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  SpecificVolume.inUnits(dynamic value, SpecificVolumeUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? SpecificVolume.cubicMetersPerKilogram, uncert);

  /// Constructs a constant SpecificVolume.
  const SpecificVolume.constant(Number valueSI,
      {SpecificVolumeUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, SpecificVolume.specificVolumeDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions specificVolumeDimensions = Dimensions.constant(
      <String, int>{'Length': 3, 'Mass': -1},
      qType: SpecificVolume);

  /// The standard SI unit.
  static final SpecificVolumeUnits cubicMetersPerKilogram =
      SpecificVolumeUnits.lengthMass(LengthUnits.meters, Mass.kilograms);
}

/// Units acceptable for use in describing SpecificVolume quantities.
class SpecificVolumeUnits extends SpecificVolume with Units {
  /// Constructs a instance.
  SpecificVolumeUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance base don length and mass units.
  SpecificVolumeUnits.lengthMass(LengthUnits lu, MassUnits mu)
      : super.misc(lu.valueSI / mu.valueSI) {
    name = '${lu.name} per ${mu.singular}';
    singular = '${lu.singular} per ${mu.singular}';
    convToMKS = lu.valueSI / mu.valueSI;
    abbrev1 = lu.abbrev1 != null && mu.abbrev1 != null
        ? '${lu.abbrev1} / ${mu.abbrev1}'
        : null;
    abbrev2 = lu.abbrev2 != null && mu.abbrev2 != null
        ? '${lu.abbrev2}${mu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => SpecificVolume;

  /// Derive SpecificVolumeUnits using this SpecificVolumeUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SpecificVolumeUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
