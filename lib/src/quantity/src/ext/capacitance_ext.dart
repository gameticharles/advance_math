import '../si/types/capacitance.dart';

/// The standard SI unit.
final CapacitanceUnits farads = Capacitance.farads;

/// Electromagnetic unit (emu), the capacity of a circuit component to store charge.
final CapacitanceUnits emuCapacitance = CapacitanceUnits('emu (capacitance)', null, null, null, 1.0e8, true);

/// The statfarad is the standard unit of capacitance in the cgs (centimeter/gram/second) system.
final CapacitanceUnits statfarads = CapacitanceUnits('statfarads', 'statF', null, null, 1.1127e-12, false);

// Convenience units.

/// A unit representing one gigafarad.
final CapacitanceUnits abfarads = farads.giga() as CapacitanceUnits;

/// A synonym for [statfarads].
final CapacitanceUnits esuCapacitance = statfarads;
