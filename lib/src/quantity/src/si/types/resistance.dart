import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// A measure of the difficulty passing an electric current through a conductor.
/// See the [Wikipedia entry for Electrical resistance and conductance](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance)
/// for more information.
class Resistance extends Quantity {
  /// Constructs a Resistance with [ohms].
  /// Optionally specify a relative standard uncertainty.
  Resistance({dynamic ohms, double uncert = 0.0})
      : super(ohms ?? 0.0, Resistance.ohms, uncert);

  /// Constructs a instance without preferred units.
  Resistance.misc(dynamic conv)
      : super.misc(conv, Resistance.electricResistanceDimensions);

  /// Constructs a Resistance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Resistance.inUnits(dynamic value, ResistanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Resistance.ohms, uncert);

  /// Constructs a constant electrical Resistance.
  const Resistance.constant(Number valueSI,
      {ResistanceUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Resistance.electricResistanceDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricResistanceDimensions = Dimensions.constant(
      <String, int>{'Current': -2, 'Time': -3, 'Length': 2, 'Mass': 1},
      qType: Resistance);

  /// The standard SI unit.
  static final ResistanceUnits ohms =
      ResistanceUnits('ohms', '\u2126', '\u03a9', null, 1.0, true);
}

/// Units acceptable for use in describing Resistance quantities.
class ResistanceUnits extends Resistance with Units {
  /// Constructs a instance.
  ResistanceUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => Resistance;

  /// Derive ResistanceUnits using this ResistanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ResistanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
