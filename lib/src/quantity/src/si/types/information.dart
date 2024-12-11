// ignore_for_file: non_constant_identifier_names

import 'dart:math' as math;
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// Amount of data.
/// See the [Wikipedia entry for Information](https://en.wikipedia.org/wiki/Information)
/// for more information.
class Information extends Quantity {
  /// Constructs an Information object with [bits], bytes ([B]), kibibytes ([KiB]), mebibytes ([MiB]),
  /// gibibytes ([GiB]), or tebibytes ([TiB]).
  /// Optionally specify a relative standard uncertainty.
  Information(
      {dynamic bits,
      dynamic B,
      dynamic KiB,
      dynamic MiB,
      dynamic GiB,
      dynamic TiB,
      double uncert = 0.0})
      : super(
            bits ?? (B ?? (KiB ?? (MiB ?? (GiB ?? (TiB ?? 0.0))))),
            B != null
                ? Information.bytes
                : (KiB != null
                    ? Information.kibibytes
                    : (MiB != null
                        ? Information.mebibytes
                        : (GiB != null
                            ? Information.gibibytes
                            : (TiB != null
                                ? Information.tebibytes
                                : Information.bits)))),
            uncert);

  /// Constructs a instance without preferred units.
  Information.misc(dynamic conv)
      : super.misc(conv, Information.informationDimensions);

  /// Constructs an Information instance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Information.inUnits(dynamic value, InformationUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Information.bits, uncert);

  /// Constructs a constant Information.
  const Information.constant(Number valueSI,
      {InformationUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Information.informationDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions informationDimensions =
      Dimensions.constant(<String, int>{}, qType: Information);

  // Units

  /// The standard unit of data (ISO, IEC).
  static final InformationUnits bits =
      InformationUnits('bits', null, 'bit', null, 1.0, true);

  /// Equal to 4 bits.
  static final InformationUnits nibbles =
      InformationUnits('nibbles', null, null, null, 4.0, false);

  /// Equal to 8 bits.
  static final InformationUnits bytes =
      InformationUnits('bytes', null, 'B', null, 8.0, false);

  // Convenience.

  /// 1 000 bits (not 1024 bits)
  static final InformationUnits kilobits = bits.kilo() as InformationUnits;

  /// 1 000 000 bits (not 1 048 576 bits)
  static final InformationUnits megabits = bits.mega() as InformationUnits;

  /// 1 billion bits
  static final InformationUnits gigabits = bits.giga() as InformationUnits;

  /// 1 trillion bits
  static final InformationUnits terabits = bits.tera() as InformationUnits;

  // Binary Units.

  /// 1 kibibyte is equal to 2^10 bytes (1 024 bytes).
  /// Use `bytes.kilo()` to get the metric value (1 000 bytes).  Use `kibibytes` for
  /// common binary usage (e.g., for data storage units).
  static final InformationUnits kibibytes =
      InformationUnits('kibibytes', null, 'KiB', null, 8.0 * 1024.0, false);

  /// 1 mebibyte is equal to 2^20 bytes (1 048 576 bytes).
  /// Use `bytes.mega()` to get the metric value (1 000 000 bytes).  Use `mebibytes` for
  /// common binary usage (e.g., for data storage units).
  static final InformationUnits mebibytes =
      InformationUnits('mebibytes', null, 'MiB', null, 8.0 * 1.048576e6, false);

  /// 1 gibibyte is equal to 2^30 bytes (1 073 741 824 bytes).
  /// Use `bytes.giga()` to get the metric value (10^9 bytes).  Use `gibibytes` for
  /// common binary usage (e.g., for data storage units).
  static final InformationUnits gibibytes = InformationUnits(
      'gibibytes', null, 'GiB', null, 8.0 * 1.073741824e9, false);

  /// 1 tebibyte is equal to 2^40 bytes (1 099 511 627 776 bytes).
  /// Use `bytes.tera()` to get the metric value (10^12 bytes).
  /// Use `tebibytes` for common binary usage (e.g., for data storage units).
  static final InformationUnits tebibytes = InformationUnits(
      'tebibytes', null, 'TiB', null, 8.0 * 1.099511627776e12, false);

  /// 1 pebibyte is equal to 2^50 bytes (1 125 899 906 842 624 bytes).
  /// Use `bytes.peta()` to get the metric value (10^15 bytes).
  /// Use `pebibytes` for common binary usage (e.g., for data storage units).
  static final InformationUnits pebibytes = InformationUnits(
      'pebibytes', null, 'PiB', null, 8.0 * 1.125899906842624e15, false);

  /// 1 exbibyte is equal to 2^60 bytes (1 152 921 504 606 846 976 bytes).
  /// Use `bytes.exa()` to get the metric value (10^18 bytes).
  /// Use `exbibytes` for common binary usage (e.g., for data storage units).
  static final InformationUnits exbibytes = InformationUnits(
      'exbibytes', null, 'EiB', null, 8.0 * 1.152921504606846976e18, false);

  /// 1 zebibyte is equal to 2^70 bytes.
  /// Use `bytes.zetta()` to get the metric value (10^21 bytes).
  static final InformationUnits zebibytes = InformationUnits(
      'zebibytes', null, 'ZiB', null, 8.0 * math.pow(2, 70), false);

  /// 1 yobibyte is equal to 2^80 bytes.
  /// Use `bytes.yotta()` to get the metric value (10^24 bytes).
  static final InformationUnits yobibytes = InformationUnits(
      'yobibytes', null, 'YiB', null, 8.0 * math.pow(2, 80), false);
}

/// Units acceptable for use in describing Information quantities.
class InformationUnits extends Information with Units {
  /// Constructs a instance.
  InformationUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Information;

  /// Derive InformationUnits using this InformationUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      InformationUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
