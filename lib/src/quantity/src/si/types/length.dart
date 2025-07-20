// ignore_for_file: non_constant_identifier_names

import '../../ext/length_ext.dart';
import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';

/// Represents the _length_ physical quantity (one of the seven base SI quantities).
/// See the [Wikipedia entry for Length](https://en.wikipedia.org/wiki/Length)
/// for more information.
class Length extends Quantity {
  /// Constructs a Length with meters ([m]), kilometers ([km]), millimeters ([mm]), astronomical units ([ua])
  /// or nautical miles ([NM]).
  /// Optionally specify a relative standard uncertainty.

  Length(
      {dynamic m,
      dynamic km,
      dynamic mm,
      dynamic ua,
      dynamic NM,
      double uncert = 0.0})
      : super(
            m ?? (km ?? (mm ?? (ua ?? (NM ?? 0.0)))),
            km != null
                ? LengthUnits.kilometers
                : (mm != null
                    ? LengthUnits.millimeters
                    : (ua != null
                        ? LengthUnits.astronomicalUnits
                        : (NM != null
                            ? LengthUnits.nauticalMiles
                            : LengthUnits.meters))),
            uncert);

  /// Constructs a instance without preferred units.
  Length.misc(dynamic conv) : super.misc(conv, Length.lengthDimensions);

  /// Constructs a Length based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Length.inUnits(dynamic value, LengthUnits? units, [double uncert = 0.0])
      : super(value, units ?? LengthUnits.meters, uncert);

  /// Constructs constant Length.
  const Length.constant(Number valueSI,
      {LengthUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Length.lengthDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions lengthDimensions =
      Dimensions.constant(<String, int>{'Length': 1}, qType: Length);

  /// Rounds the [value] to the nearest number with [decimalPlaces] decimal digits.
  ///
  /// This method shifts the decimal point [decimalPlaces] places to the right,
  /// rounds to the nearest integer, and then shifts the decimal point back to the
  /// left by the same amount. The default value of [decimalPlaces] is `0`.
  ///
  /// Returns the rounded [value].
  Length round([int decimalPlaces = 0]) {
    return Length(m: mks.roundTo(decimalPlaces));
  }
}
