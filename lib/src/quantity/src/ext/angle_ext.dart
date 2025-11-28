import '../../../math/basic/math.dart' as math;
import '../../../number/number.dart';
import '../si/types/angle.dart';
import '../si/units.dart';

// Trig functions.

// Constants.

/// The "circle constant", equal to two pi.
const double tau = twoPi;

// Top level SI units.

/// A terse version of `AngleUnits.radians`.
final AngleUnits radians = AngleUnits.radians;

/// A terse version of `AngleUnits.degrees`.
final AngleUnits degrees = AngleUnits.degrees;

/// A terse version of `AngleUnits.minutesArc`.
final AngleUnits minutesArc = AngleUnits.minutesArc;

/// A terse version of `AngleUnits.secondsArc`.
final AngleUnits secondsArc = AngleUnits.secondsArc;

/// A unit of one thousandth of a radian.
final AngleUnits milliradian = AngleUnits.radians.milli() as AngleUnits;

// Synonyms for terseness.

/// Synonymous with radians.
final AngleUnits rad = AngleUnits.radians;

/// Synonymous with degrees.
final AngleUnits deg = AngleUnits.degrees;

// Non-SI angle units.

// Commonly Used Angles.

/// A zero degree angle.
final Angle angle0 = Angle(deg: 0.0);

/// A thirty degree angle.
final Angle angle30 = Angle(deg: 30.0);

/// A forty five degree angle.
final Angle angle45 = Angle(deg: 45.0);

/// A sixty degree angle.
final Angle angle60 = Angle(deg: 60.0);

/// A ninety degree angle.
final Angle angle90 = Angle(deg: 90.0);

/// A one hundred eighty degree angle.
final Angle angle180 = Angle(deg: 180.0);

/// A two hundred seventy degree angle.
final Angle angle270 = Angle(deg: 270.0);

/// A three hundred sixty degree angle.
final Angle angle360 = Angle(deg: 360.0);

/// A one hundred eighty degree angle.
final Angle anglePi = angle180;

/// A three hundred sixty degree angle.
final Angle angleTau = angle360;

// Common trig values.

/// The sine of a zero degree angle (0).
const double sin0 = 0;

/// The sine of a thirty degree angle (0.5).
const double sin30 = 0.5;

/// The sine of a forty five degree angle.
final double sin45 = angle45.sin();

/// The sine of a sixty degree angle.
final double sin60 = angle60.sin();

/// The sine of a ninety degree angle (1).
const double sin90 = 1;

/// The cosine of a ninety degree angle (1).
const double cos0 = 1;

/// The cosine of a thirty degree angle.
final double cos30 = angle30.cos();

/// The cosine of a forty five degree angle.
final double cos45 = angle45.cos();

/// The cosine of a sixty degree angle (0.5).
const double cos60 = 0.5;

/// The cosine of a ninety degree angle (1).
const double cos90 = 0;

/// The tangent of a zero degree angle (0).
const double tan0 = 0;

/// The tangent of a thirty degree angle.
final double tan30 = angle30.tan();

/// The tangent of a forty five degree angle (1).
const double tan45 = 1;

/// The tangent of a sixty degree angle.
final double tan60 = angle60.tan();

// Alternative construction.

/// Constructs an angle from hours, minutes and seconds of time (as opposed to arc).
Angle angleFromHourMinSec(int hour, int minute, double second,
    [double uncert = 0]) {
  final mks = AngleUnits.hoursTime.toMks(hour).toDouble() +
      AngleUnits.minutesTime.toMks(minute).toDouble() +
      AngleUnits.secondsTime.toMks(second).toDouble();
  return Angle.inUnits(mks, AngleUnits.radians, uncert);
}

//final num _maxDegrees = 360;
final num _maxRadians = 2 * math.pi;

/// Converts degrees to radians.
double degToRad(num deg) => toRadians(deg);

/// Convert radians to degrees.
double radToDeg(num rad) => toDegrees(rad);

/// Converts `degrees` to `radians`.
///
/// Example:
/// ```dart
/// print(degToRad(180));  // Output: 3.141592653589793
/// ```
double toRadians(num deg) {
  return deg * (math.pi / 180);
}

/// Converts `radians` to `degrees`.
///
/// Example:
/// ```dart
/// print(radToDeg(math.pi));  // Output: 180.0
/// ```
double toDegrees(num rad) {
  return rad * (180 / math.pi);
}

/// Converts `degrees` to `percentage`.
///
/// The resulting `Angle` confines the `percent` to (-1.0, 1.0) by mod'ing
/// the incoming value.
///
/// Example:
/// ```dart
/// print(degrees2Percentage(180));  // Output: 0.5
/// ```
double degrees2Percentage(num deg) {
  return deg >= 0 || deg == -360
      ? (deg % 360) / 360
      : ((deg % 360) - 360) / 360;
}

/// Converts `percentage` to `degrees`.
///
/// The resulting `Angle` confines the `percent` to (-360, 360) by mod'ing
/// the incoming value.
///
/// Example:
/// ```dart
/// print(percentage2Degrees(0.5));  // Output: 180
/// ```
double percentage2Degrees(num percent) {
  return percent >= 0 || percent == -1.0
      ? (percent % 1.0) * 360
      : ((percent % 1.0) - 1.0) * 360;
}

/// Converts `radians` to `percentage`.
///
/// The resulting `Angle` confines the `percent` to (-1.0, 1.0) by mod'ing
/// the incoming value.
///
/// Example:
/// ```dart
/// print(degrees2Percentage(180));  // Output: 0.5
/// ```
double radians2Percentage(num radians) {
  return radians >= 0 || radians == -2 * math.pi
      ? (radians % _maxRadians) / (2 * math.pi)
      : ((radians % _maxRadians) - (2 * math.pi)) / (2 * math.pi);
}

/// Converts `percentage` to `radians`.
///
/// The resulting `Angle` confines the `radians` to (-2pi, 2pi) by mod'ing
/// the incoming value.
///
/// Example:
/// ```dart
/// print(percentage2Degrees(0.5));  // Output: 180
/// ```
double percentage2radians(num percent) {
  return percent >= 0 || percent == -1.0
      ? (percent % 1.0) * (2 * math.pi)
      : ((percent % 1.0) - 1.0) * (2 * math.pi);
}

/// Converts `degrees` to `grads`.
///
/// Example:
/// ```dart
/// print(degreesToGrads(90));  // Output: 100.0
/// ```
double degreesToGrads(num degrees) {
  return degrees * 10 / 9;
}

/// Converts `grads` to degrees.
///
/// Example:
/// ```dart
/// print(gradsToDegrees(100));  // Output: 90.0
/// ```
double gradsToDegrees(num grads) {
  return grads * 9 / 10;
}

/// Converts `radians` to grads.
///
/// Example:
/// ```dart
/// print(radiansToGrads(math.pi));  // Output: 200.0
/// ```
double radiansToGrads(double radians) {
  return toDegrees(radians) * 10 / 9;
}

/// Converts `grads` to `radians`.
///
/// Example:
/// ```dart
/// print(gradsToRadians(200));  // Output: 3.141592653589793
/// ```
double gradsToRadians(num grads) {
  return toRadians(grads * 9 / 10);
}

/// Converts degrees to minutes.
///
/// Parameter `degrees` is the value in degrees to be converted.
///
/// Returns the equivalent value in minutes.
///
/// Example:
/// ```dart
/// print(degrees2Minutes(1));  // Output: 60.0
/// ```
double degrees2Minutes(num degrees) {
  return degrees * 60;
}

/// Converts minutes to degrees.
///
/// Parameter `minutes` is the value in minutes to be converted.
///
/// Returns the equivalent value in degrees.
///
/// Example:
/// ```dart
/// print(minutes2Degrees(60));  // Output: 1.0
/// ```
double minutes2Degrees(num minutes) {
  return minutes / 60;
}

/// Converts degrees to seconds.
///
/// Parameter `degrees` is the value in degrees to be converted.
///
/// Returns the equivalent value in seconds.
///
/// Example:
/// ```dart
/// print(degrees2Seconds(1));  // Output: 3600.0
/// ```
double degrees2Seconds(num degrees) {
  return degrees * 3600;
}

/// Converts seconds to degrees.
///
/// Parameter `seconds` is the value in seconds to be converted.
///
/// Returns the equivalent value in degrees.
///
/// Example:
/// ```dart
/// print(seconds2Degrees(3600));  // Output: 1.0
/// ```
double seconds2Degrees(num seconds) {
  return seconds / 3600;
}

/// Converts `degrees`, `minutes` and `seconds` to `decimal degrees`.
///
/// Example:
/// ```dart
/// print(dms2DecDeg(23, 30, 15));  // Output: 23.504166666666666
/// ```
double dms2Degree(int deg, int min, num sec) {
  //return (deg == "-0" || deg == "-00" || deg == "-000" || double.parse(deg) < 0)
  return deg < 0
      ? (deg.abs() + min / 60 + sec / 3600) * -1
      : deg + min / 60 + sec / 3600;
}

/// Converts list `[degrees, minutes, seconds]` to decimal degrees.
///
/// Example:
/// ```dart
/// print(dms2DecDeg([23, 30, 15]));  // Output: 23.504166666666666
/// ```
double dmsList2Degrees(List<num> dms) {
  return dms2Degree(dms[0].toInt(), dms[1].toInt(), dms[2]);
}

/// Converts `degrees` and `minutes` to decimal degrees.
///
/// Example:
/// ```dart
/// print(dmm2DecDeg(23, 30));  // Output: 23.5
/// ```
double dmm2Degree(double deg, num min) {
  return (deg < 0) ? (deg.abs() + min / 60) * -1 : deg + min / 60;
}

/// Converts `decimal degrees` to degrees, minutes, and seconds.
///
/// Example:
/// ```dart
/// print(degree2DMS(23.504166666666666));  // Output: [23, 30, 15]
/// ```
List<num> degree2DMS(num degDEC) {
  if (degDEC.isNaN) {
    return [];
  }

  var absDegDec = degDEC.abs();

  // Calculate degrees
  int deg = absDegDec.truncate();

  // Calculate minutes
  num remainder = absDegDec - deg;
  int min = (remainder * 60).truncate();

  // Calculate seconds
  double sec = ((remainder * 60) - min) * 60;

  // Adjust values if seconds or minutes are 60 or more
  if (sec >= 60) {
    sec = 0;
    min += 1;
  }
  if (min >= 60) {
    min = 0;
    deg += 1;
  }

  // Return result with correct sign for degrees
  return [degDEC >= 0 ? deg : deg * -1, min, sec];
}

/// Returns a `string` representing the compass direction of the `bearing`.
/// Precision is optional and can be set to 1 (4 compass points), 2 (8 compass points), or 3 (16 compass points).
///
/// Example:
/// ```dart
/// print(getDirectionString(65, precision: 1));  // Output: E
/// print(getDirectionString(65, precision: 2));  // Output: NE
/// print(getDirectionString(65, precision: 3));  // Output: ENE
/// ```
String getDirectionString(num bearing, {num precision = 3}) {
  String direction = "N";

  /// note precision = max length of compass point; it could be extended to 4 for quarter-winds
  /// (eg NEbN), but I think they are little used

  /// normalize to 0..360
  bearing = ((bearing % 360) + 360) % 360;

  switch (precision) {
    case 1:

      /// 4 compass points
      switch ((bearing * 4 / 360).round() % 4) {
        case 0:
          direction = 'N';
          break;
        case 1:
          direction = 'E';
          break;
        case 2:
          direction = 'S';
          break;
        case 3:
          direction = 'W';
          break;
      }
      break;
    case 2:

      /// 8 compass points
      switch ((bearing * 8 / 360).round() % 8) {
        case 0:
          direction = 'N';
          break;
        case 1:
          direction = 'NE';
          break;
        case 2:
          direction = 'E';
          break;
        case 3:
          direction = 'SE';
          break;
        case 4:
          direction = 'S';
          break;
        case 5:
          direction = 'SW';
          break;
        case 6:
          direction = 'W';
          break;
        case 7:
          direction = 'NW';
          break;
      }
      break;
    case 3:

      /// 16 compass points
      switch ((bearing * 16 / 360).round() % 16) {
        case 0:
          direction = 'N';
          break;
        case 1:
          direction = 'NNE';
          break;
        case 2:
          direction = 'NE';
          break;
        case 3:
          direction = 'ENE';
          break;
        case 4:
          direction = 'E';
          break;
        case 5:
          direction = 'ESE';
          break;
        case 6:
          direction = 'SE';
          break;
        case 7:
          direction = 'SSE';
          break;
        case 8:
          direction = 'S';
          break;
        case 9:
          direction = 'SSW';
          break;
        case 10:
          direction = 'SW';
          break;
        case 11:
          direction = 'WSW';
          break;
        case 12:
          direction = 'W';
          break;
        case 13:
          direction = 'WNW';
          break;
        case 14:
          direction = 'NW';
          break;
        case 15:
          direction = 'NNW';
          break;
      }
      break;
    default:
      throw RangeError('Precision must be between 1 and 3');
  }

  return direction;
}

/// Converts a decimal degree value to a string in degrees, minutes, and seconds.
/// The `isLat` parameter indicates whether the coordinate is latitude (default: false).
/// The `isLatLon` parameter specifies whether the coordinate is part of a latitude-longitude pair (default: false).
/// The `decPlace` parameter defines the decimal place for the second value (default: 5).
/// The `showSignAndDirection` parameter removes the sign or direction from the returned string (default: true).
///
/// Example:
/// ```dart
/// print(degree2DMSString(23.504166666666666, isLat: true, isLatLon: true, decPlace: 3));
/// // Output: " + 023° 30' 15.000"N
/// ```
String degree2DMSString(num degDEC,
    {bool isLat = false,
    bool isLatLon = false,
    int decPlace = 5,
    bool showSignAndDirection = true}) {
  var dms = degree2DMS(degDEC);
  var nswe = isLatLon
      ? (degDEC < 0 ? (isLat ? ' S' : ' W') : (isLat ? ' N' : ' E'))
      : '';
  var pn = !isLatLon
      ? degDEC >= 0
          ? '' // '+ '
          : '- '
      : '';

  if (!showSignAndDirection) nswe = pn = '';

  return '$pn${dms[0].abs().toString().padLeft(3, '0')}° ${dms[1].toString().padLeft(2, '0')}\' ${dms[2].toStringAsFixed(decPlace).padLeft(2, '0')}"$nswe';
}

/// Units acceptable for use in describing Angle quantities.
class AngleUnits extends Angle with Units {
  /// Constructs a instance.
  AngleUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Angle;

  /// Derive AngleUnits using this AngleUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AngleUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);

  // Useful metric units.

  /// The standard SI unit.
  static AngleUnits radians =
      AngleUnits('radians', null, 'rad', null, Integer.one, true);

  /// Accepted for use with the SI.
  static AngleUnits degrees = AngleUnits('degrees', '\u{00b0}', 'deg', null,
      const Double.constant(1.7453292519943e-2), false);

  /// Accepted for use with the SI.
  static AngleUnits minutesArc = AngleUnits('arc minutes', '\'', 'arc min',
      null, const Double.constant(2.9088821e-4), false);

  /// Accepted for use with the SI.
  static AngleUnits secondsArc = AngleUnits('arc seconds', '\'', 'arc sec',
      null, const Double.constant(4.8481368e-6), false);

  // convenience units

  /// Accepted for use with the SI; equivalent to [minutesArc].
  static AngleUnits minutes = minutesArc;

  /// Accepted for use with the SI; equivalent to [secondsArc].
  static AngleUnits seconds = secondsArc;

  /// One grad is 0.9 of a degree, exactly.
  static AngleUnits grads =
      AngleUnits('grads', null, null, null, 0.9 * 1.7453292519943e-2, false);

  /// Synonym for grads.
  static AngleUnits grades = grads;

  /// Synonym for grads.
  static AngleUnits gradians = grads;

  /// Synonym for grads.
  static AngleUnits gons = grads;

  /// One angular mil is 0.05625 of a degree, exactly.
  static AngleUnits angularMils =
      AngleUnits('mils', null, null, null, 0.05625 * 1.7453292519943e-2, false);

  /// Represents a full circle of two pi radians.
  static AngleUnits revolutions =
      AngleUnits('revolutions', null, 'revs', null, twoPi, false);

  /// Synonymous with [revolutions].
  static AngleUnits cycles = revolutions;

  /// Synonymous with [revolutions].
  static AngleUnits circles = revolutions;

  /// Represents a half circle of one hundred eighty degrees (pi radians).
  static AngleUnits semicircles =
      AngleUnits('semicircles', null, null, null, math.pi, false);

  /// Represents a quarter circle of ninety degrees.
  static AngleUnits quadrants =
      AngleUnits('quadrants', null, null, null, math.pi / 2.0, false);

  /// A sign unit is a little more than half a radian.
  static AngleUnits signs =
      AngleUnits('signs', null, null, null, 0.523599, false);

  /// Based on Earth's rotation (approximately 15 degrees).
  static AngleUnits hoursTime = AngleUnits(
      'hours time', 'hrs time', 'hr', 'hour time', 2.6179939e-1, false);

  /// Based on Earth's rotation.
  static AngleUnits minutesTime = AngleUnits('minutes time', 'min time',
      'min (t)', 'minute time', 4.3633231e-3, false);

  /// Based on Earth's rotation.
  static AngleUnits secondsTime = AngleUnits('seconds time', 'sec time',
      'sec (t)', 'second time', 7.2722052e-5, false);
}
