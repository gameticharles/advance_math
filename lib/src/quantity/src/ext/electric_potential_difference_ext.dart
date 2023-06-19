import '../si/types/electric_potential_difference.dart';

/// The standard SI unit.
ElectricPotentialDifferenceUnits volts = ElectricPotentialDifference.volts;

/// The unit of electromotive force (EMF) or potential difference in the CGS (centimeter/gram/second)
/// electromagnetic system of units. When an EMF of 1 abV exists between two points, then one erg of energy
/// is needed to move one abcoulomb (1 abC) of charge carriers between those two points.
ElectricPotentialDifferenceUnits abvolts = ElectricPotentialDifferenceUnits('abvolts', 'abV', null, null, 1.0e-8, true);

/// A useful unit for electromagnetism because, in a vacuum, an electric field of one statvolt/cm has
/// the same energy density as a magnetic field of one gauss. Likewise, a plane wave propagating in a
/// vacuum has perpendicular electric and magnetic fields such that for every gauss of magnetic field
/// intensity there is one statvolt/cm of electric field intensity.
ElectricPotentialDifferenceUnits statvolts =
    ElectricPotentialDifferenceUnits('statvolts', null, null, null, 2.9979e2, false);

// Convenience units.

/// Synonymous with [abvolts].
ElectricPotentialDifferenceUnits emuPotential = abvolts;

/// Synonymous with [statvolts].
ElectricPotentialDifferenceUnits esuPotential = statvolts;
