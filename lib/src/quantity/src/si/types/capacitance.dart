import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The ability of a body to store an electrical charge,
/// See the [Wikipedia entry for Capacitance](https://en.wikipedia.org/wiki/Capacitance)
/// for more information.
class Capacitance extends Quantity {
  /// Constructs a Capacitance with farads ([F]).
  /// Optionally specify a relative standard uncertainty.
  Capacitance({dynamic F, double uncert = 0.0})
      : super(F ?? 0.0, Capacitance.farads, uncert);

  /// Constructs a instance without preferred units.
  Capacitance.misc(dynamic conv)
      : super.misc(conv, Capacitance.electricCapacitanceDimensions);

  /// Constructs a Capacitance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Capacitance.inUnits(dynamic value, CapacitanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Capacitance.farads, uncert);

  /// Constructs a constant Capacitance.
  const Capacitance.constant(Number valueSI,
      {CapacitanceUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Capacitance.electricCapacitanceDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricCapacitanceDimensions = Dimensions.constant(
      <String, int>{'Time': 4, 'Current': 2, 'Length': -2, 'Mass': -1},
      qType: Capacitance);

  /// The standard SI unit.
  static final CapacitanceUnits farads =
      CapacitanceUnits('farads', null, 'F', null, 1.0, true);
}

/// Units acceptable for use in describing Capacitance quantities.
class CapacitanceUnits extends Capacitance with Units {
  /// Constructs a instance.
  CapacitanceUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => Capacitance;

  /// Derive CapacitanceUnits using this CapacitanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      CapacitanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
