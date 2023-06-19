import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'power.dart';
import 'solid_angle.dart';

/// The radiant flux emitted, reflected, transmitted or received, per unit solid angle.
/// See the [Wikipedia entry for Radiant intensity](https://en.wikipedia.org/wiki/Radiant_intensity)
/// for more information.
class RadiantIntensity extends Quantity {
  /// Constructs a RadiantIntensity with watts per steradian.
  /// Optionally specify a relative standard uncertainty.
  RadiantIntensity({dynamic wattsPerSteradian, double uncert = 0.0})
      : super(wattsPerSteradian ?? 0.0, RadiantIntensity.wattsPerSteradian,
            uncert);

  /// Constructs a instance without preferred units.
  RadiantIntensity.misc(dynamic conv)
      : super.misc(conv, RadiantIntensity.radiantIntensityDimensions);

  /// Constructs a RadiantIntensity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  RadiantIntensity.inUnits(dynamic value, RadiantIntensityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? RadiantIntensity.wattsPerSteradian, uncert);

  /// Constructs a constant RadiantIntensity.
  const RadiantIntensity.constant(Number valueSI,
      {RadiantIntensityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, RadiantIntensity.radiantIntensityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions radiantIntensityDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Time': -3, 'Solid Angle': -1},
      qType: RadiantIntensity);

  /// The standard SI unit.
  static final RadiantIntensityUnits wattsPerSteradian =
      RadiantIntensityUnits.powerSolidAngle(Power.watts, SolidAngle.steradians);
}

/// Units acceptable for use in describing RadiantIntensity quantities.
class RadiantIntensityUnits extends RadiantIntensity with Units {
  /// Constructs a instance.
  RadiantIntensityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on power nad solid angle units.
  RadiantIntensityUnits.powerSolidAngle(PowerUnits pu, SolidAngleUnits sau)
      : super.misc(pu.valueSI / sau.valueSI) {
    name = '${pu.name} per ${sau.singular}';
    singular = '${pu.singular} per ${sau.singular}';
    convToMKS = pu.valueSI / sau.valueSI;
    abbrev1 = pu.abbrev1 != null && sau.abbrev1 != null
        ? '${pu.abbrev1} / ${sau.abbrev1}'
        : null;
    abbrev2 = pu.abbrev2 != null && sau.abbrev2 != null
        ? '${pu.abbrev2}/${sau.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => RadiantIntensity;

  /// Derive RadiantIntensityUnits using this RadiantIntensityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      RadiantIntensityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
