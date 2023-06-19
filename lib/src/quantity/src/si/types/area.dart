import 'dart:math' as math;

import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'length.dart';

/// The extent of a two-dimensional figure or shape.
/// See the [Wikipedia entry for Area](https://en.wikipedia.org/wiki/Area)
/// for more information.
class Area extends Quantity {
  /// Construct an Area with either square meters ([m2]), hectares ([ha])
  /// or barns ([b]).
  /// Optionally specify a relative standard uncertainty.
  Area({dynamic m2, dynamic ha, dynamic b, double uncert = 0.0})
      : super(
            m2 ?? (ha ?? (b ?? 0.0)),
            ha != null
                ? Area.hectares
                : (b != null ? Area.barns : Area.squareMeters),
            uncert);

  /// Constructs a instance without preferred units.
  Area.misc(dynamic conv) : super.misc(conv, Area.areaDimensions);

  /// Constructs a Area based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Area.inUnits(dynamic value, AreaUnits? units, [double uncert = 0.0])
      : super(value, units ?? Area.squareMeters, uncert);

  /// Constructs a constant Area.
  const Area.constant(Number valueSI, {AreaUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Area.areaDimensions, units, uncert);

  /// Constructs a Area by multiplying two lengths together.
  Area.fromLengths(Length l1, Length l2)
      : super(
            l1.valueSI * l2.valueSI,
            Area.squareMeters,
            math.sqrt(l1.relativeUncertainty * l1.relativeUncertainty +
                l2.relativeUncertainty * l2.relativeUncertainty));

  /// Dimensions for this type of quantity.
  static const Dimensions areaDimensions =
      Dimensions.constant(<String, int>{'Length': 2}, qType: Area);

  /// The standard SI unit.
  static final AreaUnits squareMeters =
      AreaUnits.lengthSquared(LengthUnits.meters);

  /// Accepted for use with the SI,
  /// equals 1 square hectometer, or 10 000 square meters.
  static final AreaUnits hectares =
      AreaUnits('hectares', 'ha', null, null, 1.0e4, true);

  /// Accepted for use with the SI, subject to further review...
  /// equals one square decameter, or 100 square meters.
  static final AreaUnits ares = AreaUnits('ares', 'a', null, null, 1.0e2, true);

  /// Accepted for use with the SI, subject to further review...
  /// equals 100 square femtometers, or 1.0e-28 square meters
  static final AreaUnits barns =
      AreaUnits('barns', 'b', null, null, 1.0e-28, true);
}

/// Units acceptable for use in describing Area quantities.
class AreaUnits extends Area with Units {
  /// Constructs a instance.
  AreaUnits(String name, String? abbrev1, String? abbrev2, String? singular,
      dynamic conv,
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

  /// Constructs a instance based on length units.
  AreaUnits.lengthSquared(LengthUnits lu)
      : super.misc(lu.valueSI * lu.valueSI) {
    name = 'square ${lu.name}';
    singular = 'square ${lu.singular}';
    convToMKS = lu.valueSI * lu.valueSI;
    abbrev1 =
        lu.abbrev1 != null && lu.abbrev1 != null ? '${lu.abbrev1}2' : null;
    abbrev2 =
        lu.abbrev2 != null && lu.abbrev2 != null ? '${lu.abbrev2}2' : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Area;

  /// Derive AreaUnits using this AreaUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      AreaUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
