import '../../ext/angle_ext.dart';
import '/src/math/basic/math.dart' as math;
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';

enum AngleDirection {
  // A positive angle.
  clockwise,
  // A negative angle.
  counterclockwise,
}

enum AngleCategory {
  // Angle in [0°, 90°)
  acute,
  // Angle in [90°, 180)
  obtuse,
  // Angle in [180°, 360)
  reflex,
}

// Constant.

/// The value 2 * pi, also known as tau.
const double twoPi = 2.0 * math.pi;

/// A planar (2-dimensional) angle, which has dimensions of _1_ and is a
/// measure of the ratio of the length of a circular arc to its radius.
///
/// Example usage:
///
///     // Construct an Angle in radians.
///     var ang = Angle(rad: 1.1);
///
///     // Construct an Angle in degrees.
///     var ang2 = Angle(deg: 270);
///
///     // Find the difference.
///     var diff = ang2 - ang;
///
///     // Display the result in degrees.
///     print(diff.valueInUnits(AngleUnits.degrees));
///
/// See the [Wikipedia entry for Angle](https://en.wikipedia.org/wiki/Angle)
/// for more information.
class Angle extends Quantity {
  /// Constructs an Angle with either radians ([rad]) or degrees ([deg]).
  /// Optionally specify a relative standard uncertainty.
  Angle({dynamic rad, dynamic deg, double uncert = 0.0})
      : super(deg ?? (rad ?? 0.0),
            deg != null ? AngleUnits.degrees : AngleUnits.radians, uncert);

  /// Constructs a instance without preferred units.
  Angle.misc(dynamic conv) : super.misc(conv, Angle.angleDimensions);

  /// Constructs an Angle based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ///
  /// Unlike other Quantity subclasses, the Angle constructor requires
  /// both value _and units_ to be provided.  This is to avoid any confusion
  /// between radians and degrees, which is a common source of programming
  /// errors.
  ///
  /// The dimension is set to the static [angleDimensions] parameter.
  ///
  /// The internal value is automatically bounded between -PI and PI
  /// radians (-180 to 180 degrees)
  Angle.inUnits(dynamic value, AngleUnits? units, [double uncert = 0.0])
      : super(value, units ?? AngleUnits.radians, uncert);

  /// Constructs a constant angle.
  const Angle.constant(Number valueSI,
      {required AngleUnits units, double uncert = 0.0})
      : super.constant(valueSI, Angle.angleDimensions, units, uncert);

  ///  This constructor creates an angle value from the three values
  ///  passed in for degrees, minutes, and seconds of arc.
  Angle.fromDegMinSec(int d, int m, num s, [double uncert = 0.0])
      : super(dms2Degree(d, m, s), AngleUnits.degrees, uncert);

  /// Creates an angle from a number of degrees.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.fromDegrees(45);
  /// print(angle.deg); // Output: 45
  /// ```
  factory Angle.fromDegrees(num degrees, [double uncert = 0.0]) {
    return Angle.inUnits(degrees, AngleUnits.degrees, uncert);
  }

  /// Creates an angle from a number of radians.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.fromRadians(math.pi);
  /// print(angle.deg); // Output: 180
  /// ```
  factory Angle.fromRadians(num radians, [double uncert = 0.0]) {
    return Angle.inUnits(radians, AngleUnits.radians, uncert);
  }

  /// Creates an angle from a number of gradians.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.fromGradians(400);
  /// print(angle.deg); // Output: 360
  /// ```
  factory Angle.fromGradians(num gradians, [double uncert = 0.0]) {
    return Angle.inUnits(gradians, AngleUnits.gradians, uncert);
  }

  /// Creates an angle from a number of percentage.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.fromPercentage(0.5);
  /// print(angle.deg); // Output: 180
  /// ```
  factory Angle.fromPercentage(num percent, [double uncert = 0.0]) {
    return Angle.inUnits(
        percentage2radians(percent), AngleUnits.radians, uncert);
  }

  factory Angle.fromArcMinutes(double arcMinutes, [double uncert = 0.0]) {
    return Angle.inUnits(arcMinutes / 60, AngleUnits.degrees, uncert);
  }

  factory Angle.fromArcSeconds(double arcSeconds, [double uncert = 0.0]) {
    return Angle.inUnits(arcSeconds / 3600, AngleUnits.degrees, uncert);
  }

  /// Creates an angle from a list of degrees, minutes, and seconds.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.dms([45, 30, 0]);
  /// print(angle.deg); // Output: 45.5
  /// ```
  factory Angle.dms(List<num> dms, [double uncert = 0.0]) {
    return Angle.fromDegMinSec(
        dms[0].toInt(), dms[1].toInt(), dms[2].toDouble(), uncert);
  }

  /// Returns the angle in radians between the positive x-axis and the vector.
  /// The result is in the range -PI and PI.
  ///
  /// If b is positive, this is the same as atan(a/b). The result is negative when a is negative (including when a is the double -0.0).
  ///
  /// If a is equal to zero, the vector (b,a) is considered parallel to the x-axis, even if b is also equal to zero. The sign of b determines the direction of the vector along the x-axis.
  ///
  /// Returns NaN if either argument is NaN.
  ///
  /// Example:
  ///
  /// print(Angle.atan2(3, 4).rad);  // Output: 0.6435011087932843868028
  /// // atan(3 / 4) = 0.6435011087932843868028
  factory Angle.atan2(num a, num b) {
    return Angle(rad: math.atan2(a, b));
  }

  /// Dimensions for this type of quantity.
  static const Dimensions angleDimensions =
      Dimensions.constant(<String, int>{'Angle': 1}, qType: Angle);

  /// Return an equivalent angle bounded to between -PI and PI
  /// (-180 and 180 degrees).
  /// If this Angle is already within that range then it is returned directly.
  Angle get angle180 {
    if (valueSI >= -math.pi && valueSI <= math.pi) return this;

    var rad = valueSI.toDouble();
    while (rad < -math.pi) {
      rad += twoPi;
    }
    while (rad > math.pi) {
      rad -= twoPi;
    }
    return Angle(rad: rad);
  }

  /// Returns an equivalent angle bounded to between 0 and 2PI
  /// (0 and 360 degrees).
  /// If this Angle is already within that range then it is returned directly.
  Angle get angle360 {
    if (valueSI >= 0.0 && valueSI <= twoPi) return this;
    var rad = valueSI.toDouble();
    rad = rad.remainder(twoPi);
    if (valueSI < 0) rad += twoPi;
    return Angle(rad: rad);
  }

  ///  Calculates and returns the cotangent of this angle.
  /// The cotangent is equivalent to 1 over the tangent.
  double cotangent() => 1.0 / math.tan(mks.toDouble());

  num get deg => valueInUnits(AngleUnits.degrees).toDouble();
  num get rad => mks.toDouble();
  num get grad => degreesToGrads(deg);
  num get mins => degrees2Minutes(deg);
  num get secs => degrees2Seconds(deg);
  num get percentage => degrees2Percentage(deg);
  List<num> get dms => degree2DMS(deg);

  /// True if this `Angle` is greater than or equal to zero.
  bool get isPositive => deg >= 0;

  /// True if this `Angle` is less than zero.
  bool get isNegative => deg < 0;

  /// True if this `Angle` is acute, i.e., in [0°, 90°).
  bool get isAcute => deg.abs() < 90;

  /// True if this `Angle` is obtuse, i.e., in [90°, 180°).
  bool get isObtuse => !isAcute && deg.abs() < 180;

  /// True if this `Angle` is reflexive, i.e., in [180°, 360°).
  bool get isReflexive => !isAcute && !isObtuse;

  /// This `Angle`s category, e.g., acute, obtuse, or reflexive.
  AngleCategory get category => isAcute
      ? AngleCategory.acute
      : isObtuse
          ? AngleCategory.obtuse
          : AngleCategory.reflex;

  /// Returns a positive version of this `Angle`.
  ///
  /// If this `Angle` is already positive, this `Angle` is returned.
  ///
  /// If this `Angle` is negative, then its positive complement is returned.
  Angle makePositive() => isPositive ? this : Angle(deg: 360 + deg);

  /// Returns a negative version of this `Angle`.
  ///
  /// If this `Angle` is already negative, this `Angle` is returned.
  ///
  /// If this `Angle` is positive, then its negative complement is returned.
  Angle makeNegative() => isNegative ? this : Angle(deg: deg - 360);

  /// Converts a non-reflexive `Angle` to its reflexive complement, or a
  /// reflexive `Angle` to its non-reflexive complement, e.g., 90° -> 270° or
  /// 270° -> 90°.
  Angle get complement {
    return Angle(deg: (360 - deg.abs()) * deg.sign);
  }

  /// Adds the `other` `Angle` to this `Angle`, producing a `Rotation`.
  ///
  /// The difference between a `Rotation` and an `Angle` is that a `Rotation`
  /// can be arbitrarily large in the positive or negative direction.
  Rotation rotate(Angle other) {
    return Rotation.fromDegrees(deg + other.deg);
  }

  bool isEquivalentTo(Angle other) {
    return deg % 360 == other.deg % 360;
  }

  bool isApproximately(Angle other, {num tolerance = 0.01}) {
    return (other.deg - deg).abs() / deg <= tolerance;
  }

  /// Returns the sine of the number in radians.
  double sin() {
    return math.sin(rad);
  }

  /// Returns the cosine of the number in radians.
  double cos() {
    return math.cos(rad);
  }

  /// Returns the tangent of the number in radians.
  double tan() {
    return math.tan(rad);
  }

  /// Returns the secant of the number in radians.
  double sec() {
    return math.sec(rad);
  }

  /// Returns the cosecant of the number in radians.
  double csc() {
    return math.csc(rad);
  }

  /// Returns the cotangent of the number in radians.
  double cot() {
    return math.cot(rad);
  }

  /// Returns the hyperbolic sine of the number.
  double sinh() {
    return math.sinh(rad);
  }

  /// Returns the hyperbolic cosine of the number.
  double cosh() {
    return math.cosh(rad);
  }

  /// Returns the hyperbolic tangent of the number.
  double tanh() {
    return math.tanh(rad);
  }

  /// Returns the hyperbolic secant the number in radians.
  double sech() {
    return math.sech(rad);
  }

  /// Returns the hyperbolic cosecant the number in radians.
  double csch() {
    return math.csch(rad);
  }

  /// Returns the hyperbolic cotangent of the number in radians.
  double coth() {
    return math.coth(rad);
  }

  /// Returns the arcsine of the number in radians.
  double asin() {
    return math.asin(rad);
  }

  /// Returns the arccosine of the number in radians.
  double acos() {
    return math.acos(rad);
  }

  /// Returns the arctangent of the number in radians.
  double atan() {
    return math.atan(rad);
  }

  /// Returns the arcsecant (inverse of the secant).
  double asec() {
    return math.asec(rad);
  }

  /// Returns the arccosecant (inverse of the cosecant).
  double acsc() {
    return math.acsc(rad);
  }

  /// Returns the arccotangent (inverse of the cotangent).
  double acot() {
    return math.acot(rad);
  }

  /// Returns the inverse hyperbolic sine (asinh) of the number.
  double asinh() {
    return math.asinh(rad);
  }

  /// Returns the inverse hyperbolic cosine (acosh) of the number.
  ///
  /// Throws an [ArgumentError] if the input is less than 1.
  double acosh() {
    return math.acosh(rad);
  }

  /// Returns the inverse hyperbolic tangent (atanh) of the number.
  ///
  /// Throws an [ArgumentError] if the input is less than or equal to -1 or greater than or equal to 1.
  double atanh() {
    return math.atanh(rad);
  }

  /// Returns the inverse hyperbolic secant (asech).
  double asech() {
    return math.asech(rad);
  }

  /// Returns the inverse hyperbolic cosecant (acsch).
  double acsch() {
    return math.acsch(rad);
  }

  /// Returns the inverse hyperbolic cotangent (acoth).
  double acoth() {
    return math.acoth(rad);
  }

  /// Returns the versine or versin or versed sine of an angle is 1 − cos(θ).
  double vers() {
    return math.vers(rad);
  }

  /// Returns the coversine or coversin of an angle is 1 − sin(θ).
  double covers() {
    return math.covers(rad);
  }

  /// Returns the haversine or haversin of an angle is (1 - cos(θ)) / 2.
  double havers() {
    return math.havers(rad);
  }

  /// Returns the exsecant or exsec of an angle is sec(θ) - 1.
  double exsec() {
    return math.exsec(rad);
  }

  /// The excosecant or excsc of an angle is csc(θ) - 1.
  double excsc() {
    return math.excsc(rad);
  }

  /// Normalize the angle between 0 - 360
  Angle normalize() {
    return Angle(deg: ((deg % 360) + 360) % 360);
  }

  /// Returns an array of three values representing the value of this Angle
  /// in degrees, minutes arc and seconds arc.  The first value (degrees) may
  /// be either positive or negative; the other two values will be positive.
  List<double> get degMinSec {
    final dms = List<double>.generate(3, (_) => 0.0, growable: false);

    final decimalDegrees = valueInUnits(degrees).toDouble();

    // Degrees
    dms[0] = decimalDegrees.toInt().toDouble();

    // Minutes
    final remainder1 = decimalDegrees.abs() - dms[0].abs();
    final decimalMinutes = remainder1 * 60.0;
    dms[1] = decimalMinutes.toInt().toDouble();

    // Seconds
    final remainder2 = decimalMinutes - dms[1];
    dms[2] = remainder2 * 60.0;

    return dms;
  }

  /// Gets the value of this angle in terms of hours, minutes and seconds
  /// (where there are 24 hours in a complete circle).  The first value (hours)
  /// may be either positive or negative; the other two values will be positive.
  List<double> get hrMinSec {
    final hms = List<double>.generate(3, (_) => 0.0, growable: false);

    final decimalHours = valueInUnits(degrees).toDouble() / 15.0;

    // Hours
    hms[0] = decimalHours.toInt().toDouble();

    // Minutes
    final remainder1 = decimalHours.abs() - hms[0].abs();
    final decimalMinutes = remainder1 * 60.0;
    hms[1] = decimalMinutes.toInt().toDouble();

    // Seconds
    final remainder2 = decimalMinutes - hms[1];
    hms[2] = remainder2 * 60.0;

    return hms;
  }

  /// Computes the smallest difference in degrees between this angle and another one.
  ///
  /// This method takes into account the periodicity of angles, which means that
  /// an angle of 0 degrees and an angle of 360 degrees are considered to be the same.
  /// Thus, the smallest difference between two angles will never be more than 180 degrees.
  ///
  /// Usage:
  ///
  /// ```dart
  /// var angle1 = Angle.degrees(45);
  /// var angle2 = Angle.degrees(90);
  /// print(angle1.smallestDifference(angle2));  // Output: 45
  /// ```
  ///
  /// Parameters:
  /// - [other] The other angle to compare with.
  ///
  /// Returns:
  /// The smallest difference in degrees between this angle and the other angle.
  num smallestDifference(Angle other) {
    num diff = (deg - other.deg).abs() % 360;
    if (diff > 180) diff = 360 - diff;
    return diff;
  }

  /// Computes an angle that is a certain fraction between this angle and another one.
  ///
  /// The computed angle is a linear interpolation between this angle and another one.
  /// The interpolation takes into account the periodicity of angles, which means that
  /// an angle of 0 degrees and an angle of 360 degrees are considered to be the same.
  ///
  /// Usage:
  ///
  /// ```dart
  /// var angle1 = Angle.degrees(0);
  /// var angle2 = Angle.degrees(180);
  /// print(angle1.interpolate(angle2, 0.5));  // Output: 90.0
  /// ```
  ///
  /// Parameters:
  /// - [other] The other angle to interpolate with.
  /// - [fraction] The fraction between the two angles to compute. Must be between 0 and 1.
  ///
  /// Returns:
  /// The interpolated angle.
  Angle interpolate(Angle other, num fraction) {
    num diff = smallestDifference(other);
    return Angle(deg: deg + diff * fraction);
  }

  @override
  String toString() {
    return 'Angle: $deg° or $rad rad or ${degree2DMSString(deg)}';
  }
}

/// `Rotation` is like an angle that may exceed 360° in the positive or negative
/// direction.
class Rotation {
  static const Rotation zero = Rotation.fromDegrees(0);

  const Rotation.fromDegrees(num degrees)
      : deg = degrees,
        rad = degrees * math.pi / 180;

  const Rotation.fromRadians(num radians)
      : rad = radians,
        deg = radians * 180 / math.pi;

  Rotation.fromAngle(Angle angle)
      : deg = angle.deg,
        rad = angle.rad;

  /// Angle expressed as degrees.
  final num deg;

  /// Angle expressed as radians.
  final num rad;

  /// Returns an inverted version of this `Rotation`, e.g., -90° to 90°.
  operator -() {
    return Rotation.fromDegrees(-deg);
  }

  /// Returns the sum of this `Rotation` and the `other` `Rotation`.
  Rotation operator +(Rotation other) {
    return Rotation.fromDegrees(deg + other.deg);
  }

  /// Returns the subtraction of `other` from this `Rotation`.
  Rotation operator -(Rotation other) {
    return Rotation.fromDegrees(deg - other.deg);
  }

  /// Multiplies this `Rotation` by the given `scalar`.
  Rotation operator *(num scalar) {
    return Rotation.fromDegrees(deg * scalar);
  }

  /// Divides this `Rotation` by the given `scalar`.
  Rotation operator /(num scalar) {
    if (scalar == 0) {
      throw 'Can not divide by zero';
    }
    return Rotation.fromDegrees(deg / scalar);
  }

  /// Returns an `Angle` that is equivalent to this `Rotation` with all 360°
  /// cycles removed.
  Angle reduceToAngle() => Angle(deg: deg);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Rotation && runtimeType == other.runtimeType && deg == other.deg;

  @override
  int get hashCode => deg.hashCode;

  @override
  String toString() {
    return '$deg°';
  }
}
