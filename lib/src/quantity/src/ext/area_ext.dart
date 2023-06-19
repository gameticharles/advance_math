import '../number/double.dart';
import '../si/types/area.dart';
import 'length_ext.dart';

/// The standard SI unit.
final AreaUnits squareMeters = Area.squareMeters;

/// Accepted for use with the SI, subject to further review.
/// Equals one square dekameter, or 100 square meters.
final AreaUnits ares = Area.ares;

/// Accepted for use with the SI, subject to further review.
/// Equals 100 square femtometers, or 1.0e-28 square meters.
final AreaUnits barns = Area.barns;

/// Accepted for use with the SI, subject to further review.
/// Equals 1 square hectometer, or 10 000 square meters.
final AreaUnits hectares = Area.hectares;

/// An acre is about three-quarters of the size of an American football field.
final AreaUnits acres =
    AreaUnits('acres', null, null, null, 4.0468564224e3, false);

/// Equal to the area of a circle with a diameter of one mil (one thousandth of an inch).
/// It is often used for representing the area of a wire's circular cross section.
final AreaUnits circularMils =
    AreaUnits('circular mils', null, null, null, 5.0670748e-10, false);

/// An area unit equivalent to a square with sides having a length of one foot.
final AreaUnits squareFeet = AreaUnits.lengthSquared(LengthUnits.feet);

/// An area unit equivalent to a square with sides having a length of one inch.
final AreaUnits squareInches = AreaUnits.lengthSquared(LengthUnits.inches);

/// An area unit equivalent to a square with sides having a length of one kilometer.
final AreaUnits squareKilometers =
    AreaUnits.lengthSquared(LengthUnits.kilometers);

/// An area unit equivalent to a square with sides having a length of one centimeter.
final AreaUnits squareCentimeters =
    AreaUnits.lengthSquared(LengthUnits.centimeters);

/// An area unit equivalent to a square with sides having a length of one mile.
final AreaUnits squareMiles = AreaUnits.lengthSquared(LengthUnits.miles);

/// An area unit used in US surveyors' measures equalling 36 square miles.
final AreaUnits townships =
    AreaUnits('townships', null, null, null, 9.3239572e7, false);

/// An area unit equivalent to a square with sides having a length of one yard.
final AreaUnits squareYards = AreaUnits.lengthSquared(LengthUnits.yards);

/// An area unit equivalent to a square with sides having a length of one rod.
final AreaUnits squareRods = AreaUnits.lengthSquared(LengthUnits.rods);

// Synonym units.

/// Synonymous with [squareMiles].
final AreaUnits sections = squareMiles;

/// Synonymous with [squareRods].
final AreaUnits squarePoles = squareRods;

/// Synonymous with [squareRods].
final AreaUnits squarePerches = squareRods;

// Constants.

/// Helpful for describing the scattering of photons when the energy of each individual photon is much smaller
/// than the rest energy of the electron.
const Area thomsonCrossSection = Area.constant(
    Double.constant(6.6524587321e-29),
    uncert: 9.019221676713751e-10);

/// A synonym for the [thomsonCrossSection].
const Area sigma0 = thomsonCrossSection;
