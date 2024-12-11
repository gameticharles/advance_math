import '../../../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'pressure.dart';
import 'time.dart';

/// A measure of a fluid's resistance to gradual deformation by shear stress or
/// tensile stress.
/// See the [Wikipedia entry for Viscosity](https://en.wikipedia.org/wiki/Viscosity)
/// for more information.
class DynamicViscosity extends Quantity {
  /// Constructs a DynamicViscosity with pascal seconds ([Pas]).
  /// Optionally specify a relative standard uncertainty.
  // ignore: non_constant_identifier_names
  DynamicViscosity({dynamic Pas, double uncert = 0.0})
      : super(Pas ?? 0.0, DynamicViscosity.pascalSeconds, uncert);

  /// Constructs a instance without preferred units.
  DynamicViscosity.misc(dynamic conv)
      : super.misc(conv, DynamicViscosity.dynamicViscosityDimensions);

  /// Constructs a DynamicViscosity based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  DynamicViscosity.inUnits(dynamic value, DynamicViscosityUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? DynamicViscosity.pascalSeconds, uncert);

  /// Constructs a constant DynamicViscosity.
  const DynamicViscosity.constant(Number valueSI,
      {DynamicViscosityUnits? units, double uncert = 0.0})
      : super.constant(valueSI, DynamicViscosity.dynamicViscosityDimensions,
            units, uncert);

  /// Dimensions for this type of quantity.
  static const Dimensions dynamicViscosityDimensions = Dimensions.constant(
      <String, int>{'Mass': 1, 'Length': -1, 'Time': -1},
      qType: DynamicViscosity);

  /// The standard SI unit.
  static final DynamicViscosityUnits pascalSeconds =
      DynamicViscosityUnits.pressureTime(Pressure.pascals, Time.seconds);

  /// Another name for [pascalSeconds].
  static final DynamicViscosityUnits poiseuille = pascalSeconds;
}

/// Units acceptable for use in describing DynamicViscosity quantities.
class DynamicViscosityUnits extends DynamicViscosity with Units {
  /// Constructs a instance.
  DynamicViscosityUnits(String name, String? abbrev1, String? abbrev2,
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

  /// Constructs a instance based on pressure and time units.
  DynamicViscosityUnits.pressureTime(PressureUnits pu, TimeUnits tu)
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
  Type get quantityType => DynamicViscosity;

  /// Derive DynamicViscosityUnits using this DynamicViscosityUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      DynamicViscosityUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
