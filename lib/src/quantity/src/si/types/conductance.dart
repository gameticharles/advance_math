import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The ease with which an electric current passes through a conductor (the inverse of `Resistance`).
/// See the [Wikipedia entry for Electrical resistance and conductance](https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance)
/// for more information.
class Conductance extends Quantity {
  /// Constructs a Conductance with siemens ([S]).
  /// Optionally specify a relative standard uncertainty.
  Conductance({dynamic S, double uncert = 0.0})
      : super(S ?? 0.0, Conductance.siemens, uncert);

  /// Constructs a instance without preferred units.
  Conductance.misc(dynamic conv)
      : super.misc(conv, Conductance.electricConductanceDimensions);

  /// Constructs a Conductance based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Conductance.inUnits(dynamic value, ConductanceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Conductance.siemens, uncert);

  /// Constructs a constant Conductance.
  const Conductance.constant(Number valueSI,
      {ConductanceUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Conductance.electricConductanceDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions electricConductanceDimensions = Dimensions.constant(
      <String, int>{'Current': 2, 'Time': 3, 'Length': -2, 'Mass': -1},
      qType: Conductance);

  /// The standard SI unit.
  /// Note: singular still has an 's'
  static final ConductanceUnits siemens =
      ConductanceUnits('siemens', null, 'S', 'siemens', 1.0, true);
}

/// Units acceptable for use in describing Conductance quantities.
class ConductanceUnits extends Conductance with Units {
  /// Constructs a instance.
  ConductanceUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => Conductance;

  /// Derive ConductanceUnits using this ConductanceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ConductanceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
