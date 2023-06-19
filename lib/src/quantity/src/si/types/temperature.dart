import '../../number/util/converters.dart';
import '../../si/dimensions.dart';
import '../../si/quantity.dart';
import '../../si/units.dart';
import 'temperature_interval.dart';

/// An objective comparative measure of hot or cold.
/// See the [Wikipedia entry for Thermodynamic temperature](https://en.wikipedia.org/wiki/Thermodynamic_temperature)
/// for more information.
class Temperature extends Quantity {
  /// Constructs a Temperature with kelvins ([K]) or degrees Celsius ([C]).
  /// Optionally specify a relative standard uncertainty.
  Temperature({dynamic K, dynamic C, double uncert = 0.0})
      : super(
            K ?? (C ?? 0.0),
            C != null ? Temperature.degreesCelsius : Temperature.kelvins,
            uncert);

  /// Constructs a instance without preferred units.
  Temperature.misc(dynamic conv)
      : super.misc(conv, Temperature.temperatureDimensions);

  /// Constructs a Temperature based on the [value]
  /// and the conversion factor intrinsic to the passed [units].
  Temperature.inUnits(dynamic value, TemperatureUnits? units,
      [double uncert = 0.0])
      : super(value, units ?? Temperature.kelvins, uncert);

  /// Constructs a constant Temperature.
  const Temperature.constant(Number valueSI,
      {TemperatureUnits? units, double uncert = 0.0})
      : super.constant(
            valueSI, Temperature.temperatureDimensions, units, uncert);

  /// Dimensions for this type of quantity
  static const Dimensions temperatureDimensions =
      Dimensions.constant(<String, int>{'Temperature': 1}, qType: Temperature);

  // Units

  /// The standard SI unit.
  static final TemperatureUnits kelvins =
      TemperatureUnits('kelvins', 'K', null, null, Double.one, true, 0);

  /// Derived SI unit.
  static final TemperatureUnits degreesCelsius = TemperatureUnits(
      'degrees Celsius',
      'deg C',
      null,
      'degree Celsius',
      Double.one,
      false,
      273.15);

  /// Override the addition operator to manage the `Temperature`/[TemperatureInterval] relationship.
  ///
  @override
  Quantity operator +(dynamic addend) {
    if (addend is TemperatureInterval || addend is Temperature) {
      final newValueSI = valueSI + addend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, addend as Quantity, newValueSI);
      return Temperature(K: newValueSI, uncert: ur);
    } else {
      return super + addend;
    }
  }

  /// Override the subtraction operator to manage the `Temperature`/[TemperatureInterval] relationship.
  ///
  /// * Subtracting a `Temperature` returns a [TemperatureInterval] object.
  /// * Subtracting a `TemperatureInterval` returns a [Temperature] object.
  ///
  @override
  Quantity operator -(dynamic subtrahend) {
    if (subtrahend is TemperatureInterval) {
      final newValueSI = valueSI - subtrahend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, subtrahend, newValueSI);
      return Temperature(K: newValueSI, uncert: ur);
    } else if (subtrahend is Temperature) {
      final newValueSI = valueSI - subtrahend.valueSI;
      final ur = Quantity.calcRelativeCombinedUncertaintySumDiff(
          this, subtrahend, newValueSI);
      return TemperatureInterval(K: newValueSI, uncert: ur);
    } else {
      return super - subtrahend;
    }
  }

  /// Returns the [TemperatureInterval] equal to this temperature in kelvins.
  ///
  TemperatureInterval toInterval() =>
      TemperatureInterval(K: valueSI, uncert: relativeUncertainty);
}

/// Units acceptable for use in describing [Temperature] quantities.
class TemperatureUnits extends Temperature with Units {
  /// Constructs a instance.
  TemperatureUnits(String name, String? abbrev1, String? abbrev2,
      String? singular, dynamic conv,
      [bool metricBase = false, double offset = 0.0])
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
  Type get quantityType => Temperature;

  /// Derive TemperatureUnits using this TemperatureUnits object as the base.
  @override
  Units derive(String fullPrefix, String abbrevPrefix, double conv) =>
      TemperatureUnits(
          '$fullPrefix$name',
          abbrev1 != null ? '$abbrevPrefix$abbrev1' : null,
          abbrev2 != null ? '$abbrevPrefix$abbrev2' : null,
          '$fullPrefix$singular',
          valueSI * conv,
          false,
          offset);
}
