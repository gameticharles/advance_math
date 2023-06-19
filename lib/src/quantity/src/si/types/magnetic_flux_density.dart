import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The amount of magnetic flux in an area taken perpendicular to a
/// magnetic flux's direction
/// See the [Wikipedia entry for Magnetic flux](https://en.wikipedia.org/wiki/Magnetic_flux)
/// for more information.
class MagneticFluxDensity extends Quantity {
  /// Constructs a MagneticFluxDensity with teslas ([T]).
  /// Optionally specify a relative standard uncertainty.
  MagneticFluxDensity({dynamic T, double uncert = 0.0})
      : super(T ?? 0.0, MagneticFluxDensity.teslas, uncert);

  /// Constructs a instance without preferred units.
  MagneticFluxDensity.misc(dynamic conv)
      : super.misc(conv, MagneticFluxDensity.magneticFluxDensityDimensions);

  /// Constructs a MagneticFluxDensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MagneticFluxDensity.inUnits(dynamic value, MagneticFluxDensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MagneticFluxDensity.teslas, uncert);

  /// Constructs a constant MagneticFluxDensity.
  const MagneticFluxDensity.constant(Number valueSI,
      {MagneticFluxDensityUnits? units, double uncert = 0.0})
      : super.constant(valueSI,
            MagneticFluxDensity.magneticFluxDensityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions magneticFluxDensityDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Current': -1, 'Time': -2},
      qType: MagneticFluxDensity);

  /// The standard SI unit.
  static final MagneticFluxDensityUnits teslas =
      MagneticFluxDensityUnits('teslas', null, 'T', null, 1.0, true);
}

/// Units acceptable for use in describing MagneticFluxDensity quantities.
class MagneticFluxDensityUnits extends MagneticFluxDensity with Units {
  /// Constructs a instance.
  MagneticFluxDensityUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => MagneticFluxDensity;

  /// Derive MagneticFluxDensityUnits using this MagneticFluxDensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MagneticFluxDensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
