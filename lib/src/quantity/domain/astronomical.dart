/// Quantity types, units and constants commonly encountered in the field of Astronomy and related sciences.
library astronomical;

import '../quantity.dart';

export '../quantity.dart'
    // show
    //     gees,
    //     yearsTropical,
    //     yearsSidereal,
    //     yearsJulian,
    //     astronomicalUnits,
    //     parsecs,
    //     lightYears,
    //     xUnits,
    //     solarLuminosity,
    //     janskys,
    //     Acceleration,
    //     AccelerationUnits,
    //     Frequency,
    //     EnergyFlux,
    //     Length,
    //     Mass,
    //     Power,
    //     SpectralIrradianceUnits,
    //     TimeUnits,
    //     LengthUnits
    ;

export 'thermodynamic.dart' show wienDisplacement;

/// One millionth of a Jansky.
SpectralIrradianceUnits microjanskys =
    janskys.micro() as SpectralIrradianceUnits;

// ---------------------

// Astronomical Constants

/// The gravitational acceleration experienced at the 'surface' of the Sun.
const Acceleration gravitySolarSurface =
    Acceleration.constant(Double.constant(274));

/// Used to describe the expansion of the universe.
const Frequency hubbleConstant =
    Frequency.constant(Double.constant(2.4e-18), uncert: 0.3333333333);

/// The mean solar electromagnetic radiation (the solar irradiance) per unit area that would be incident on a
/// plane perpendicular to the rays, at a distance of one astronomical unit (AU) from the Sun.
///
/// The solar 'constant' is actually not constant.  It has been shown to vary historically in the past 400 years
/// over a range of less than 0.2 percent.
const EnergyFlux solarConstant = EnergyFlux.constant(Double.constant(1370));

/// The radius of the Sun.
// ignore: prefer_int_literals
const Length solarRadius = Length.constant(Double.constant(6.9599e8));

/// The radius of the Earth at the equator.
const Length earthRadiusEquatorial = Length.constant(Double.constant(6378.164));

/// Mass of the Sun.
const Mass solarMass = Mass.constant(Double.constant(1.989e30));

/// Mass of the Earth.
const Mass earthMass = Mass.constant(Double.constant(5.972e24));
