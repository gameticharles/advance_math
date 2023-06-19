import 'dart:math';

import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// A two-dimensional angle in three-dimensional space that an object subtends at a point.
/// See the [Wikipedia entry for Solid angle](https://en.wikipedia.org/wiki/Solid_angle)
/// for more information.
class SolidAngle extends Quantity {
  /// Constructs a SolidAngle with steradians ([sr]).
  /// Optionally specify a relative standard uncertainty.
  SolidAngle({dynamic sr, double uncert = 0.0})
      : super(sr ?? 0.0, SolidAngle.steradians, uncert);

  /// Constructs a instance without preferred units.
  SolidAngle.misc(dynamic conv)
      : super.misc(conv, SolidAngle.solidAngleDimensions);

  // CONSTRUCTORS.

  /// Constructs a instance in the specified [units].
  SolidAngle.inUnits(dynamic value, SolidAngleUnits? units, [double uncert = 0])
      : super(value, units ?? SolidAngle.steradians, uncert);

  /// Constructs a constant SolidAngle.
  const SolidAngle.constant(Number value, [SolidAngleUnits? units])
      : super.constant(value, SolidAngle.solidAngleDimensions, units, 0);

  /// Dimensions for this type of quantity.
  static const Dimensions solidAngleDimensions =
      Dimensions.constant(<String, int>{'Solid Angle': 1}, qType: SolidAngle);

  /// The standard SI unit.
  static final SolidAngleUnits steradians =
      SolidAngleUnits('steradians', null, 'sr', null, 1.0, true);
}

/// Units acceptable for use in describing SolidAngle quantities.
class SolidAngleUnits extends SolidAngle with Units {
  /// Constructs a instance.
  SolidAngleUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
      [bool metricBase = false, num offset = 0])
      : super.misc(conv) {
    this.name = name;
    this.singular = singular;
    convToMKS = objToNumber(conv);
    this.abbrev1 = abbrev1;
    this.abbrev2 = abbrev2;
    this.metricBase = metricBase;
    this.offset = offset.toDouble();
  }

  /// Constructs a instance based on angle units.
  SolidAngleUnits.angleUnits(AngleUnits au)
      : super.misc(au.valueSI * au.valueSI) {
    name = '${au.name} squared';
    singular = '${au.singular} squared';
    convToMKS = au.valueSI * au.valueSI;
    abbrev1 = au.abbrev1 != null ? '${au.abbrev1}^2' : null;
    abbrev2 = au.abbrev2 != null ? '${au.abbrev2}^2' : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => SolidAngle;

  /// Derive SolidAngleUnits using this SolidAngleUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      SolidAngleUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);

  // Useful metric units.

  /// The standard SI unit.
  static SolidAngleUnits steradians = SolidAngle.steradians;

  /// Millisteradians as a unit.
  static SolidAngleUnits millisteradians =
      SolidAngle.steradians.milli() as SolidAngleUnits;

// Non-SI units.

  /// Spats as a unit.
  static SolidAngleUnits spats =
      SolidAngleUnits('spats', 'sp', null, null, 12.566371, false);

  /// Spheres as a unit.
  static SolidAngleUnits spheres =
      SolidAngleUnits('spheres', null, null, null, 4.0 * pi, false);

  /// Hemispheres as a unit.
  static SolidAngleUnits hemispheres =
      SolidAngleUnits('hemispheres', null, null, null, 2.0 * pi, false);

  /// One eighth (1/8) of a sphere (a spherical right triangle).
  static SolidAngleUnits octants =
      SolidAngleUnits('octants', null, null, null, pi / 2.0, false);

  /// Same as [octants].
  static SolidAngleUnits sphericalRightTriangles = octants;

  /// Square degrees as a unit.
  static SolidAngleUnits squareDegrees =
      SolidAngleUnits.angleUnits(AngleUnits.degrees);

  /// Square arc minutes as a unit.
  static SolidAngleUnits squareArcMinutes =
      SolidAngleUnits.angleUnits(AngleUnits.minutesArc);

  /// Square arc seconds as a unit.
  static SolidAngleUnits squareArcSeconds =
      SolidAngleUnits.angleUnits(AngleUnits.secondsArc);
}
