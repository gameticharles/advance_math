import '../si/types/information.dart';

/// The standard SI unit.
final InformationUnits bits = Information.bits;

/// Units of 8 bits.
final InformationUnits bytes = Information.bytes;

/// 1000 bytes (8000 bits).
/// Use [Information.kibibytes] (kiB) instead for the binary interpretation of kB (1024 bytes).
final InformationUnits kilobytes = Information.bytes.kilo() as InformationUnits;

/// 10^6 bytes.
/// Use [Information.mebibytes] (MiB) instead for the binary interpretation of MB (2^20 bytes).
final InformationUnits megabytes = Information.bytes.mega() as InformationUnits;

/// 10^9 bytes.
/// Use [Information.gibibytes] (GiB) instead for the binary interpretation of GB (2^30 bytes).
final InformationUnits gigabytes = Information.bytes.giga() as InformationUnits;

/// 10^12 bytes.
/// Use [Information.tebibytes] (TiB) instead for the binary interpretation of TB (2^40 bytes).
final InformationUnits terabytes = Information.bytes.tera() as InformationUnits;

/// 10^15 bytes.
/// Use [Information.pebibytes] (PiB) instead for the binary interpretation of PB (2^50 bytes).
final InformationUnits petabytes = Information.bytes.peta() as InformationUnits;

/// 10^18 bytes.
/// Use [Information.exbibytes] (EiB) instead for the binary interpretation of EB (2^60 bytes).
final InformationUnits exabytes = Information.bytes.exa() as InformationUnits;
