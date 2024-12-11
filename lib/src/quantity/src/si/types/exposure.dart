import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'charge.dart';
import 'mass.dart';

/// The radiant energy received by a surface per unit area.
/// See the [Wikipedia entry for Radiant exposure](https://en.wikipedia.org/wiki/Radiant_exposure)
/// for more information.
class Exposure extends Quantity {
  /// Construct an Exposure with coulombs per kilogram or roentgens ([R]).
  /// Optionally specify a relative standard uncertainty.
  Exposure({dynamic coulombsPerKilogram, dynamic R, double uncert = 0.0})
      : super(
            coulombsPerKilogram ?? (R ?? 0.0),
            R != null ? Exposure.roentgens : Exposure.coulombsPerKilogram,
            uncert);

  /// Constructs a instance without preferred units.
  Exposure.misc(dynamic conv) : super.misc(conv, Exposure.exposureDimensions);

  /// Constructs a Exposure based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Exposure.inUnits(dynamic value, ExposureUnits? units, [double uncert = 0.0])
      : super(value, units ?? Exposure.coulombsPerKilogram, uncert);

  /// Constructs a constant Exposure.
  const Exposure.constant(Number valueSI,
      {ExposureUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Exposure.exposureDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions exposureDimensions = Dimensions.constant(
      <String, int>{'Current': 1, 'Mass': -1, 'Time': 1},
      qType: Exposure);

  /// The standard SI unit.
  static final ExposureUnits coulombsPerKilogram =
      ExposureUnits.chargeMass(Charge.coulombs, Mass.kilograms);

  /// Accepted for use with the SI, subject to further review.
  static final ExposureUnits roentgens =
      ExposureUnits('roentgens', null, 'R', null, 2.58e-4, false);
}

/// Units acceptable for use in describing Exposure quantities.
class ExposureUnits extends Exposure with Units {
  /// Constructs a instance.
  ExposureUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance based on charge and mass units.
  ExposureUnits.chargeMass(ChargeUnits ecu, MassUnits mu)
      : super.misc(ecu.valueSI * mu.valueSI) {
    name = '${ecu.name} per ${mu.singular}';
    singular = '${ecu.singular} per ${mu.singular}';
    convToMKS = ecu.valueSI * mu.valueSI;
    abbrev1 = ecu.abbrev1 != null && mu.abbrev1 != null
        ? '${ecu.abbrev1} / ${mu.abbrev1}'
        : null;
    abbrev2 = ecu.abbrev2 != null && mu.abbrev2 != null
        ? '${ecu.abbrev2}${mu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Exposure;

  /// Derive ExposureUnits using this ExposureUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      ExposureUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
