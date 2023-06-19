import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Irradiance of a surface per unit frequency.
/// See the [Wikipedia entry for Radiometry](https://en.wikipedia.org/wiki/Radiometry)
/// for more information.
class SpectralIrradiance extends Quantity {
  /// Constructs a SpectralIrradiance with watts per square meter per hertz.
  /// Optionally specify a relative standard uncertainty.
  SpectralIrradiance({dynamic wattsPerSquareMeterPerHertz, double uncert = 0.0})
      : super(wattsPerSquareMeterPerHertz ?? 0.0,
            SpectralIrradiance.wattsPerSquareMeterPerHertz, uncert);

  /// Constructs a instance without preferred units.
  SpectralIrradiance.misc(dynamic conv)
      : super.misc(conv, SpectralIrradiance.spectralIrradianceDimensions);

  /// Constructs a SpectralIrradiance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  SpectralIrradiance.inUnits(dynamic value, SpectralIrradianceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? SpectralIrradiance.wattsPerSquareMeterPerHertz,
            uncert);

  /// Constructs a constant SpectralIrradiance.
  const SpectralIrradiance.constant(Number valueSI,
      {SpectralIrradianceUnits? units, double uncert = 0.0})
      : super.constant(valueSI, SpectralIrradiance.spectralIrradianceDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions spectralIrradianceDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Time': -2},
      qType: SpectralIrradiance);

  /// The standard SI unit.
  static final SpectralIrradianceUnits wattsPerSquareMeterPerHertz =
      SpectralIrradianceUnits('watts per square meter per hertz', 'W m-2 Hz-1',
          null, null, 1.0, true);
}

/// Units acceptable for use in describing SpectralIrradiance quantities.
class SpectralIrradianceUnits extends SpectralIrradiance with Units {
  /// Constructs a instance.
  SpectralIrradianceUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => SpectralIrradiance;

  /// Derive SpectralIrradianceUnits using this SpectralIrradianceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SpectralIrradianceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
