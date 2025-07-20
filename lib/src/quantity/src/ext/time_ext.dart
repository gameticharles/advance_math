import '../../../number/number/double.dart';
import '../si/types/time.dart';

// Metric units.

/// 10^24 seconds.
final TimeUnits yottaseconds = Time.seconds.yotta() as TimeUnits;

/// 10^21 seconds.
final TimeUnits zettaseconds = Time.seconds.zetta() as TimeUnits;

/// 10^18 seconds.
final TimeUnits exaseconds = Time.seconds.exa() as TimeUnits;

/// 10^15 seconds.
final TimeUnits petaseconds = Time.seconds.peta() as TimeUnits;

/// 10^12 seconds.
final TimeUnits teraseconds = Time.seconds.tera() as TimeUnits;

/// A billion seconds.
final TimeUnits gigaseconds = Time.seconds.giga() as TimeUnits;

/// A million seconds.
final TimeUnits megaseconds = Time.seconds.mega() as TimeUnits;

/// A thousand seconds.
final TimeUnits kiloseconds = Time.seconds.kilo() as TimeUnits;

/// A hundred seconds.
final TimeUnits hectoseconds = Time.seconds.hecto() as TimeUnits;

/// Ten seconds.
final TimeUnits dekaseconds = Time.seconds.deka() as TimeUnits;

/// The standard SI unit.
final TimeUnits seconds = Time.seconds;

/// A tenth of a second.
final TimeUnits deciseconds = Time.seconds.deci() as TimeUnits;

/// A hundredth of a second.
final TimeUnits centiseconds = Time.seconds.centi() as TimeUnits;

/// A thousandth of a second.
final TimeUnits milliseconds = Time.milliseconds;

/// A millionth of a second.
final TimeUnits microseconds = Time.microseconds;

/// A billionth of a second.
final TimeUnits nanoseconds = Time.nanoseconds;

/// 10^-12 of a second.
final TimeUnits picoseconds = Time.seconds.pico() as TimeUnits;

/// 10^-15 of a second.
final TimeUnits femtoseconds = Time.seconds.femto() as TimeUnits;

/// 10^-18 of a second.
final TimeUnits attoseconds = Time.seconds.atto() as TimeUnits;

/// 10^-21 of a second.
final TimeUnits zeptoseconds = Time.seconds.zepto() as TimeUnits;

/// 10^-24 of a second.
final TimeUnits yoctoseconds = Time.seconds.yocto() as TimeUnits;

/// Accepted for use with the SI.
final TimeUnits daysMeanSolar = Time.daysMeanSolar;

/// Accepted for use with the SI.
final TimeUnits hoursMeanSolar = Time.hoursMeanSolar;

/// Accepted for use with the SI.
final TimeUnits minutesMeanSolar = Time.minutesMeanSolar;

/// Accepted for use with the SI.
final TimeUnits minutes = minutesMeanSolar;

/// Accepted for use with the SI.
final TimeUnits hours = hoursMeanSolar;

/// Accepted for use with the SI.
final TimeUnits days = daysMeanSolar;

// Non-SI units

/// A sidereal day is the time between two consecutive transits of the First Point of Aries. It represents the time
/// taken by the Earth to rotate on its axis relative to the stars, and is almost four minutes shorter than the solar
/// day because of the Earth's orbital motion.
final TimeUnits daysSidereal = TimeUnits('days (sidereal)', null, 'days (sid)',
    'day (sidereal)', 8.6164090e4, false);

/// A unit of one hour in the sidereal day.
final TimeUnits hoursSidereal = TimeUnits('hours (sidereal)', null, 'hr (sid)',
    'hour (sidereal)', 3.5901704e3, false);

/// A unit of one minute in the sidereal day.
final TimeUnits minutesSidereal = TimeUnits('minutes (sidereal)', null,
    'min (sid)', 'minute (sidereal)', 5.9836174e1, false);

/// A unit of one second in the sidereal day.
final TimeUnits secondsSidereal = TimeUnits('seconds (sidereal)', null,
    's (sid)', 'second (sidereal)', 9.9726957e-1, false);

/// Calendar years as a unit.
final TimeUnits yearsCalendar =
    TimeUnits('years', null, 'yr', null, 3.1536e7, false);

/// Sidereal years as a unit.
final TimeUnits yearsSidereal = TimeUnits('years (sidereal)', null, 'yr (sid)',
    'year (sidereal)', 3.1558150e7, false);

/// Tropical years as a unit.
final TimeUnits yearsTropical = TimeUnits('years (tropical)', null, 'yr (trop)',
    'year (tropical)', 3.1556926e7, false);

/// Defined as exactly 365.25 days of 86400 SI seconds each.
/// The length of the Julian year is the average length of the year in the Julian calendar that was used in Western
/// societies until some centuries ago, and from which the unit is named.
final TimeUnits yearsJulian = TimeUnits(
    'years (Julian)', null, 'yr (Jul)', 'year (Julian)', 3.15576e7, false);

/// A unit of one billion years.
final TimeUnits aeons =
    TimeUnits('aeons', null, 'aeons', null, 3.1536e18, false);

/// A synonym for [aeons].
final TimeUnits eons = aeons;

// Constants.

/// The time required for light to travel in a vacuum a distance of one Planck length.
const Time planckTime = Time.constant(Double.constant(5.391247e-44),
    uncert: 0.000011129150639916886);
