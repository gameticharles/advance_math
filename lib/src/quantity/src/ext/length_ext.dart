import '../../number.dart';
import '../si/types/length.dart';
import '../si/units.dart';

/// Units acceptable for use in describing Length quantities.
class LengthUnits extends Length with Units {
  /// Constructs a instance.
  LengthUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Length;

  /// Derive LengthUnits using this LengthUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      LengthUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);

  /// The standard SI unit.
  static final LengthUnits meters =
      LengthUnits('meters', 'm', null, null, 1.0, true);

  /// Accepted for use with the SI... the value of the astronomical unit must be
  /// obtained by experiment and is therefore not known exactly... its value is
  /// such that, when used to describe the motion of bodies in the solar system,
  /// the heliocentric gravitation constant is 0.017 202 098 85 squared (in units
  /// of ua+3 d-2, where d is day).
  static final LengthUnits astronomicalUnits = LengthUnits(
      'astronomical units', 'AU', 'ua', null, 1.495978707e11, false);

  /// Accepted for use with the SI, subject to further review.
  static final LengthUnits angstroms =
      LengthUnits('angstroms', '\u212b', '\u00c5', null, 1.0e-10, true);

  /// Accepted for use with the SI, subject to further review.
  static final LengthUnits nauticalMiles =
      LengthUnits('nautical miles', null, 'NM', null, 1.852e3, false);

  // Convenience Units.

  // Metric units

  /// A unit of 10^24 meters.
  static final LengthUnits yottameters = meters.yotta() as LengthUnits;

  /// A unit of 10^21 meters.
  static final LengthUnits zettameters = meters.zetta() as LengthUnits;

  /// A unit of 10^18 meters.
  static final LengthUnits exameters = meters.exa() as LengthUnits;

  /// A unit of 10^15 meters.
  static final LengthUnits petameters = meters.peta() as LengthUnits;

  /// A unit of 10^12 meters.
  static final LengthUnits terameters = meters.tera() as LengthUnits;

  /// A unit of one billion meters.
  static final LengthUnits gigameters = meters.giga() as LengthUnits;

  /// A unit of one million meters.
  static final LengthUnits megameters = meters.mega() as LengthUnits;

  /// A unit of one thousand meters.
  static final LengthUnits kilometers = meters.kilo() as LengthUnits;

  /// A unit of one hundred meters.
  static final LengthUnits hectometers = meters.hecto() as LengthUnits;

  /// A unit of ten meters.
  static final LengthUnits dekameters = meters.deka() as LengthUnits;

  /// A unit of one tenth of a meter.
  static final LengthUnits decimeters = meters.deci() as LengthUnits;

  /// A unit of one hundredth of a meter.
  static final LengthUnits centimeters = meters.centi() as LengthUnits;

  /// A unit of one thousandth of a meter.
  static final LengthUnits millimeters = meters.milli() as LengthUnits;

  /// A unit of one millionth of a meter.
  static final LengthUnits micrometers = meters.micro() as LengthUnits;

  /// A unit of one billionth of a meter.
  static final LengthUnits nanometers = meters.nano() as LengthUnits;

  /// A unit of 10^-12 meters.
  static final LengthUnits picometers = meters.pico() as LengthUnits;

  /// A unit of 10^-15 meters.
  static final LengthUnits femtometers = meters.femto() as LengthUnits;

  /// A unit of 10^-18 meters.
  static final LengthUnits attometers = meters.atto() as LengthUnits;

  /// A unit of 10^-21 meters.
  static final LengthUnits zeptometers = meters.zepto() as LengthUnits;

  /// A unit of 10^-24 meters.
  static final LengthUnits yoctometers = meters.yocto() as LengthUnits;

  /// A non-standard unit of length.
  static final LengthUnits fermis =
      LengthUnits('fermis', null, null, null, 1.0e-15, true);

  /// A non-standard unit of length.
  static final LengthUnits cables =
      LengthUnits('cables', null, null, null, 2.19456e2, false);

  /// A non-standard unit of length.
  static final LengthUnits calibers =
      LengthUnits('calibers', null, null, null, 2.54e-4, false);

  /// A non-standard unit of length.
  static final LengthUnits chainsSurveyor = LengthUnits(
      'chains (surveyor)', null, null, 'chain (surveyor)', 2.01168e1, false);

  /// A non-standard unit of length.
  static final LengthUnits chainsEngineer = LengthUnits(
      'chains (engineer)', null, null, 'chain (engineer)', 3.048e1, false);

  /// A non-standard unit of length.
  static final LengthUnits cubits =
      LengthUnits('cubits', null, null, null, 5.472e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits fathoms =
      LengthUnits('fathoms', null, null, null, 1.8288, false);

  /// A non-standard unit of length.
  static final LengthUnits feet =
      LengthUnits('feet', "'", 'ft', 'foot', 3.048e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits feetUsSurvey = LengthUnits('feet (US survey)',
      'ft (US)', null, 'foot (US survey)', 3.048006096e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits furlongs =
      LengthUnits('furlongs', null, null, null, 2.01168e2, false);

  /// A non-standard unit of length.
  static final LengthUnits hands =
      LengthUnits('hands', null, null, null, 1.016e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits inches =
      LengthUnits('inches', '\'', 'in', 'inch', 2.54e-2, false);

  /// A non-standard unit of length.
  static final LengthUnits leaguesUkNautical = LengthUnits(
      'leagues (UK nautical)',
      null,
      null,
      'league (UK nautical)',
      5.559552e3,
      false);

  /// A non-standard unit of length.
  static final LengthUnits leaguesNautical = LengthUnits(
      'leagues (nautical)', null, null, 'league (nautical)', 5.556e3, false);

  /// A non-standard unit of length.
  static final LengthUnits leaguesStatute = LengthUnits(
      'leagues (statute)', null, null, 'league (statute)', 4.828032e3, false);

  /// The distance light travels in one year.
  static final LengthUnits lightYears =
      LengthUnits('light years', 'LY', null, null, 9.46055e15, false);

  /// Light days (25,902,068,371,200 meters) - distance traveled by light in a day.
  static final LengthUnits lightDays =
      LengthUnits('light days', 'LD', null, null, 25902068371200, false);

  /// Light hours (1,079,252,848,800 meters) - distance traveled by light in an hour.
  static final LengthUnits lightHours =
      LengthUnits('light hours', 'LH', null, null, 1079252848800, false);

  /// Light minutes (17,987,547,480 meters) - distance traveled by light in a minute.
  static final LengthUnits lightMinutes =
      LengthUnits('light minutes', 'LM', null, null, 17987547480, false);

  /// Light seconds (299,792,458 meters) - distance traveled by light in a second.
  static final LengthUnits lightSeconds =
      LengthUnits('light seconds', 'LS', null, null, 299792458, false);

  /// Light milliseconds (299,792.458 meters) - distance traveled by light in a millisecond.
  static final LengthUnits lightMilliseconds =
      LengthUnits('light milliseconds', 'Lms', null, null, 299792.458, false);

  /// Light microseconds (0.299792458 meters) - distance traveled by light in a microsecond.
  static final LengthUnits lightMicroseconds =
      LengthUnits('light microseconds', 'Lms', null, null, 0.299792458, false);

  /// Light nanoseconds (0.000299792458 meters) - distance traveled by light in a nanosecond.
  static final LengthUnits lightNanoseconds =
      LengthUnits('light nanoseconds', 'Lns', null, null, 2.99792458e-4, false);

  /// Lunar distances (384,400,000 meters) - average distance from Earth to the Moon.
  static final LengthUnits lunarDistances =
      LengthUnits('lunar distances', 'ld', null, null, 384400000, false);

  /// Football fields (91.44 meters) - length of a standard American football field.
  static final LengthUnits footballFields =
      LengthUnits('football fields', 'ff', null, null, 91.44, false);

  /// A non-standard unit of length.
  static final LengthUnits linksEngineer = LengthUnits(
      'links (engineer)', null, null, 'link (engineer)', 3.048e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits linksSurveyor = LengthUnits(
      'links (surveyor)', null, null, 'link (surveyor)', 2.01168e-1, false);

  /// A synonym for micrometers.
  static final LengthUnits microns = meters.micro() as LengthUnits;

  /// A non-standard unit of length.
  static final LengthUnits mils =
      LengthUnits('mils', null, null, null, 2.54e-5, false);

  /// A non-standard unit of length.
  static final LengthUnits miles =
      LengthUnits('miles', 'mi', null, null, 1.609344e3, false);

  /// A non-standard unit of length.
  static final LengthUnits nauticalMilesUk = LengthUnits('nautical miles (UK)',
      'NM (UK)', null, 'nautical mile (UK)', 1.853184e3, false);

  /// A non-standard unit of length.
  static final LengthUnits paces =
      LengthUnits('paces', null, null, null, 7.62e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits parsecs =
      LengthUnits('parsecs', 'pc', null, null, 3.0857e16, false);

  /// A non-standard unit of length.
  static final LengthUnits perches =
      LengthUnits('perches', null, null, 'perch', 5.0292, false);

  /// A non-standard unit of length.
  static final LengthUnits picas =
      LengthUnits('picas', null, null, null, 4.2175176e-3, false);

  /// A non-standard unit of length.
  static final LengthUnits points =
      LengthUnits('points', null, null, null, 3.514598e-4, false);

  /// A non-standard unit of length.
  static final LengthUnits poles =
      LengthUnits('poles', null, null, null, 5.0292, false);

  /// A non-standard unit of length.
  static final LengthUnits rods =
      LengthUnits('rods', null, null, null, 5.0292, false);

  /// A non-standard unit of length.
  ///
  /// Swimming pools (25 meters) - length of an average swimming pool.
  static final LengthUnits swimmingPools =
      LengthUnits('swimming pools', null, null, null, 25, false);

  /// A non-standard unit of length.
  ///
  /// Eiffel towers (324 meters) - height of the Eiffel Tower.
  static final LengthUnits eiffelTower =
      LengthUnits('Eiffel tower', null, null, null, 324, false);

  /// A non-standard unit of length.
  ///
  /// Mount Everests (8,848 meters) - height of Mount Everest.
  static final LengthUnits mountEverest =
      LengthUnits('Mount Everest', null, null, null, 8848, false);

  /// A non-standard unit of length.
  static final LengthUnits skeins =
      LengthUnits('skeins', null, null, null, 1.09728e2, false);

  /// A non-standard unit of length.
  static final LengthUnits spans =
      LengthUnits('spans', null, null, null, 2.286e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits yards =
      LengthUnits('yards', 'yd', null, null, 9.144e-1, false);

  /// A non-standard unit of length.
  static final LengthUnits xUnits =
      LengthUnits('X units', 'Siegbahn', 'Xu', null, 1.00208e-13, false);

  /// A non-standard unit of length.
  static final LengthUnits angstromStars =
      LengthUnits('Angstrom stars', 'A*', null, null, 1.00001495e-10, false);
}

// CONSTANTS.

/// A constant representing zero length.
const Length lengthZero = Length.constant(Double.zero);

/// The threshold length at which classical ideas about gravity and space-time cease to be valid
/// and quantum effects dominate.
const Length planckLength = Length.constant(Double.constant(1.616255e-35),
    uncert: 0.000011136856498510445);

/// Often used to represent the wavelengths of X rays and the distances between atoms in crystals.
const Length angstromStar = Length.constant(Double.constant(1.00001495e-10),
    uncert: 8.999865452011492e-7);

/// The mean radius of the orbit of an electron around the nucleus of a hydrogen atom at its ground state.
const Length bohrRadius = Length.constant(Double.constant(5.29177210903e-11),
    uncert: 1.511780899700616e-10);

/// The wavelength of a photon whose energy is the same as the mass energy equivalent of that particle.
const Length comptonWavelength = Length.constant(
    Double.constant(2.42631023867e-12),
    uncert: 3.0086836727035986e-10);

/// The tau Compton wavelength.
const Length tauComptonWavelength = Length.constant(
    Double.constant(6.97771e-16),
    uncert: 0.00006735734216526625);

/// The classical electron radius is a combination of fundamental physical quantities that define a length scale
/// for problems involving an electron interacting with electromagnetic radiation.
const Length classicalElectronRadius = Length.constant(
    Double.constant(2.8179403262e-15),
    uncert: 4.6132985426027577e-10);
