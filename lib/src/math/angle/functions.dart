part of angle;

/// Converts `degrees` to `radians`.
///
/// Example:
/// ```dart
/// print(degToRad(180));  // Output: 3.141592653589793
/// ```
double radians(num deg) {
  return deg * (math.pi / 180);
}

/// Converts `radians` to `degrees`.
///
/// Example:
/// ```dart
/// print(radToDeg(math.pi));  // Output: 180.0
/// ```
double degrees(num rad) {
  return rad * (180 / math.pi);
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
  return degrees(radians) * 10 / 9;
}

/// Converts `grads` to `radians`.
///
/// Example:
/// ```dart
/// print(gradsToRadians(200));  // Output: 3.141592653589793
/// ```
double gradsToRadians(num grads) {
  return radians(grads * 9 / 10);
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

  /// give up here if we can't make a number from deg

  var absDegDec = degDEC.abs();

  ///DEG
  int deg = absDegDec.truncate();

  ///MIN
  int min = ((absDegDec - deg) * 60).truncate();

  ///SEC
  double sec = (((absDegDec - deg) * 60) - min) * 60;

  for (var i = 1; i <= 3; i++) {
    if (sec >= 59.99) {
      sec = 0;
      min = min + 1;
    }
    if (min >= 59.99) {
      min = 0;
      deg = deg + 1;
    }
  }
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

  bearing = ((bearing % 360) + 360) % 360;

  /// normalise to 0..360

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
/// The `noSignOrDirection` parameter removes the sign or direction from the returned string (default: false).
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
    bool noSignOrDirection = false}) {
  var dms = degree2DMS(degDEC);
  var deg = dms[0];
  var min = dms[1];
  var sec = dms[2];

  var nswe = "";

  ///NSWE
  var pn = "";

  ///+-

  if (isLatLon) {
    if (degDEC < 0) {
      if (isLat) {
        nswe = " S";
      } else {
        nswe = " W";
      }
    } else {
      if (isLat) {
        nswe = " N";
      } else {
        nswe = " E  ";
      }
    }
    pn = '';
  } else {
    pn = "+ ";
    if (degDEC < 0) {
      pn = "- ";
    }
    nswe = '';
  }

  if (noSignOrDirection) {
    nswe = '';
    pn = '';
  }

  return '$pn ${deg.abs().toString().padLeft(3, '0')}° ${min.toString().padLeft(2, '0')}\' ${sec.toStringAsFixed(decPlace).padLeft(2, '0')}"$nswe';
}
