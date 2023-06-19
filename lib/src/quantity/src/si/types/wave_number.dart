import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The spatial frequency of a wave.
/// See the [Wikipedia entry for Wavenumber](https://en.wikipedia.org/wiki/Wavenumber)
/// for more information.
class WaveNumber extends Quantity {
  /// Constructs a WaveNumber with reciprocal meters.
  /// Optionally specify a relative standard uncertainty.
  WaveNumber({dynamic reciprocalMeters, double uncert = 0.0})
      : super(reciprocalMeters ?? 0.0, WaveNumber.reciprocalMeters, uncert);

  /// Constructs a instance without preferred units.
  WaveNumber.misc(dynamic conv)
      : super.misc(conv, WaveNumber.waveNumberDimensions);

  /// Constructs a WaveNumber based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  WaveNumber.inUnits(dynamic value, WaveNumberUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? WaveNumber.reciprocalMeters, uncert);

  /// Constructs a constant WaveNumber.
  const WaveNumber.constant(Number valueSI,
      {WaveNumberUnits? units, double uncert = 0.0})
      : super.constant(valueSI, WaveNumber.waveNumberDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions waveNumberDimensions =
      Dimensions.constant(<String, int>{'Length': -1}, qType: WaveNumber);

  /// The standard SI unit.
  static final WaveNumberUnits reciprocalMeters =
      WaveNumberUnits.inverseLength(LengthUnits.meters);
}

/// Units acceptable for use in describing WaveNumber quantities.
class WaveNumberUnits extends WaveNumber with Units {
  /// Constructs a instance.
  WaveNumberUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on length units.
  WaveNumberUnits.inverseLength(LengthUnits lu)
      : super.misc(Integer.one / lu.valueSI) {
    name = 'reciprocal ${lu.name}';
    singular = 'reciprocal ${lu.singular}';
    convToMKS = Integer.one / lu.valueSI;
    abbrev1 = lu.abbrev1 != null ? '1 / ${lu.abbrev1}' : null;
    abbrev2 = lu.abbrev2 != null ? '${lu.abbrev2}-1' : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => WaveNumber;

  /// Derive WaveNumberUnits using this WaveNumberUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      WaveNumberUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
