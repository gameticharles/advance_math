import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The perceived power of light.
/// It differs from radiant flux, the measure of the total power of electromagnetic
/// radiation (including infrared, ultraviolet, and visible light), in that luminous
/// flux is adjusted to reflect the varying sensitivity of the human eye to different
/// wavelengths of light
/// See the [Wikipedia entry for Luminance](https://en.wikipedia.org/wiki/Luminance)
/// for more information.
class LuminousFlux extends Quantity {
  /// Constructs a LuminousFlux with lumens ([lm]).
  /// Optionally specify a relative standard uncertainty.
  LuminousFlux({dynamic lm, double uncert = 0.0})
      : super(lm ?? 0.0, LuminousFlux.lumens, uncert);

  /// Constructs a instance without preferred units.
  LuminousFlux.misc(dynamic conv)
      : super.misc(conv, LuminousFlux.luminousFluxDimensions);

  /// Constructs a LuminousFlux based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  LuminousFlux.inUnits(dynamic value, LuminousFluxUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? LuminousFlux.lumens, uncert);

  /// Constructs a constant LuminousFlux.
  const LuminousFlux.constant(Number valueSI,
      {LuminousFluxUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, LuminousFlux.luminousFluxDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions luminousFluxDimensions = Dimensions.constant(
      <String, int>{'Intensity': 1, 'Solid Angle': 1},
      qType: LuminousFlux);

  /// The standard SI unit.
  static final LuminousFluxUnits lumens =
      LuminousFluxUnits('lumens', null, 'lm', null, 1.0, true);
}

/// Units acceptable for use in describing LuminousFlux quantities.
class LuminousFluxUnits extends LuminousFlux with Units {
  /// Constructs a instance.
  LuminousFluxUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => LuminousFlux;

  /// Derive LuminousFluxUnits using this LuminousFluxUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      LuminousFluxUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
