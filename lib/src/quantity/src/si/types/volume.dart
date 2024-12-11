import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import '../../../quantity_ext.dart';

/// The amount of three-dimensional space enclosed by some closed boundary.
/// See the [Wikipedia entry for Volume](https://en.wikipedia.org/wiki/Volume)
/// for more information.
class Volume extends Quantity {
  /// Constructs a Volume with cubic meters ([m3]) or liters ([L]).
  /// Optionally specify a relative standard uncertainty.
  Volume({dynamic m3, dynamic L, double uncert = 0.0})
      : super(m3 ?? (L ?? 0.0), L != null ? Volume.liters : Volume.cubicMeters,
            uncert);

  /// Constructs a instance without preferred units.
  Volume.misc(dynamic conv) : super.misc(conv, Volume.volumeDimensions);

  /// Constructs a Volume based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Volume.inUnits(dynamic value, VolumeUnits? units, [double uncert = 0.0])
      : super(value, units ?? Volume.cubicMeters, uncert);

  /// Constructs a constant Volume.
  const Volume.constant(Number valueSI,
      {VolumeUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Volume.volumeDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions volumeDimensions =
      Dimensions.constant(<String, int>{'Length': -3}, qType: Volume);

  /// The standard SI unit.
  static final VolumeUnits cubicMeters =
      VolumeUnits.lengthCubed(LengthUnits.meters);

  /// Accepted for use with the SI; equal to one thousandth of a cubic meter.
  static final VolumeUnits liters =
      VolumeUnits('liters', null, 'L', null, 1.0e-3, true);
}

/// Units acceptable for use in describing Volume quantities.
class VolumeUnits extends Volume with Units {
  /// Constructs a instance.
  VolumeUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance based on length units.
  VolumeUnits.lengthCubed(LengthUnits lu) : super.misc(lu.valueSI ^ 3) {
    name = 'cubic ${lu.name}';
    singular = 'cubic ${lu.singular}';
    convToMKS = lu.valueSI ^ 3;
    abbrev1 = lu.abbrev1 != null ? '${lu.abbrev1}3' : null;
    abbrev2 = lu.abbrev2 != null ? '${lu.abbrev2}3' : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Volume;

  /// Derive VolumeUnits using this VolumeUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      VolumeUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
