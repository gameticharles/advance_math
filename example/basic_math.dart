import 'package:advance_math/advance_math.dart';

void main() {
  //decimalPrecision = 200;
  print(Decimal('12'));
  print(Decimal('0.1234'));
  print(Decimal('-12.345'));
  print(Decimal('1.23456789e-6', sigDigits: 4));
  print(Decimal(-12));
  print(Decimal(12.123456789));

  printLine();

  print(Rational.parse("-2 3/4")); // -11/4
  print(Rational.parse("-3/4")); // -3/4
  print(Rational.parse("3/4")); // 3/4
  print(Rational.parse("-0.75")); // -3/4
  print(Rational.parse("0.75")); // 3/4
  print(Rational.parse("-3.14e2")); // -314
  print(Rational.parse("3.14e-2")); // 157/5000

  printLine('Compute PI Algorithm');

  print(PI(precision: 100));

  final algorithms = {
    'BBP': (int digits) => BBP(digits),
    'Madhava': (int digits) => Madhava(digits),
    'Chudnovsky': (int digits) => Chudnovsky(digits),
    'GaussLegendre': (int digits) => GaussLegendre(digits),
    'Ramanujan': (int digits) => Ramanujan(digits),
    'Newton-Euler': (int digits) => NewtonEuler(digits),
  };

  int digits = 100; // Example number of digits to compute

  for (var entry in algorithms.entries) {
    // Call factory function with digits
    var algorithm = entry.value(digits);

    Decimal pi = algorithm.calculate();
    print('${entry.key}: π = $pi');
    print('Time per digit: ${algorithm.getTimePerDigit()} ms');
    print('---');
  }

  printLine();

  int precision = 100; // Desired precision (number of decimal places)
  Decimal.setPrecision(precision);
  PI pi = PI(precision: precision);

  print("π to 100 decimal places: ${pi.toString()}");
  print("10th decimal digit of π: ${pi.getNthDigit(10)}");
  print("π contains '4338327950288': ${pi.containsPattern('4338327950288')}");
  print(
      "Indices of '4338327950288' in π: ${pi.findPatternIndices('4338327950288')}");
  print("Digits 10 to 15: ${pi.getDigits(10, 15)}");
  print("Confirm Decimal: ${pi.toString().length}");

  printLine();

  Map<String, int> digitFrequency = pi.countDigitFrequency();
  print('Digit frequency in the first $precision digits of π:');
  digitFrequency.forEach((digit, count) {
    print('$digit: $count');
  });

  printLine();

  var r = Decimal(5);
  // Using the compute method
  var circumference = pi.compute((p) => Decimal(2) * r * p);
  print("Circumference using compute method: $circumference");

  var area = pi.compute((p) => p * r * r);
  print("Area using compute method: $area");

  printLine();

  Decimal base = Decimal('2.1');
  var exponent = 2; // Example exponent
  Decimal powerResult = base.pow(exponent);
  print('Result of $base^$exponent: $powerResult');

  Decimal number = Decimal('2'); // Example number
  Decimal sqrtResult = number.pow(1 / 3);
  print('Square root of $number with precision $precision: $sqrtResult');
}