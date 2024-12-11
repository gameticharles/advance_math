import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';

/// The magnetic flux density passing through a closed surface.
/// See the [Wikipedia entry for Magnetic flux](https://en.wikipedia.org/wiki/Magnetic_flux)
/// for more information.
class MagneticFlux extends Quantity {
  /// Constructs a MagneticFlux with webers ([Wb]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  MagneticFlux({dynamic Wb, double uncert = 0.0})
      : super(Wb ?? 0.0, MagneticFlux.webers, uncert);

  /// Constructs a instance without preferred units.
  MagneticFlux.misc(dynamic conv)
      : super.misc(conv, MagneticFlux.magneticFluxDimensions);

  /// Constructs a MagneticFlux based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  MagneticFlux.inUnits(dynamic value, MagneticFluxUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? MagneticFlux.webers, uncert);

  /// Constructs a constant MagneticFlux.
  const MagneticFlux.constant(Number valueSI,
      {MagneticFluxUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, MagneticFlux.magneticFluxDimensions, units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions magneticFluxDimensions = Dimensions.constant(
      <String, int>{'Length': 2, 'Time': -2, 'Current': -1, 'Mass': 1},
      qType: MagneticFlux);

  /// The standard SI unit.
  static final MagneticFluxUnits webers =
      MagneticFluxUnits('webers', null, 'Wb', null, 1.0, true);
}

/// Units acceptable for use in describing MagneticFlux quantities.
class MagneticFluxUnits extends MagneticFlux with Units {
  /// Constructs a instance.
  MagneticFluxUnits(String name, String? abbrev1, String? abbrev2,
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
  Type get quantityType => MagneticFlux;

  /// Derive MagneticFluxUnits using this MagneticFluxUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      MagneticFluxUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
