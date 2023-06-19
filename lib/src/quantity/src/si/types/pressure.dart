import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'area.dart';
import 'force.dart';

// Also Stress

/// Force applied perpendicular to the surface of an object per unit area
/// over which that force is distributed.
/// See the [Wikipedia entry for Pressure](https://en.wikipedia.org/wiki/Pressure)
/// for more information.
class Pressure extends Quantity {
  /// Constructs a pressure with pascals ([Pa]) or [bars].
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  Pressure({dynamic Pa, dynamic bars, double uncert = 0.0})
      : super(Pa ?? (bars ?? 0.0),
            bars != null ? Pressure.bars : Pressure.pascals, uncert);

  /// Constructs a instance without preferred units.
  Pressure.misc(dynamic conv) : super.misc(conv, Pressure.pressureDimensions);

  /// Constructs a Pressure based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Pressure.inUnits(dynamic value, PressureUnits? units, [double uncert = 0.0])
      : super(value, units ?? Pressure.pascals, uncert);

  /// Constructs a constant Pressure.
  const Pressure.constant(Number valueSI,
      {PressureUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Pressure.pressureDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions pressureDimensions = Dimensions.constant(
      <String, int>{'Length': -1, 'Mass': 1, 'Time': -2},
      qType: Pressure);

  /// The standard SI unit.
  static final PressureUnits pascals =
      PressureUnits('pascals', null, 'Pa', null, 1.0, true);

  /// Accepted for use with the SI, subject to further review.
  static final PressureUnits bars =
      PressureUnits('bars', null, null, null, 1.0e5, true);
}

/// Units acceptable for use in describing Pressure quantities.
class PressureUnits extends Pressure with Units {
  /// Constructs a instance.
  PressureUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance from force and area units.
  PressureUnits.forceArea(ForceUnits fu, AreaUnits au)
      : super.misc(fu.valueSI * au.valueSI) {
    name = '${fu.name} per ${au.singular}';
    singular = '${fu.singular} per ${au.singular}';
    convToMKS = fu.valueSI * au.valueSI;
    abbrev1 = fu.abbrev1 != null && au.abbrev1 != null
        ? '${fu.abbrev1} / ${au.abbrev1}'
        : null;
    abbrev2 = fu.abbrev2 != null && au.abbrev2 != null
        ? '${fu.abbrev2}${au.abbrev2}'
        : null;
    metricBase = metricBase;
    offset = offset.toDouble();
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Pressure;

  /// Derive PressureUnits using this PressureUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      PressureUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
