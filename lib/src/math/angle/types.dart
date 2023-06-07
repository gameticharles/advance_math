part of angle;

/// Enum representing the possible types of an angle.
///
/// Each enum value corresponds to a particular unit in which an angle can be
/// expressed. The supported units are degrees, radians, gradians, and DMS (degrees,
/// minutes, and seconds).
///
/// Usage:
///
/// ```dart
/// var angleType = AngleType.degrees;
///
/// switch (angleType) {
///   case AngleType.degrees:
///     print('The angle is in degrees.');
///     break;
///   case AngleType.radians:
///     print('The angle is in radians.');
///     break;
///   case AngleType.gradians:
///     print('The angle is in gradians.');
///     break;
///   case AngleType.dms:
///     print('The angle is in DMS format.');
///     break;
/// }
/// ```
enum AngleType {
  /// Represents an angle in degrees.
  degrees,

  /// Represents an angle in radians.
  radians,

  /// Represents an angle in gradians.
  gradians,

  /// Represents an arc minute in degrees.
  arcMinutes,

  /// Represents an arc minute in degrees.
  arcSeconds,

  /// Represents an angle in DMS format.
  dms,
}
