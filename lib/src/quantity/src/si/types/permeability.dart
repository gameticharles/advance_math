import '../../../quantity_ext.dart';
import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'current.dart';
import 'force.dart';
import 'inductance.dart';

/// The ability of a material to support the formation of a magnetic field within itself.
/// See the [Wikipedia entry for Permeability (electromagnetism)](https://en.wikipedia.org/wiki/Permeability_%28electromagnetism%29)
/// for more information.
class Permeability extends Quantity {
  /// Constructs a Permeability with henries per meter or newtons per ampere squared.
  /// Optionally specify a relative standard uncertainty.
  Permeability(
      {dynamic henriesPerMeter,
      dynamic newtonsPerAmpereSquared,
      double uncert = 0.0})
      : super(
            henriesPerMeter ?? (newtonsPerAmpereSquared ?? 0.0),
            newtonsPerAmpereSquared != null
                ? Permeability.newtonsPerAmpereSquared
                : Permeability.henriesPerMeter,
            uncert);

  /// Constructs a instance without preferred units.
  Permeability.misc(dynamic conv)
      : super.misc(conv, Permeability.permeabilityDimensions);

  /// Constructs a Permeability based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Permeability.inUnits(dynamic value, PermeabilityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Permeability.henriesPerMeter, uncert);

  /// Constructs a constant Permeability.
  const Permeability.constant(Number valueSI,
      {PermeabilityUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Permeability.permeabilityDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions permeabilityDimensions = Dimensions.constant(
      <String, int>{'Length': 1, 'Mass': 1, 'Time': -2, 'Current': -2},
      qType: Permeability);

  /// The standard SI unit.
  static final PermeabilityUnits henriesPerMeter =
      PermeabilityUnits.inductanceLength(
          Inductance.henries, LengthUnits.meters);

  /// The standard SI unit (alternate form).
  static final PermeabilityUnits newtonsPerAmpereSquared =
      PermeabilityUnits.forceCurrent(Force.newtons, Current.amperes);
}

/// Units acceptable for use in describing Permeability quantities.
class PermeabilityUnits extends Permeability with Units {
  /// Constructs a instance.
  PermeabilityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on inductance and length units.
  PermeabilityUnits.inductanceLength(InductanceUnits iu, LengthUnits lu)
      : super.misc(iu.valueSI / lu.valueSI) {
    name = '${iu.name} per ${lu.singular}';
    singular = '${iu.singular} per ${lu.singular}';
    convToMKS = iu.valueSI / lu.valueSI;
    abbrev1 = iu.abbrev1 != null && lu.abbrev1 != null
        ? '${iu.abbrev1} / ${lu.abbrev1}'
        : null;
    abbrev2 = iu.abbrev2 != null && lu.abbrev2 != null
        ? '${iu.abbrev2}/${lu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Constructs a instance based on force and electric current units.
  PermeabilityUnits.forceCurrent(ForceUnits fu, CurrentUnits ecu)
      : super.misc(fu.valueSI / (ecu.valueSI ^ 2)) {
    name = '${fu.name} per ${ecu.singular} squared';
    singular = '${fu.singular} per ${ecu.singular} squared';
    convToMKS = fu.valueSI / (ecu.valueSI ^ 2);
    abbrev1 = fu.abbrev1 != null && ecu.abbrev1 != null
        ? '${fu.abbrev1} / ${ecu.abbrev1}^2'
        : null;
    abbrev2 = fu.abbrev2 != null && ecu.abbrev2 != null
        ? '${fu.abbrev2}/${ecu.abbrev2}2'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Permeability;

  /// Derive PermeabilityUnits using this PermeabilityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      PermeabilityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
