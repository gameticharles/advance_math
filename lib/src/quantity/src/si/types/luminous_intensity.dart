import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Represents the *luminous intensity* physical quantity (one of the seven
/// base SI quantities), the wavelength-weighted power emitted by a light source
/// in a particular direction per unit solid angle.
/// See the [Wikipedia entry for Luminous intensity](https://en.wikipedia.org/wiki/Luminous_intensity)
/// for more information.
class LuminousIntensity extends Quantity {
  /// Constructs a LuminousIntensity with candelas ([cd]).
  /// Optionally specify a relative standard uncertainty.
  LuminousIntensity({dynamic cd, double uncert = 0.0})
      : super(cd ?? 0.0, LuminousIntensity.candelas, uncert);

  /// Constructs a instance without preferred units.
  LuminousIntensity.misc(dynamic conv)
      : super.misc(conv, LuminousIntensity.luminousIntensityDimensions);

  /// Constructs a LuminousIntensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  LuminousIntensity.inUnits(dynamic value, LuminousIntensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? LuminousIntensity.candelas, uncert);

  /// Constructs a constant LuminousIntensity.
  const LuminousIntensity.constant(Number valueSI,
      {LuminousIntensityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, LuminousIntensity.luminousIntensityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions luminousIntensityDimensions = Dimensions.constant(
      <String, int>{'Intensity': 1},
      qType: LuminousIntensity);

  /// The standard SI unit.
  static final LuminousIntensityUnits candelas =
      LuminousIntensityUnits('candelas', 'cd', null, null, 1.0, true);
}

/// Units acceptable for use in describing [LuminousIntensity] quantities.
class LuminousIntensityUnits extends LuminousIntensity with Units {
  /// Constructs a instance.
  LuminousIntensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => LuminousIntensity;

  /// Derive LuminousIntensityUnits using this LuminousIntensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      LuminousIntensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
