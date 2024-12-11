import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'power.dart';
import 'solid_angle.dart';

/// The radiant flux emitted, reflected, transmitted or received by a surface,
/// per unit solid angle per unit projected area.
/// See the [Wikipedia entry for Radiance](https://en.wikipedia.org/wiki/Radiance)
/// for more information.
class Radiance extends Quantity {
  /// Constructs a Radiance with watts per square meter steradian.
  /// Optionally specify a relative standard uncertainty.
  Radiance({dynamic wattsPerSquareMeterSteradian, double uncert = 0.0})
      : super(wattsPerSquareMeterSteradian ?? 0.0,
            Radiance.wattsPerSquareMeterSteradian, uncert);

  /// Constructs a instance without preferred units.
  Radiance.misc(dynamic conv) : super.misc(conv, Radiance.radianceDimensions);

  /// Constructs a Radiance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Radiance.inUnits(dynamic value, RadianceUnits? units, [double uncert = 0.0])
      : super(value, units ?? Radiance.wattsPerSquareMeterSteradian, uncert);

  /// Constructs a constant Radiance.
  const Radiance.constant(Number valueSI,
      {RadianceUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Radiance.radianceDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions radianceDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Solid Angle': -1, 'Time': -3},
      qType: Radiance);

  /// The standard SI unit.
  static final RadianceUnits wattsPerSquareMeterSteradian =
      RadianceUnits.powerAreaSolidAngle(
          Power.watts, Area.squareMeters, SolidAngle.steradians);
}

/// Units acceptable for use in describing Radiance quantities.
class RadianceUnits extends Radiance with Units {
  /// Constructs a instance.
  RadianceUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance from power, area and solid angle units.
  RadianceUnits.powerAreaSolidAngle(
      PowerUnits ecu, AreaUnits mu, SolidAngleUnits sau)
      : super.misc(ecu.valueSI / (mu.valueSI * sau.valueSI)) {
    name = '${ecu.name} per ${mu.singular} ${sau.singular}';
    singular = '${ecu.singular} per ${mu.singular} ${sau.singular}';
    convToMKS = ecu.valueSI / (mu.valueSI * sau.valueSI);
    abbrev1 = ecu.abbrev1 != null && mu.abbrev1 != null
        ? '${ecu.abbrev1} / ${mu.abbrev1} ${sau.singular}'
        : null;
    abbrev2 = ecu.abbrev2 != null && mu.abbrev2 != null
        ? '${ecu.abbrev2}/${mu.abbrev2}${sau.singular}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Radiance;

  /// Derive RadianceUnits using this RadianceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      RadianceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
