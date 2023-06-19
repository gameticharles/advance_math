import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The property of an electrical conductor by which a change in current flowing through
/// it induces an electromotive force in both the conductor itself and in any nearby
/// conductors by mutual inductance.
/// See the [Wikipedia entry for Inductance](https://en.wikipedia.org/wiki/Inductance)
/// for more information.
class Inductance extends Quantity {
  /// Constructs an Inductance with henries ([H]).
  /// Optionally specify a relative standard uncertainty.
  Inductance({dynamic H, double uncert = 0.0})
      : super(H ?? 0.0, Inductance.henries, uncert);

  /// Constructs a instance without preferred units.
  Inductance.misc(dynamic conv)
      : super.misc(conv, Inductance.inductanceDimensions);

  /// Constructs a Inductance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Inductance.inUnits(dynamic value, InductanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Inductance.henries, uncert);

  /// Constructs a constant Inductance.
  const Inductance.constant(Number valueSI,
      {InductanceUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Inductance.inductanceDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions inductanceDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Current': -2, 'Time': -2},
      qType: Inductance);

  /// The standard SI unit.
  static final InductanceUnits henries =
      InductanceUnits('henries', null, 'H', 'henry', 1.0, true);
}

/// Units acceptable for use in describing Inductance quantities.
class InductanceUnits extends Inductance with Units {
  /// Constructs a instance.
  InductanceUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Inductance;

  /// Derive InductanceUnits using this InductanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      InductanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
