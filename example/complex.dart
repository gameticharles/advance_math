import 'package:advance_math/advance_math.dart';

void main() {
  const inf = double.infinity;
  const neginf = double.negativeInfinity;
  const nan = double.nan;

  // Create various complex numbers with special values
  var oneInf = Complex(1, inf);
  var oneNegInf = Complex(1, neginf);
  var infOne = Complex(inf, 1);
  var infZero = Complex(inf, 0);
  var infNaN = Complex(inf, nan);
  var infNegInf = Complex(inf, neginf);
  var infInf = Complex(inf, inf);
  var negInfInf = Complex(neginf, inf);
  var negInfZero = Complex(neginf, 0);
  var negInfOne = Complex(neginf, 1);
  var negInfNaN = Complex(neginf, nan);
  var negInfNegInf = Complex(neginf, neginf);
  var oneNaN = Complex(1, nan);
  var zeroInf = Complex(0, inf);
  var zeroNaN = Complex(0, nan);
  var nanInf = Complex(nan, inf);
  var nanNegInf = Complex(nan, neginf);
  var nanZero = Complex(nan, 0);

  // Test special value representations
  print('oneInf: $oneInf');
  print('oneNegInf: $oneNegInf');
  print('infOne: $infOne');
  print('infZero: $infZero');
  print('infNaN: $infNaN');
  print('infNegInf: $infNegInf');
  print('infInf: $infInf');
  print('negInfInf: $negInfInf');
  print('negInfZero: $negInfZero');
  print('negInfOne: $negInfOne');
  print('negInfNaN: $negInfNaN');
  print('negInfNegInf: $negInfNegInf');
  print('oneNaN: $oneNaN');
  print('zeroInf: $zeroInf');
  print('zeroNaN: $zeroNaN');
  print('nanInf: $nanInf');
  print('nanNegInf: $nanNegInf');
  print('nanZero: $nanZero');

  // Test operations with special values
  print('\nOperations with special values:');
  print('infInf + oneInf: ${infInf + oneInf}');
  print('infInf * oneInf: ${infInf * oneInf}');
  print('infInf / oneInf: ${infInf / oneInf}');
  print('Complex.zero / Complex.zero: ${Complex.zero() / Complex.zero()}');
  print('oneInf / zeroInf: ${oneInf / zeroInf}');
  print('~infInf: ${~infInf}');
  print('nanInf.abs(): ${nanInf.abs()}');
  print('infInf.abs(): ${infInf.abs()}');

  // Test equality with special values
  print('\nEquality with special values:');
  print('nanInf == nanNegInf: ${nanInf == nanNegInf}');
  print('zeroNaN == Complex.nan: ${zeroNaN == Complex.nan()}');
  print('infInf == infInf: ${infInf == infInf}');
  print('infNegInf == negInfInf: ${infNegInf == negInfInf}');

  // Test simplification to numerical types
  var c1 = Complex(2, 0);
  var c2 = Complex(2.5, 0);
  var c3 = Complex(3, 4);

  print('c1 = $c1'); // Should print "2"
  print('c2 = $c2'); // Should print "2.5"
  print('c3 = $c3'); // Should print "3.0 + 4.0i"

  print('c1 == 2: ${c1 == 2}'); // Should be true
  print('c1 == 2.0: ${c1 == 2.0}'); // Should be true
  print('c2 == 2.5: ${c2 == 2.5}'); // Should be true
  print('c3 == 3: ${c3 == 3}'); // Should be false

  print('c1.value type: ${c1.value.runtimeType}'); // Should be int
  print('c2.value type: ${c2.value.runtimeType}'); // Should be double
  print('c3.value type: ${c3.value.runtimeType}'); // Should be Complex

  // Check numerical operations result in proper simplification
  final sum = Complex(3, 0) + Complex(4, 0);
  print('3 + 4 = $sum'); // Should print "7"
  print('sum type: ${sum.value.runtimeType}'); // Should be int

  final product = Complex(2.5, 0) * Complex(2, 0);
  print('2.5 * 2 = $product'); // Should print "5.0"
  print('product type: ${product.value.runtimeType}'); // Should be double

  final infComplex = Complex(inf, 0);
  final nanComplex = Complex(nan, 0);

  print('inf = $infComplex'); // Should print "Inf"
  print('nan = $nanComplex'); // Should print "NaN"

  print('infComplex == inf: ${infComplex == inf}'); // Should be true
  print(
      'nanComplex == nan: ${nanComplex == nan}'); // Should be true (special case)

  // Test toString() simplification
  print('Complex(7, 0).toString() = ${Complex(7, 0)}'); // Should print "7"
  print('Complex(7.0, 0).toString() = ${Complex(7.0, 0)}'); // Should print "7"
  print(
      'Complex(7.5, 0).toString() = ${Complex(7.5, 0)}'); // Should print "7.5"

  var a = Complex(3, 4);
  var b = Complex(1, 2);

  print(a + 5); // 8.0 + 4.0i
  // print(2.0 - a); // -1.0 - 4.0
  // print(3.0 * b); // 3.0 + 6.0i
  // print(15.0 / a); // 1.8 - 2.4
  print(~a); // 0.12 - 0.16i

  final c = Complex.fromReal(5);
  print(c == 5); // true

  // Additional test cases
  print(a + b); // 4.0 + 6.0i
  print(b - a); // -2.0 - 2.0i
  print(a * b); // -5.0 + 10.0i
  print(b / a); // 0.44 + 0.08i
  print(Complex(5.0, 6.0));

  print(Complex(1e-20, 0).value); // 0 (int)
  print(Complex(1.000000000000001, 0).value); // 1.000000000000001 (double)
  print(Complex(123456789012345678901234567890.0, 0)
      .value); // 123456789012345678901234567890 (int)
  print(Complex(double.nan, 0).value); // double.nan
  print(Complex(double.infinity, 0).value); // double.infinity
  print(Complex(double.negativeInfinity, 0).value); //double.negativeInfinity

  // Uses bitwise check for numbers up to 2^53 (JS-safe)
  print(Complex(9007199254740992.0, 0).value); // 9007199254740992 (int)
  print(Complex(9007199254740993.0, 0).value); // 9007199254740993.0 (double)

  print(Complex(5.0, 0).value); // int
  print(Complex(5.5, 0).value); // double
  print(Complex(1e30, 0).value); // int (Dart can handle big integers)

  print(Complex(0.0, 0).value); // 0 (int)
  print(Complex(-0.0, 0).value); // 0 (int)
  print(Complex(double.maxFinite, 0).value); //double (if beyond 2^53)
  print(Complex(double.minPositive, 0).value); //double (if beyond 2^53)
  print(Complex(2, 5).modulus);
  print(Complex(2, 5).complexModulus);

  c1 = Complex(3, 4);
  print(c1.toString()); // 3 + 4i
  print(c1.toStringAsFixed(1)); // 3.0 + 4.0i
  print(c1.toStringAsFraction()); // 3 + 4i

  c2 = Complex(2.5, 0);
  print(c2.toString()); // 2.5
  print(c2.toStringAsFixed(1)); // 2.5
  print(c2.toStringAsFraction()); // 2 1/2

  c3 = Complex.polar(2, pi / 2);
  print(c3.toStringAsFixed(3)); // 0.000 + 2.000i

  // Case 1: (5 - i) + (2 + 2i)i
  final result = Complex(Complex(5, -1), Complex(2, 2));
  print(result); // 3 + 1i

  // Case 2: Copy constructor
  a = Complex(2, 5);
  b = Complex(a);
  print(b); // 2 + 5i

  // Complex real + num imaginary
  print(Complex(Complex(2, 3), 4)); // 2 + 7i

  // Num real + complex imaginary
  print(Complex(5, Complex(1, 2))); // 3 + 1i
  print(Complex(2, 5)); // 2 + 5i
  print(Complex(3.14, Complex(0, 1))); // 2.14
  // Pure imaginary multiplication
  print(Complex(Complex(0, 1), Complex(0, 1))); // -1 + i

  // Mixed real/imaginary components
  print(Complex(Complex(2, 3), Complex(4, 5))); // -3 + 7i

  print(Complex.parse('-5 - 6i')); // -5-6i
  print(Complex('7+0i')); // 7
  print(Complex('-7+5i')); // -7
  print(Complex('7')); // 7
  print(Complex('-7')); // -7
  print(Complex('0.5')); // 0.5
  print(Complex('-0.5')); // -0.5
  print(Complex('0.5i')); // 0.5i
  print(Complex('-0.5i')); // -0.5i
  print(Complex('0.5+0.5i')); // 0.5 + 0.5i
  print(Complex('i')); // i
  print(Complex('-i')); // -i

  print(Complex('3+4i')); // 3 + 4i
  print(Complex('1-i')); // 1 - 1i
  print(Complex('5')); // 5 + 0i
  print(Complex('-2.5', '3.7')); // -2.5 + 3.7i

  // Fractional formats
  print(Complex('3/2+5/4i')); // 1.5 + 1.25i
  print(Complex.parse('3/4+5/2i')); // 0.75 + 2.5i

  // Mixed formats
  print(Complex('-√3+2πi')); // -1.732... + 6.283...i
  print(Complex.parse('π+ei')); // 3.1415... + 2.7182...i
  print(Complex.parse('√2-i')); // 1.4142... - i
  print(Complex(5, Complex(2, 1))); // 4 + 2i
  print(Complex(5, '2+1i')); // 4 + 2i
  print(Complex(Complex(3, 2), Complex(5, -4))); // 7 + 7i
  print(Complex('3+2i', '5-4i')); // 7 + 7i
  print(Complex(Complex(3, -2), Complex(5, -4))); // 7 + 3i
  print(Complex('3-2i', '5-4i')); // 7 + 3i

  // Scientific notation
  print(Complex.parse('1e3 + 2.5e-2i')); // 1000 + 0.025i
  print(Complex('1.2e3+3.4e-5i')); // 1200 + 0.000034i
  print(Complex.parse('2.5e3+4.2e-2i')); // 2500 + 0.042i

  printLine();
  print(Complex(3, 0).toInt());
  print(Complex(3, 1e-16).toInt());
  print(Complex(3.5, 0).toInt());
  try {
    print(Complex(3, 4).toInt());
  } catch (e) {
    print(e);
  }

  printLine();

  print(Complex.parse('0.5+0.5i').toNum());
  print(Complex.parse('0.5+0.5i').simplify());
  try {
    print(Complex.parse('0.5+0.5i').toInt());
  } catch (e) {
    print(e);
  }
  try {
    print(Complex.parse('0.5+0.5i').toInt());
  } catch (e) {
    print(e);
  }

  // print(2 + Complex(4));
  print(Complex.infinity());

  var i = Imaginary(1); // 1i
  var j = Imaginary(2); // 2i
  print(i + j); // 3i
  print(i * j); // -2 (real number)
  print(i / j); // 0.5 (real number)
}
