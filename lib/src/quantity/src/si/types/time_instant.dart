// ignore_for_file: unnecessary_cast

import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/quantity_exception.dart';
import '../../si/units.dart';
import 'time.dart';

// Also Epoch

/// `TimeInstant` represents a specific moment in time and its units enable
/// conversion between various time scales.
///
/// See the [Wikipedia entry for Time](https://en.wikipedia.org/wiki/Time)
/// for more information.
///
/// This class also enables the representation of a point in time to arbitrarily high
/// precision over the entire span of time from the birth of the Universe
/// to a possibly infinite future.  Therefore it is suitable for use within
/// science and engineering disciplines that involve very long and/or very short
/// time spans.
//
/// ## Internal Representation in the International Atomic Time Scale
/// The time instant is represented internally as the number of (SI) seconds elapsed
/// since January 1, 1958 0h 0m 0s, which is the origin of the International
/// Atomic Time Scale (TAI).  Unlike other quantities, the notion of an absolute
/// zero time is ill defined.  One could specify the time of the Big Bang
/// (creation of the Universe) as time equals zero, but that moment in time
/// is not known precisely.  Instead, arbitrary times are chosen to represent
/// zero for a particular time scale and then times are measured against that
/// particular origin.  The TAI time scale flows evenly without arbitrary
/// corrections based on the Earth's rotation and is kept to very high precision
/// through statistical analysis of atomic clocks maintained around the world.
///
///
/// ## Time Systems
/// ### TAI - International Atomic Time Scale
///     A statistical timescale based on a large number of atomic clocks.
///
/// ### UTC - Coordinated Universal Time
///     The scale used for most official and civilian time keeping.  UTC differs
///     from TAI by an integral number of seconds; leap seconds are added (or removed)
///     as necessary to keep UTC within 0.9 seconds of UT1.
///
/// ### system - Used by the Dart VM
///     The number of milliseconds elapsed since 1 Jan 1970 0h.
///
/// ### Additional time systems are available in the quantity_ext library.
///
/// Also available in the `time_ext` library:
/// #### UT1 - Universal Time (1)
///        The rotational time of a particular place of observation with
///        additional corrections for the affects of polar motion applied.  Because
///        the rotation of the Earth is not exactly uniform UT1 does not 'flow'
///        uniformly.
///
/// #### UT2 - Universal Time (2)
///        UT1 with additional corrections applied for a 'smoother' flow of
///        time.
///
/// #### TDT - Terrestrial Dynamical Time (also TT - Terrestrial Time)
///        The independent argument of apparent geocentric ephemerides.
///
/// #### TDB - Barycentric Dynamical Time
///        A coordinate time having its spatial origin at the center of mass of
///        the Earth.
///
/// #### TCG - Geocentric Coordinate Time
///        A relativistic coordinate time referred to the geocenter.
///
/// #### TCB - Barycentric Dynamical Time
///        A relativistic coordinate time having its spatial origin at the
///        solar system barycenter..
///
/// #### JD_* - Julian Date
///        The number of days elapsed since 1 Jan 4713 B.C. in a particular time
///        scale (e.g., JD_TAI, JD_UTC, etc)
///
/// #### MJD_* - Modified Julian Date
///        The Modified Julian Date (Julian Data minus 2400000.5) in a particular time
///        scale (e.g., MJD_TAI, MJD_UTC, etc).
///
/// #### GPST - GPS Satellite Time
///        The time scale used by the GPS satellites.
///
/// #### NTP - Network Time Protocol
///        The time scale used by Internet time servers for synchronization
///        purposes.
///
/// #### Besselian
///        Used in some astronomy applications.
///
/// ### Synchronizing your system clock to Coordinated Universal Time (UTC):
/// Software is available for most operating systems that synchronizes its
/// clock to the current UTC within a small fraction of a second using the Network Time
/// Protocol (NTP).  For applications--especially distributed applications--that
/// access the system clock and depend on its accuracy, such synchronization is
/// recommended.  More information can be found at http://www.ntp.org.
class TimeInstant extends Quantity {
  /// Constructs a TimeInstant in either [TAI] or [UTC] units.
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  TimeInstant({dynamic TAI, dynamic UTC, double uncert = 0.0})
      : super(TAI ?? (UTC ?? 0.0),
            UTC != null ? TimeInstant.UTC : TimeInstant.TAI, uncert);

  /// Constructs a instance without preferred units.
  TimeInstant.misc(dynamic conv)
      : super.misc(conv, TimeInstant.timeInstantDimensions);

  /// Constructs a TimeInstant based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  TimeInstant.inUnits(dynamic value, TimeInstantUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? TimeInstant.TAI, uncert);

  /// Constructs a constant TimeInstant object.
  const TimeInstant.constant(Number valueSI,
      {TimeInstantUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, TimeInstant.timeInstantDimensions, units, uncert);

  /// Constructs a TimeInstant from an existing [dateTime] object.
  TimeInstant.dateTime(DateTime dateTime, {double uncert = 0.0})
      : super(dateTime.millisecondsSinceEpoch, TimeInstant.system, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions timeInstantDimensions =
      Dimensions.constant(<String, int>{'Time': 1}, qType: TimeInstant);

  /// TAI  - International Atomic Time
  // ignore: non_constant_identifier_names
  static final TimeInstantUnits TAI = TimeInstantUnits(
      'International Atomic Time', null, 'TAI', null, 1.0, true, 0.0);

  /// UTC - Coordinated Universal Time
  // Note that UTC offset from TAI must be calculated dynamically--changes with
  // addition of leap seconds
  // ignore: non_constant_identifier_names
  static final TimeInstantUnits UTC = TimeInstantUnits(
      'Coordinated Universal Time', null, 'UTC', null, 1.0, false, 0.0,
      (dynamic d) {
    // Have to remove leap seconds when converting to UTC.
    var value = d is num
        ? d.toDouble()
        : d is Number
            ? d.toDouble()
            : 0.0;
    value -= getLeapSeconds(value);

    return value.toInt() == value ? Integer(value.toInt()) : Double(value);
  }, (dynamic d) {
    var value = d is num
        ? d.toDouble()
        : d is Number
            ? d.toDouble()
            : 0.0;

    // For conversion from UTC to TAI, the offset depends on the
    // time itself due to the addition of leap seconds.
    final leap1 = getLeapSeconds(value);
    if (leap1 > 0.0) {
      // Add in the leap seconds
      value += leap1;

      // Make sure that adding in leap seconds didn't make it cross
      // another leap second threshold.
      final leap2 = getLeapSeconds(value);
      if (leap2 != leap1) d += leap2 - leap1;
    }

    return value.toInt() == value ? Integer(value.toInt()) : Double(value);
  });

  /// Number of milliseconds since 1 Jan 1970 0h 0m 0s, which is the System
  /// time defined by the Dart VM.
  static final TimeInstantUnits system = TimeInstantUnits(
      'System Time (ms since 1 Jan 1970 0h 0m 0s)',
      null,
      'System Time',
      null,
      .001,
      false,
      4383000.0 * 86400.0,
      (dynamic d) => (UTC.fromMks(d) - 3.786912e8) * 1000, (dynamic d) {
    d = (d is num || d is Number) ? d.toDouble() : 0.0;
    // Get seconds in UTC time scale... (offset = 4383 days = 3.786912e14 ms)
    d = 0.001 * ((d as double) + 3.786912e11); // UTC seconds
    return UTC.toMks(d);
  });

  /// Returns a [DateTime] object that represents as closely as possible the time
  /// instant represented by this object.  DateTime objects are limited to
  /// millisecond precision and cannot describe times very far in the past or
  /// future.
  DateTime get nearestDateTime {
    var msSince1970 = valueInUnits(TimeInstant.system);

    // Adjust for rounding to closest date
    if (msSince1970 < 0.0) {
      msSince1970 -= 0.5;
    } else {
      msSince1970 += 0.5;
    }

    return DateTime.fromMillisecondsSinceEpoch(msSince1970.toInt(),
        isUtc: true);
  }

  /// Override the default [Quantity] subtraction operator to return a Time
  /// when another TimeInstant is subtracted or a TimeInstant when Time is subtracted.
  @override
  Quantity operator -(dynamic subtrahend) {
    final newValueSI = valueSI - subtrahend.valueSI;
    if (subtrahend is Quantity) {
      final diffUr = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, subtrahend, newValueSI);
      if (subtrahend is TimeInstant) {
        return Time(s: newValueSI, uncert: diffUr);
      } else if (subtrahend is Time) {
        return TimeInstant(TAI: newValueSI, uncert: diffUr);
      }
    }

    throw const QuantityException(
        'Only a Time or another TimeInstant can be subtracted from a TimeInstant');
  }

  /// Tests if this time instant is before the specified time instant.
  bool isBefore(TimeInstant when) => compareTo(when) == -1;

  /// Tests if this time instant is after the specified time instant.
  bool isAfter(TimeInstant when) => compareTo(when) == 1;

  /// Calculates the fraction of the (UTC) year that has elapsed for this time instant
  /// to millisecond precision.
  double get fractionOfYear {
    final dt = nearestDateTime;
    final yearStartMillis = DateTime(dt.year).millisecondsSinceEpoch;
    final yearEndMillis = DateTime(dt.year + 1).millisecondsSinceEpoch;

    return (dt.millisecondsSinceEpoch - yearStartMillis) /
        (yearEndMillis - yearStartMillis);
  }

  /// Returns true if the year that contains this TimeInstant is a leap year.
  /// Leap years occur every four years except on the hundreds (with the
  /// exception of every 400th year).
  bool get isLeapYear {
    final year = nearestDateTime.year;
    return (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
  }
}

typedef FromMksOverride = Number Function(dynamic mks);
typedef ToMksOverride = Number Function(dynamic val);

/// Units acceptable for use in describing TimeInstant quantities.
class TimeInstantUnits extends TimeInstant with Units {
  /// Constructs a instance.
  TimeInstantUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
      [bool metricBase = false, num offset = 0.0, this._fromMks, this._toMks])
      : super.misc(conv) {
    this.name = name;
    this.singular = singular;
    convToMKS = objToNumber(conv);
    this.abbrev1 = abbrev1;
    this.abbrev2 = abbrev2;
    this.metricBase = metricBase;
    this.offset = offset.toDouble();
  }

  final FromMksOverride? _fromMks;
  final ToMksOverride? _toMks;

  /// Calculates and returns the value in SI-MKS units of the specified [value]
  /// (that is implicitly in these units).
  @override
  Number toMks(dynamic value) {
    if (_toMks != null) {
      return Function.apply(_toMks as ToMksOverride, <dynamic>[value])
          as Number;
    } else {
      return super.toMks(value);
    }
  }

  /// Calculates and returns the value in the units represented by this Units
  /// object of [mks] (that is expected to be in SI-MKS units).
  @override
  Number fromMks(dynamic mks) {
    if (_fromMks != null) {
      return Function.apply(_fromMks as FromMksOverride, <dynamic>[mks])
          as Number;
    } else {
      return super.fromMks(mks);
    }
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => TimeInstant;

  /// Derive TimeInstantUnits using this TimeInstantUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      TimeInstantUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}

/// Returns the number of leap seconds in effect for the specified time
/// instant, [tai], specified in the TAI time scale.  The number of leap
/// seconds relates the UTC time scale to the TAI time scale.
///
/// UTC = TAI - leap seconds.
///
/// UTC, as of 2018, was running 37 seconds behind TAI.  Historical information
/// for leap seconds is available from http://tycho.usno.navy.mil
///
/// Integral leap seconds were instituted in 1972.  For the period 1961-1971,
/// 'official' leap seconds equations are used to relate TAI and UTC.  By default
/// these equations are ignored and all pre-1972 leap seconds values will
/// be returned as zero.  To instead use the parametric equations for leap
/// seconds between 1961 and the end of 1971, set [pre1972LeapSeconds] to true.
///
/// For dates before 1958, delta T should instead be
/// used to establish the relationship between Universal Time (UT1) and TAI.
/// UTC is not corrected for changes in the Earth's length of day before 1958.
num getLeapSeconds(double tai, {bool pre1972LeapSeconds = false}) {
  // Use the TAI scale to identify when leap seconds occur

  // Outside thresholds?
  if (tai < 94694400.0) {
    return 0; //   (2441317.5-2436204.5) * 86400.0         [< 1 Jan 1961]
  }
  if (tai >= 1861920036.0) {
    return 37; //  ((2457754.5-2436204.5) * 86400.0) + 36 [>= 1 Jan 2017]
  }

  // Pre-1972? (2441317.5 - 2436204.5) * 86400.0 [< 1 Jan 1972]
  if (tai < 441763200.0) {
    if (pre1972LeapSeconds) {
      // Even though the equations below use (presumably) the Julian Date in
      // the UTC time scale, we use the Julian Date in the TAI time scale.
      // This introduces a very small error on the order of 2x10^-7 seconds,
      // which is within the accuracy of this method.
      final mjdTAI = (tai / 86400.0) + 36204.0;

      if (tai < 113011201.6975700) {
        return 1.422818 + (mjdTAI - 37300.0) * 0.0012960; // [< 1 Aug 1961]
      }
      if (tai < 126230401.8458580) {
        return 1.372818 + (mjdTAI - 37300.0) * 0.0012960; // [< 1 Jan 1962]
      }
      if (tai < 184032002.5972788) {
        return 1.845858 + (mjdTAI - 37665.0) * 0.0011232; // [< 1 Nov 1963]
      }
      if (tai < 189302402.7657940) {
        return 1.945858 + (mjdTAI - 37665.0) * 0.0011232; // [< 1 Jan 1964]
      }
      if (tai < 197164802.8837300) {
        return 3.240130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Apr 1964]
      }
      if (tai < 210384003.1820180) {
        return 3.340130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Sep 1964]
      }
      if (tai < 220924803.4401300) {
        return 3.440130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Jan 1965]
      }
      if (tai < 226022403.6165940) {
        return 3.540130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Mar 1965]
      }
      if (tai < 236563203.8747060) {
        return 3.640130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Jul 1965]
      }
      if (tai < 241920004.0550580) {
        return 3.740130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Sep 1965]
      }
      if (tai < 252460804.3123170) {
        return 3.840130 + (mjdTAI - 38761.0) * 0.0012960; // [< 1 Jan 1966]
      }
      if (tai < 318211206.2856820) {
        return 4.313170 + (mjdTAI - 39126.0) * 0.0025920; // [< 1 Feb 1968]
      }
      return 4.213170 + (mjdTAI - 39126.0) * 0.0025920; // [< 1 Jan 1972]
    }

    return 0;
  }

  // Integral Leap Seconds (1972- )
  if (tai < 457488010.0) {
    return 10; // ((2441499.5-2436204.5) * 86400.0) + 10 [< 1 Jul 1972]
  }
  if (tai < 473385611.0) {
    return 11; // ((2441683.5-2436204.5) * 86400.0) + 11 [< 1 Jan 1973]
  }
  if (tai < 504921612.0) {
    return 12; // ((2442048.5-2436204.5) * 86400.0) + 12 [< 1 Jan 1974]
  }
  if (tai < 536457613.0) {
    return 13; // ((2442413.5-2436204.5) * 86400.0) + 13 [< 1 Jan 1975]
  }
  if (tai < 567993614.0) {
    return 14; // ((2442778.5-2436204.5) * 86400.0) + 14 [< 1 Jan 1976]
  }
  if (tai < 599616015.0) {
    return 15; // ((2443144.5-2436204.5) * 86400.0) + 15 [< 1 Jan 1977]
  }
  if (tai < 631152016.0) {
    return 16; // ((2443509.5-2436204.5) * 86400.0) + 16 [< 1 Jan 1978]
  }
  if (tai < 662688017.0) {
    return 17; // ((2443874.5-2436204.5) * 86400.0) + 17 [< 1 Jan 1979]
  }
  if (tai < 694224018.0) {
    return 18; // ((2444239.5-2436204.5) * 86400.0) + 18 [< 1 Jan 1980]
  }
  if (tai < 741484819.0) {
    return 19; // ((2444786.5-2436204.5) * 86400.0) + 19 [< 1 Jul 1981]
  }
  if (tai < 773020820.0) {
    return 20; // ((2445151.5-2436204.5) * 86400.0) + 20 [< 1 Jul 1982]
  }
  if (tai < 804556821.0) {
    return 21; // ((2445516.5-2436204.5) * 86400.0) + 21 [< 1 Jul 1983]
  }
  if (tai < 867715222.0) {
    return 22; // ((2446247.5-2436204.5) * 86400.0) + 22 [< 1 Jul 1985]
  }
  if (tai < 946684823.0) {
    return 23; // ((2447161.5-2436204.5) * 86400.0) + 23 [< 1 Jan 1988]
  }
  if (tai < 1009843224.0) {
    return 24; // ((2447892.5-2436204.5) * 86400.0) + 24 [< 1 Jan 1990]
  }
  if (tai < 1041379225.0) {
    return 25; // ((2448257.5-2436204.5) * 86400.0) + 25 [< 1 Jan 1991]
  }
  if (tai < 1088640026.0) {
    return 26; // ((2448804.5-2436204.5) * 86400.0) + 26 [< 1 Jul 1992]
  }
  if (tai < 1120176027.0) {
    return 27; // ((2449169.5-2436204.5) * 86400.0) + 27 [< 1 Jul 1993]
  }
  if (tai < 1151712028.0) {
    return 28; // ((2449534.5-2436204.5) * 86400.0) + 28 [< 1 Jul 1994]
  }
  if (tai < 1199145629.0) {
    return 29; // ((2450083.5-2436204.5) * 86400.0) + 29 [< 1 Jan 1996]
  }
  if (tai < 1246406430.0) {
    return 30; // ((2450630.5-2436204.5) * 86400.0) + 30 [< 1 Jul 1997]
  }
  if (tai < 1293840031.0) {
    return 31; // ((2451179.5-2436204.5) * 86400.0) + 31 [< 1 Jan 1999]
  }
  if (tai < 1514764832.0) {
    return 32; // ((2453736.5-2436204.5) * 86400.0) + 32 [< 1 Jan 2006]
  }
  if (tai < 1609459233.0) {
    return 33; // ((2454832.5-2436204.5) * 86400.0) + 33 [< 1 Jan 2009]
  }
  if (tai < 1719792034.0) {
    return 34; // ((2456109.5-2436204.5) * 86400.0) + 34 [< 1 Jul 2012]
  }
  if (tai < 1814400035.0) {
    return 35; // ((2457204.5-2436204.5) * 86400.0) + 35 [< 1 Jul 2015]
  }
  return 36; // ((2457754.5-2436204.5) * 86400.0) + 36 [< 1 Jan 2017]

  // 37 [>= 1861920036.0; 1 Jan 2017] handled at start of method.
}

/// Returns the value 'Delta T,' in seconds, which relates the Terrestrial Dynamical Time
/// scale to measured Universal Time (and indirectly UTC to TAI before 1972,
/// when leap seconds were introduced).
///
/// Delta T = TDT - UT1 = (TAI-UTC) - (UT1-UTC) + 32.184s
///
/// Delta T, as of 2002, was about 64.3 s.
///
/// For 1620-present, Delta T is calculated using a table of delta T values
/// determined from historical observations (and published in the Astronomical
/// Almanac.  For dates prior to 1620, approximate polynomial algorithms are
/// used `[Chapront, Chapront-Touze & Francou (1997)]`.
///
/// Because Delta T depends on measured values of the Earth's rotation that
/// result from irregular and complex tidal forces for which accurate predictive
/// models do not exist, the future values of Delta T are crudely estimated.  For
/// times in the future relative to the last data point in the internal delta T data array,
/// the last delta T value is returned (no reliable predictive models are available
/// and a 'flat line' prediction is as valid as any other.  This method will
/// continue to work if additional data is added directly to the internal delta T data array.
double getDeltaT(TimeInstant time) {
  final dt = time.nearestDateTime;
  final year = dt.year;

  if (year < -391) {
    // JPL (used > -3000)
    return 31.0 * (year - 1820.0) / 100.0;
  } else if (year < 948) {
    final u = (year - 2000.0) / 100.0;
    return 2177.0 +
        (497.0 * u) +
        (44.1 * u * u); // Chapront, Chapront-Touze & Francou (1997)
  } else if (year < 1620) {
    final u = (year - 2000.0) / 100.0;
    return 102.0 +
        (102.0 * u) +
        (25.3 * u * u); // Chapront, Chapront-Touze & Francou (1997)
  } else {
    // Use tables of direct observations and interpolate between years
    if (_deltaT == null) _initDeltaT();

    final index1 = year - 1620;
    final index2 = index1 + 1;

    if (index1 > ((_deltaT as List<num>).length - 2)) {
      // Out of range... just use the last value (as good a guess as any!)
      return ((_deltaT as List<num>)[(_deltaT as List<num>).length - 1])
          .toDouble();
    } else {
      final dt1 = (_deltaT as List<num>)[index1];
      final dt2 = (_deltaT as List<num>)[index2];
      final change = dt2 - dt1;

      return (dt1 + time.fractionOfYear * change).toDouble();
    }
  }
}

List<num>? _deltaT;

/// Initializes the values in the _deltaT array, which is used by the
/// getDeltaT() method.  Delta T relates TDT to UT1.
void _initDeltaT() {
  // Year by year values for delta T from observations (1620-2002)
  final f = <num>[
    124.00,
    119.00,
    115.00,
    110.00,
    106.00,
    102.00,
    98.00,
    95.00,
    91.00,
    88.00, // 1620-1629
    85.00,
    82.00,
    79.00,
    77.00,
    74.00,
    72.00,
    70.00,
    67.00,
    65.00,
    63.00, // 1630-1639
    62.00,
    60.00,
    58.00,
    57.00,
    55.00,
    54.00,
    53.00,
    51.00,
    50.00,
    49.00, // 1640-1649
    48.00,
    47.00,
    46.00,
    45.00,
    44.00,
    43.00,
    42.00,
    41.00,
    40.00,
    38.00, // 1650-1659
    37.00,
    36.00,
    35.00,
    34.00,
    33.00,
    32.00,
    31.00,
    30.00,
    28.00,
    27.00, // 1660-1669
    26.00,
    25.00,
    24.00,
    23.00,
    22.00,
    21.00,
    20.00,
    19.00,
    18.00,
    17.00, // 1670-1679
    16.00,
    15.00,
    14.00,
    14.00,
    13.00,
    12.00,
    12.00,
    11.00,
    11.00,
    10.00, // 1680-1689
    10.00,
    10.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00, // 1690-1699

    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    9.00,
    10.00,
    10.00, // 1700-1709
    10.00,
    10.00,
    10.00,
    10.00,
    10.00,
    10.00,
    10.00,
    11.00,
    11.00,
    11.00, // 1710-1719
    11.00,
    11.00,
    11.00,
    11.00,
    11.00,
    11.00,
    11.00,
    11.00,
    11.00,
    11.00, // 1720-1729
    11.00,
    11.00,
    11.00,
    11.00,
    12.00,
    12.00,
    12.00,
    12.00,
    12.00,
    12.00, // 1730-1739
    12.00,
    12.00,
    12.00,
    12.00,
    12.00,
    13.00,
    13.00,
    13.00,
    13.00,
    13.00, // 1740-1749
    13.00,
    14.00,
    14.00,
    14.00,
    14.00,
    14.00,
    14.00,
    14.00,
    15.00,
    15.00, // 1750-1759
    15.00,
    15.00,
    15.00,
    15.00,
    15.00,
    16.00,
    16.00,
    16.00,
    16.00,
    16.00, // 1760-1769
    16.00,
    16.00,
    16.00,
    16.00,
    16.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00, // 1770-1779
    17.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00,
    17.00, // 1780-1789
    17.00,
    17.00,
    16.00,
    16.00,
    16.00,
    16.00,
    15.00,
    15.00,
    14.00,
    14.00, // 1790-1799

    13.40,
    13.10,
    12.90,
    12.70,
    12.60,
    12.50,
    12.50,
    12.50,
    12.50,
    12.50, // 1800-1809
    12.50,
    12.50,
    12.50,
    12.50,
    12.50,
    12.50,
    12.50,
    12.40,
    12.30,
    12.20, // 1810-1819
    12.00,
    11.70,
    11.40,
    11.10,
    10.60,
    10.20,
    9.60,
    9.10,
    8.60,
    8.00, // 1820-1829
    7.50,
    7.00,
    6.60,
    6.30,
    6.00,
    5.80,
    5.70,
    5.60,
    5.60,
    5.60, // 1830-1839
    5.70,
    5.80,
    5.90,
    6.10,
    6.20,
    6.30,
    6.50,
    6.60,
    6.80,
    6.90, // 1840-1849
    7.10,
    7.20,
    7.30,
    7.40,
    7.50,
    7.60,
    7.70,
    7.70,
    7.80,
    7.80, // 1850-1859
    7.88,
    7.82,
    7.54,
    6.97,
    6.40,
    6.02,
    5.41,
    4.10,
    2.92,
    1.82, // 1860-1869
    1.61,
    0.10,
    -1.02,
    -1.28,
    -2.69,
    -3.24,
    -3.64,
    -4.54,
    -4.71,
    -5.11, // 1870-1879
    -5.40,
    -5.42,
    -5.20,
    -5.46,
    -5.46,
    -5.79,
    -5.63,
    -5.64,
    -5.80,
    -5.60, // 1880-1889
    -5.87,
    -6.01,
    -6.19,
    -6.64,
    -6.44,
    -6.47,
    -6.09,
    -5.76,
    -4.66,
    -3.74, // 1890-1899

    -2.72,
    -1.54,
    -0.02,
    1.24,
    2.64,
    3.86,
    5.37,
    6.14,
    7.75,
    9.13, // 1900-1909
    10.46,
    11.53,
    13.36,
    14.65,
    16.01,
    17.20,
    18.24,
    19.06,
    20.25,
    20.95, // 1910-1919
    21.16,
    22.25,
    22.41,
    23.03,
    23.49,
    23.62,
    23.86,
    24.49,
    24.34,
    24.08, // 1920-1929
    24.02,
    24.00,
    23.87,
    23.95,
    23.86,
    23.93,
    23.73,
    23.92,
    23.96,
    24.02, // 1930-1939
    24.33,
    24.83,
    25.30,
    25.70,
    26.24,
    26.77,
    27.28,
    27.78,
    28.25,
    28.71, // 1940-1949
    29.15,
    29.57,
    29.97,
    30.36,
    30.72,
    31.07,
    31.35,
    31.68,
    32.18,
    32.68, // 1950-1959
    33.15,
    33.59,
    34.00,
    34.47,
    35.03,
    35.73,
    36.54,
    37.43,
    38.29,
    39.20, // 1960-1969
    40.18,
    41.17,
    42.23,
    43.37,
    44.49,
    45.48,
    46.46,
    47.52,
    48.53,
    49.59, // 1970-1979
    50.54,
    51.38,
    52.17,
    52.96,
    53.79,
    54.34,
    54.87,
    55.32,
    55.82,
    56.30, // 1980-1989
    56.86,
    57.57,
    58.31,
    59.12,
    59.98,
    60.78,
    61.63,
    62.29,
    62.97,
    63.47, // 1990-1999

    63.83,
    64.09,
    64.30,
    64.47,
    64.57,
    64.69,
    64.85,
    65.15,
    65.45,
    65.78, // 2000-2009
    66.07,
    66.32,
    66.60,
    66.91,
    67.28,
    67.64,
    68.10,
    68.59,
    68.96,
    69.22, // 2010-2019
    69.36,
  ];

  _deltaT = f;
}

/// Calculates and returns the number of seconds (including any
/// leap seconds) that are in the UTC day containing the specified
/// second, [utc].
double secondsInUtcDay(double utc) {
  // Adjust to midnight by subtracting 43200.
  final d0 = (utc - 43200) ~/ 86400.0;
  final d1 = d0 + 1;

  final tai1 = TimeInstant.UTC.toMks(d0 * 86400.0);

  // UTC seconds at (close to) the following UTC midnight
  // (as long as it's well past noon, which is when the leap seconds are added)
  final tai2 = TimeInstant.UTC.toMks(d1 * 86400.0);

  // Return number of seconds on this UTC day
  return (tai2 - tai1).toDouble();
}
