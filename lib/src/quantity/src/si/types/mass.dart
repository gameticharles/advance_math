import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'energy.dart';

/// Represents the *mass* physical quantity (one of the seven base SI quantities),
/// that determines the strength of a body's mutual gravitational attraction to other bodies.
/// See the [Wikipedia entry for Mass](https://en.wikipedia.org/wiki/Mass)
/// for more information.
class Mass extends Quantity {
  /// Constructs a Mass with kilograms ([kg]), grams ([g]) or unified atomic mass units ([u]).
  /// Optionally specify a relative standard uncertainty.
  Mass({dynamic kg, dynamic g, dynamic u, double uncert = 0.0})
      : super(
            kg ?? (g ?? (u ?? 0.0)),
            g != null
                ? Mass.grams
                : (u != null ? Mass.unifiedAtomicMassUnits : Mass.kilograms),
            uncert);

  /// Constructs a instance without preferred units.
  Mass.misc(dynamic conv) : super.misc(conv, Mass.massDimensions);

  /// Constructs a Mass based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Mass.inUnits(dynamic value, MassUnits? units, [double uncert = 0.0])
      : super(value, units ?? Mass.kilograms, uncert);

  /// Constructs a constant Mass.
  const Mass.constant(Number valueSI, {MassUnits? units, double uncert = 0.0})
      : super.constant(valueSI, Mass.massDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions massDimensions =
      Dimensions.constant(<String, int>{'Mass': 1}, qType: Mass);

  /// The standard SI unit.
  static final MassUnits kilograms =
      MassUnits('kilograms', 'kg', null, null, 1.0, false);

  /// Note: kilograms are the standard MKS unit for mass, but grams is used here
  /// to generate the appropriate prefixes.  Gram conversion value is set to 0.001
  /// in order to generate the correct units.
  static final MassUnits grams =
      MassUnits('grams', 'g', null, null, 0.001, true);

  /// Accepted for use with the SI.
  static final MassUnits metricTons = grams.mega() as MassUnits;

  /// Accepted for use with the SI.
  static final MassUnits tonnes = metricTons;

  /// Accepted for use with the SI.
  static final MassUnits unifiedAtomicMassUnits = MassUnits(
      'unified atomic mass units', null, 'u', null, 1.66053886e-27, false);

  /// Returns the [Energy] equivalent of this Mass using the famous E=mc^2 relationship.
  Energy toEnergy() {
    if (valueSI is Precision) {
      final c = Precision('2.99792458e8');
      return Energy(J: valueSI * c * c, uncert: relativeUncertainty);
    } else {
      // ignore: prefer_int_literals
      const c = 2.99792458e8;
      return Energy(J: valueSI * c * c, uncert: relativeUncertainty);
    }
  }
}

/// Units acceptable for use in describing [Mass] quantities.
class MassUnits extends Mass with Units {
  /// Constructs a instance.
  MassUnits(String name, String? abbrev1, String? abbrev2, String? singular,
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

  /// Returns the Type of the Quantity to which these Units apply.
  @override
  Type get quantityType => Mass;

  /// Derive MassUnits using this MassUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MassUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
