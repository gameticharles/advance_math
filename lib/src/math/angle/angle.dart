library angle;

import '/src/math/basic/math.dart' as math;
part 'types.dart';
part 'functions.dart';

/// The Angle class represents an angle.
///
/// Each instance of the Angle class can represent an angle in
/// degrees, radians, grads, or degree-minute-second (dms) format.
/// The unit of the angle is specified upon creation of the Angle object
/// and is immutable for the lifetime of the object.
///
/// The Angle class provides factory constructors for creating angles
/// in degrees, radians, grads, and dms.
///
/// Example:
/// ```dart
/// Angle a = Angle.degrees(90);
/// print(a.rad);  // Output: 1.5707963267948966
///
/// Angle b = Angle.radians(math.pi / 2);
/// print(b.deg);  // Output: 90
///
/// Angle c = Angle.gradians(100);
/// print(c.deg);  // Output: 90
///
/// Angle d = Angle.dms([90, 0, 0]);
/// print(d.deg);  // Output: 90
/// ```
class Angle {
  num? deg;
  List<num>? dms;

  final AngleType unit;
  num get rad => radians(deg!);
  num get grad => degreesToGrads(deg!);
  num get minutes => degrees2Minutes(deg!);
  num get seconds => degrees2Seconds(deg!);

  static Angle right = Angle(90);
  static Angle straight = Angle(180);
  static Angle full = Angle(360);

  /// Creates an angle. The value must be either a number (for degrees, radians, gradians)
  /// or a list of numbers (for DMS), and the unit must be either 'deg', 'rad', 'grad', or 'dms'.
  Angle(dynamic value, {this.unit = AngleType.degrees}) {
    if (value != null) {
      switch (unit) {
        case AngleType.dms:
          dms = value;
          deg = dmsList2Degrees(dms!);
          break;
        case AngleType.degrees:
          deg = value;
          dms = degree2DMS(value);
          break;
        case AngleType.radians:
          deg = degrees(value);
          dms = degree2DMS(deg!);
          break;
        case AngleType.gradians:
          deg = gradsToDegrees(value);
          dms = degree2DMS(deg!);
          break;
        default:
          throw Exception("Invalid unit specified.");
      }
    }
  }

  /// Creates an angle from a number of degrees.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.degrees(45);
  /// print(angle.deg); // Output: 45
  /// ```
  factory Angle.degrees(num degrees) {
    return Angle(degrees);
  }

  /// Creates an angle from a number of radians.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.radians(pi / 4);
  /// print(angle.deg); // Output: 45
  /// ```
  factory Angle.radians(num radians) {
    return Angle(radians, unit: AngleType.radians);
  }

  /// Creates an angle from a number of gradians.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.gradians(50);
  /// print(angle.deg); // Output: 45
  /// ```
  factory Angle.gradians(num gradians) {
    return Angle(gradians, unit: AngleType.gradians);
  }

  factory Angle.fromArcMinutes(double arcMinutes) {
    return Angle(arcMinutes / 60, unit: AngleType.degrees);
  }

  factory Angle.fromArcSeconds(double arcSeconds) {
    return Angle(arcSeconds / 3600, unit: AngleType.degrees);
  }

  /// Creates an angle from a list of degrees, minutes, and seconds.
  ///
  /// Example:
  /// ```dart
  /// var angle = Angle.dms([45, 30, 0]);
  /// print(angle.deg); // Output: 45.5
  /// ```
  factory Angle.dms(List<num> dms) {
    return Angle(dms, unit: AngleType.dms);
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
    return Angle(math.atan2(a, b), unit: AngleType.radians);
  }

  /// Method to convert the value between different units
  ///
  /// Example:
  /// ```dart
  /// double rad = Angle.convert(180, AngleType.degrees, AngleType.radians);  // Converts 180 degrees to radians
  /// print(rad);  // Outputs: 3.141592653589793
  ///
  /// double grad = Angle.convert(1, AngleType.radians, AngleType.gradians);  // Converts 1 radian to gradians
  /// print(grad);  // Outputs: 63.661977236758134
  /// ```
  static dynamic convert(dynamic value, AngleType from, AngleType to) {
    if (from == to) {
      return value;
    }

    num tempInDegrees;

    switch (from) {
      case AngleType.degrees:
        tempInDegrees = value;
        break;
      case AngleType.radians:
        tempInDegrees = degrees(value);
        break;
      case AngleType.gradians:
        tempInDegrees = gradsToDegrees(value);
        break;
      case AngleType.dms:
        tempInDegrees = dmsList2Degrees(value);
        break;
      case AngleType.arcMinutes:
        tempInDegrees = minutes2Degrees(value);
        break;
      case AngleType.arcSeconds:
        tempInDegrees = seconds2Degrees(value);
        break;
    }

    switch (to) {
      case AngleType.degrees:
        return tempInDegrees;
      case AngleType.radians:
        return radians(tempInDegrees);
      case AngleType.gradians:
        return degreesToGrads(tempInDegrees);
      case AngleType.dms:
        return degree2DMS(tempInDegrees);
      case AngleType.arcMinutes:
        return degrees2Minutes(tempInDegrees);
      case AngleType.arcSeconds:
        return degrees2Seconds(tempInDegrees);
    }
  }

  /// Returns the sine of the number.
  double sin() {
    return math.sin(rad);
  }

  /// Returns the cosine of the number.
  double cos() {
    return math.cos(rad);
  }

  /// Returns the tangent of the number.
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

  /// Normalize the angle
  num normalize() {
    return deg! % 360;
  }

  Angle operator +(Angle other) {
    return Angle.degrees(deg! + other.deg!);
  }

  Angle operator -(Angle other) {
    return Angle.degrees(deg! - other.deg!);
  }

  Angle operator *(num factor) {
    return Angle.degrees(deg! * factor);
  }

  Angle operator /(num divisor) {
    return Angle.degrees(deg! / divisor);
  }

  bool operator <(Angle other) {
    return deg! < other.deg!;
  }

  bool operator <=(Angle other) {
    return deg! <= other.deg!;
  }

  bool operator >(Angle other) {
    return deg! > other.deg!;
  }

  bool operator >=(Angle other) {
    return deg! >= other.deg!;
  }

  @override
  bool operator ==(dynamic other) {
    if (other is Angle) {
      return deg == other.deg;
    }
    return false;
  }

  @override
  int get hashCode => deg.hashCode;

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
    num diff = (deg! - other.deg!).abs() % 360;
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
    return Angle.degrees(deg! + diff * fraction);
  }

  @override
  String toString() {
    return 'Angle: $deg° or $dms or $rad rad';
  }
}
