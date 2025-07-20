import '../si/types/spectral_irradiance.dart';

/// A non-SI unit of spectral irradiance used especially in radio astronomy.
final SpectralIrradianceUnits janskys =
    SpectralIrradianceUnits('janskys', 'f.u.', 'Jy', null, 1.0e-26, true);

/// Synonymous with [janskys].
final SpectralIrradianceUnits fluxUnits = janskys;
