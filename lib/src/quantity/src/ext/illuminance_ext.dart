import '../si/types/illuminance.dart';

/// The standard SI unit.
IlluminanceUnits lux = Illuminance.lux;

/// Foot candles as a unit.
IlluminanceUnits footCandles =
    IlluminanceUnits('foot candles', null, null, null, 1.0764e1, false);

/// Phots as a unit.
IlluminanceUnits phots =
    IlluminanceUnits('phots', null, null, null, 1.0e4, true);
