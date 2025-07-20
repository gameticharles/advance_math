import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

// Also, ElectromotiveForce, EMF, Potential.

/// The difference in electric potential energy between two points per unit electric charge
/// See the [Wikipedia entry for Voltage](https://en.wikipedia.org/wiki/Voltage)
/// for more information.
class ElectricPotentialDifference extends Quantity {
  /// Constructs an ElectricPotentialDifference with volts ([V]).
  /// Optionally specify a relative standard uncertainty.
  ElectricPotentialDifference({dynamic V, double uncert = 0.0})
      : super(V ?? 0.0, ElectricPotentialDifference.volts, uncert);

  /// Constructs a instance without preferred units.
  ElectricPotentialDifference.misc(dynamic conv)
      : super.misc(conv,
            ElectricPotentialDifference.electricPotentialDifferenceDimensions);

  /// Constructs a ElectricPotentialDifference based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  ElectricPotentialDifference.inUnits(
      dynamic value, ElectricPotentialDifferenceUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? ElectricPotentialDifference.volts, uncert);

  /// Constructs a constant ElectricPotentialDifference.
  const ElectricPotentialDifference.constant(Number valueSI,
      {ElectricPotentialDifferenceUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI,
            ElectricPotentialDifference.electricPotentialDifferenceDimensions,
            units,
            uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions electricPotentialDifferenceDimensions =
      Dimensions.constant(
          <String, int>{'Current': -1, 'Time': -3, 'Length': 2, 'Mass': 1},
          qType: ElectricPotentialDifference);

  /// The standard SI unit.
  static final ElectricPotentialDifferenceUnits volts =
      ElectricPotentialDifferenceUnits('volts', null, 'V', null, 1.0, true);
}

/// Units acceptable for use in describing ElectricPotentialDifference quantities.
class ElectricPotentialDifferenceUnits extends ElectricPotentialDifference
    with Units {
  /// Constructs a instance.
  ElectricPotentialDifferenceUnits(String name, String? abbrev1,
      String? abbrev2, String? singular, dynamic conv,
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
  Type get quantityType => ElectricPotentialDifference;

  /// Derive ElectricPotentialDifferenceUnits using this ElectricPotentialDifferenceUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ElectricPotentialDifferenceUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
