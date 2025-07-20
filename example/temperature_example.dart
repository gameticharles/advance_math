import 'package:advance_math/src/quantity/quantity_si.dart';

void main() {
  /// Construct a Temperature in degrees Celsius.
  final temp = Temperature(C: 100);
  print('Temperature1: $temp  (${temp.valueInUnits(Temperature.kelvins)} K)');

  /// Construct a second Temperature in degrees Kelvin.
  final temp2 = Temperature(K: 100);
  print(
      'Temperature2: $temp2  (${temp.valueInUnits(Temperature.degreesCelsius)} C)');

  /// Calculate the difference in temperatures.
  final diff = temp - temp2 as TemperatureInterval;
  print('Temperature difference: $diff'); // 273.15 K

  /// Add 5 times the difference to the first temperature.
  final hot = temp + (diff * 5) as Temperature;
  print(
      'Hot Temperature: $hot  (${hot.valueInUnits(Temperature.degreesCelsius)} C)');
}
