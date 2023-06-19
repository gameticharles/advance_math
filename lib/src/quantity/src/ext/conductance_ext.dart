import '../number/double.dart';
import '../si/types/conductance.dart';

/// A non-SI unit of electrical conductance.
final ConductanceUnits statmhos = ConductanceUnits('statmhos', null, null, null, 1.1127e-12, false);

// Convenience units.

/// Synonymous with Siemens.
final ConductanceUnits mho = Conductance.siemens;

/// Equivalent to a billion siemens (or mhos).
final ConductanceUnits abmho = Conductance.siemens.giga() as ConductanceUnits;

// Constants.

/// The quantized unit of electrical conductance.
/// It appears when measuring the conductance of a quantum point contact, and, more generally,
/// is a key component of Landauer formula which relates the electrical conductance of a quantum
/// conductor to its quantum properties.
const Conductance conductanceQuantum = Conductance.constant(Double.constant(7.7480917299999999e-5));
