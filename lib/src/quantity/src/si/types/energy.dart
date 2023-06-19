import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'mass.dart';
import 'power.dart';
import 'time.dart';

// Also QuantityOfHeat, Work.

/// The ability of a system to perform work; cannot be created or destroyed but can take many forms.
/// See the [Wikipedia entry for Energy](https://en.wikipedia.org/wiki/Energy)
/// for more information.
class Energy extends Quantity {
  /// Constructs an Energy with joules ([J]) or electron volts ([eV]).
  /// Optionally specify a relative standard uncertainty.
  Energy({dynamic J, dynamic eV, double uncert = 0.0})
      : super(J ?? (eV ?? 0.0),
            eV != null ? Energy.electronVolts : Energy.joules, uncert);

  /// Constructs a instance without preferred units.
  Energy.misc(dynamic conv) : super.misc(conv, Energy.energyDimensions);

  /// Constructs a Energy based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Energy.inUnits(dynamic value, EnergyUnits? units, [double uncert = 0.0])
      : super(value, units ?? Energy.joules, uncert);

  /// Constructs a constant Energy.
  const Energy.constant(Number valueSI,
      {EnergyUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Energy.energyDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions energyDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Mass': 1, 'Time': -2},
      qType: Energy);

  /// The standard SI unit.
  static final EnergyUnits joules =
      EnergyUnits('joules', null, 'J', null, 1.0, true);

  /// Accepted for use with the SI.
  static final EnergyUnits electronVolts =
      EnergyUnits('electronvolts', null, 'eV', null, 1.60217653e-19, false);

  /// Returns the [Mass] equivalent of this Energy using the famous E=mc^2 relationship.
  Mass toMass() {
    if (valueSI is Precise) {
      final c = Precise('2.99792458e8');
      return Mass(kg: valueSI / (c * c), uncert: relativeUncertainty);
    } else {
      const c = 299792458;
      return Mass(kg: valueSI / (c * c), uncert: relativeUncertainty);
    }
  }
}

/// Units acceptable for use in describing Energy quantities.
class EnergyUnits extends Energy with Units {
  /// Constructs a instance.
  EnergyUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Constructs a instance based on power and time units.
  EnergyUnits.powerTime(PowerUnits pu, TimeUnits tu)
      : super.misc(pu.valueSI * tu.valueSI) {
    name = '${pu.singular} ${tu.name}';
    singular = '${pu.singular} ${tu.singular}';
    convToMKS = pu.valueSI * tu.valueSI;
    abbrev1 = pu.abbrev1 != null && tu.abbrev1 != null
        ? '${pu.abbrev1} ${tu.abbrev1}'
        : null;
    abbrev2 = pu.abbrev2 != null && tu.abbrev2 != null
        ? '${pu.abbrev2}${tu.abbrev2}'
        : null;
    metricBase = false;
    offset = 0.0;
  }

  /// Returns the Type of the Quantity to which these Units apply
  @override
  Type get quantityType => Energy;

  /// Derive EnergyUnits using this EnergyUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      EnergyUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
