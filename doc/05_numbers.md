# Number Types Module

Advanced number types including Decimal, Rational, Complex numbers, Roman numerals, Perfect numbers, and ComplexArray.

---

## Table of Contents

1. [Decimal (Arbitrary Precision)](#decimal-arbitrary-precision)
2. [Rational Numbers](#rational-numbers)
3. [PI Computation](#pi-computation)
4. [Complex Numbers](#complex-numbers)
5. [ComplexArray](#complexarray)
6. [Imaginary Numbers](#imaginary-numbers)
7. [Roman Numerals](#roman-numerals)
8. [Perfect Numbers](#perfect-numbers)
9. [Special Number Tests](#special-number-tests)

---

## Decimal (Arbitrary Precision)

The `Decimal` class provides arbitrary-precision decimal arithmetic with support for mathematical functions.

### Creating Decimals

```dart
import 'package:advance_math/advance_math.dart';

// From various types
print(Decimal('12'));              // 12
print(Decimal('0.1234'));          // 0.1234
print(Decimal('-12.345'));         // -12.345
print(Decimal(-12));               // -12
print(Decimal(12.123456789));      // 12.123456789

// With significant digits
print(Decimal('1.23456789e-6', sigDigits: 4));

// Factory constructors
Decimal.fromInt(42);
Decimal.fromBigInt(BigInt.from(999999999999));
Decimal.parse('3.14159');
Decimal.fromJson('2.71828');
```

### Setting Precision

```dart
// Set global precision
Decimal.setPrecision(100);

// Or use the global variable directly
decimalPrecision = 50;
```

### Special Constants

```dart
Decimal.zero      // 0
Decimal.one       // 1
Decimal.ten       // 10
Decimal.hundred   // 100
Decimal.thousand  // 1000
Decimal.infinity  // ∞
Decimal.negInfinity // -∞
Decimal.nan       // NaN
```

### Arithmetic Operations

```dart
var a = Decimal('10.5');
var b = Decimal('3.2');

print(a + b);    // 13.7
print(a - b);    // 7.3
print(a * b);    // 33.6
print(a / b);    // Returns Rational
print(a ~/ b);   // 3 (integer division)
print(a % b);    // 0.9 (modulo)
print(-a);       // -10.5
```

### Mathematical Functions

```dart
decimalPrecision = 25;

// Exponential and logarithmic
print(Decimal.parse('1').exp());   // 2.718281828459045235360287471...
print(Decimal.parse('2').exp());   // 7.389056098930650227230427461...
print(Decimal.parse('0.5').ln());  // -0.6931471805599453...

// Trigonometric
print(Decimal.parse('0.5').cos()); // 0.8775825618903727...
print(Decimal.parse('0.5').sin()); // 0.4794255386042030...
print(Decimal.parse('0.5').tan()); // 0.5463024898437905...

// Square root
print(Decimal.parse('0.5').sqrt()); // 0.7071067811865475...
print(Decimal.parse('0.6').sqrt()); // 0.7745966692414833...
print(Decimal('2').sqrt());         // 1.4142135623730950...

// Power
print(Decimal.parse('2.1').pow(Decimal.parse('5.21'))); // 47.72682295935301...
print(Decimal.parse('2.0').pow(Decimal.parse('0.5')));  // √2 = 1.41421356...
```

### Properties

```dart
var d = Decimal('123.456');

print(d.isInteger);     // false
print(d.precision);     // Total number of digits
print(d.scale);         // Digits after decimal point
print(d.sigNum);        // Sign: -1, 0, or 1
print(d.isExactInt);    // Can be represented as int?
print(d.isExactDouble); // Can be represented as double?
print(d.isPowerOfTen()); // Is 10, 100, 1000, etc.?
```

### Rounding

```dart
var d = Decimal('123.456789');

print(d.floor(scale: 2));  // 123.45
print(d.ceil(scale: 2));   // 123.46
print(d.round(scale: 2));  // 123.46
```

### Conversion

```dart
var d = Decimal('123.456');

print(d.toDouble());    // 123.456 (double)
print(d.toBigInt());    // 123 (truncated)
print(d.toRational());  // Returns underlying Rational
print(d.toJson());      // "123.456" (String for JSON)
```

---

## Rational Numbers

The `Rational` class represents fractions with arbitrary precision using `BigInt`.

### Creating Rationals

```dart
// From numerator and denominator
print(Rational(4, 6));               // 2/3 (auto-simplified)
print(Rational(4));                  // 4
print(Rational.fromInt(3, 4));       // 3/4

// Parsing various formats
print(Rational.parse("-2 3/4"));     // -11/4 (mixed number)
print(Rational.parse("-3/4"));       // -3/4
print(Rational.parse("3/4"));        // 3/4
print(Rational.parse("-0.75"));      // -3/4
print(Rational.parse("0.75"));       // 3/4
print(Rational.parse("-3.14e2"));    // -314
print(Rational.parse("3.14e-2"));    // 157/5000

// From doubles
print(Rational(12.123456789));
print(Rational.fromDouble(3.14159));

// With null handling
print(Rational(null, 6));            // 0
print(Rational(double.infinity, 6)); // Infinity
```

### Special Values

```dart
Rational.zero             // 0/1
Rational.one              // 1/1
Rational.infinity         // 1/0 (positive infinity)
Rational.negativeInfinity // -1/0 (negative infinity)
Rational.nan              // 0/0 (Not a Number)
```

### Properties

```dart
var r = Rational(7, 4);

print(r.numerator);          // 7 (BigInt)
print(r.denominator);        // 4 (BigInt)
print(r.isInteger);          // false
print(r.isWhole());          // false (7%4 != 0)
print(r.isProper());         // false (7 >= 4)
print(r.isImproper());       // true

// Special value checks
print(Rational.infinity.isInfinite);        // true
print(Rational.infinity.isPositiveInfinity); // true
print(Rational.nan.isNaN);                  // true
```

### Arithmetic

```dart
var a = Rational(1, 2);
var b = Rational(1, 3);

print(a + b);    // 5/6
print(a - b);    // 1/6
print(a * b);    // 1/6
print(a / b);    // 3/2
print(a % b);    // Remainder
print(-a);       // -1/2

// Power
print(Rational(2, 3).pow(3));  // 8/27
print(Rational(4, 9).square()); // 16/81
print(Rational(2, 3).cube());   // 8/27
```

### Conversion

```dart
var r = Rational(7, 4);

print(r.toDouble());   // 1.75
print(r.toBigInt());   // 1 (truncated)
print(r.floor());      // 1 (BigInt)
print(r.ceil());       // 2 (BigInt)
print(r.round());      // 2 (BigInt)
print(r.truncate());   // 1 (BigInt)

// To Decimal
print(r.toDecimal());  // 1.75
print(r.toDecimal(precision: 10));  // With specific precision
```

### Clamping

```dart
var r = Rational(5, 2);  // 2.5
print(r.clamp(Rational.one, Rational(2)));  // 2
```

---

## PI Computation

Calculate Pi to arbitrary precision using various algorithms.

### Basic Usage

```dart
decimalPrecision = 100;
var pi = PI(precision: 100);

print(pi.toString());  // π to 100 decimal places
```

### Available Algorithms

```dart
int digits = 50;

// BBP Algorithm
var bbp = BBP(digits);
print(bbp.calculate());

// Chudnovsky Algorithm (fastest for many digits)
var chudnovsky = Chudnovsky(digits);
print(chudnovsky.calculate());

// Gauss-Legendre Algorithm
var gaussLegendre = GaussLegendre(digits);
print(gaussLegendre.calculate());

// Ramanujan Algorithm
var ramanujan = Ramanujan(digits);
print(ramanujan.calculate());

// Madhava Series
var madhava = Madhava(digits);
print(madhava.calculate());

// Newton-Euler Method
var newtonEuler = NewtonEuler(digits);
print(newtonEuler.calculate());

// Performance
print('Time per digit: ${bbp.getTimePerDigit()} ms');
print('Total Time: ${bbp.getTotalTime()} ms');
```

### PI Utilities

```dart
var pi = PI(precision: 500);

// Get specific digit
print("10th digit of π: ${pi.getNthDigit(10)}");

// Pattern search
print(pi.containsPattern('4338327950288'));
print(pi.findPatternIndices('4338327950288'));

// Get digit range
print("Digits 10 to 15: ${pi.getDigits(10, 15)}");

// Digit frequency analysis
Map<String, int> freq = pi.countDigitFrequency();
freq.forEach((digit, count) => print('$digit: $count'));
```

### Compute with PI

```dart
var pi = PI(precision: 10);
var r = Decimal(5);

// Circle circumference: 2πr
var circumference = pi.compute((p) => Decimal(2) * r * p);
print("Circumference: $circumference");

// Circle area: πr²
var area = pi.compute((p) => p * r * r);
print("Area: $area");

// Division
print((pi / Decimal(5.5)).toDecimal());
```

---

## Complex Numbers

The `Complex` class provides full complex number arithmetic with extensive operations.

### Creating Complex Numbers

```dart
import 'package:advance_math/advance_math.dart';

// From real and imaginary parts
var z1 = Complex(3, 4);        // 3 + 4i
var z2 = Complex(2.5, -1.5);   // 2.5 - 1.5i

// From real only
var real = Complex.fromReal(5);  // 5 + 0i

// From polar form
var polar = Complex.polar(2, pi / 2);  // r=2, θ=π/2 → 0 + 2i

// Special values
var zero = Complex.zero();       // 0 + 0i
var one = Complex.one();         // 1 + 0i
var i = Complex.i();             // 0 + 1i
var nan = Complex.nan();         // NaN + NaNi
var inf = Complex.infinity();    // ∞ + ∞i

// Parse from string
print(Complex.parse('3+4i'));         // 3 + 4i
print(Complex('1-i'));                // 1 - 1i
print(Complex('-5 - 6i'));            // -5 - 6i
print(Complex('i'));                  // 0 + 1i
print(Complex('-i'));                 // 0 - 1i

// Special formats
print(Complex('3/2+5/4i'));           // 1.5 + 1.25i (fractions)
print(Complex('-√3+2πi'));            // -1.732... + 6.283...i
print(Complex.parse('1e3 + 2.5e-2i')); // 1000 + 0.025i (scientific)
```

### Complex from Complex Components

```dart
// Complex real + Complex imaginary
// z = (a + bi) + (c + di)i = (a - d) + (b + c)i
var result = Complex(Complex(5, -1), Complex(2, 2));
print(result);  // 3 + 1i

// Copy constructor
var a = Complex(2, 5);
var b = Complex(a);
print(b);  // 2 + 5i
```

### Basic Properties

```dart
var z = Complex(3, 4);

print(z.real);        // 3.0
print(z.imaginary);   // 4.0
print(z.abs());       // 5.0 (magnitude)
print(z.argument());  // 0.927... (phase angle in radians)
print(z.modulus);     // 5.0
print(z.conjugate()); // 3 - 4i

// Check properties
print(z.isReal);      // false
print(z.isImaginary); // false
print(z.isZero);      // false
print(z.isNaN);       // false
print(z.isInfinite);  // false
```

### Arithmetic Operations

```dart
var a = Complex(3, 4);
var b = Complex(1, 2);

// Basic operations
print(a + b);   // 4 + 6i
print(a - b);   // 2 + 2i
print(a * b);   // -5 + 10i
print(a / b);   // 2.2 + 0.4i

// With scalars
print(a + 5);   // 8 + 4i
print(a * 2);   // 6 + 8i

// Inverse (reciprocal)
print(~a);      // 0.12 - 0.16i

// Negation
print(-a);      // -3 - 4i
```

### Mathematical Functions

```dart
var z = Complex(3, 4);

// Power and roots
print(z.pow(2));      // z²
print(z.sqrt());      // √z
print(z.nthRoot(3));  // ³√z

// Exponential and logarithmic
print(z.exp());       // e^z
print(z.log());       // ln(z)
print(z.log10());     // log₁₀(z)
```

### Trigonometric Functions

```dart
var z = Complex(1, 1);

// Basic trig
print(z.sin());    // sin(z)
print(z.cos());    // cos(z)
print(z.tan());    // tan(z)

// Inverse trig
print(z.asin());   // arcsin(z)
print(z.acos());   // arccos(z)
print(z.atan());   // arctan(z)

// Hyperbolic
print(z.sinh());   // sinh(z)
print(z.cosh());   // cosh(z)
print(z.tanh());   // tanh(z)

// Inverse hyperbolic
print(z.asinh());  // arcsinh(z)
print(z.acosh());  // arccosh(z)
print(z.atanh());  // arctanh(z)
```

### Formatting and Conversion

```dart
var c = Complex(3, 4);

// String representations
print(c.toString());           // 3 + 4i
print(c.toStringAsFixed(2));   // 3.00 + 4.00i
print(c.toStringAsFraction()); // 3 + 4i

// Conversion
print(c.toList());   // [3, 4]
print(c.toMap());    // {'real': 3, 'imaginary': 4}

// Simplification
var r = Complex(5, 0);
print(r.value);           // 5 (int)
print(r.toNum());         // 5
print(r.toInt());         // 5

var d = Complex(5.5, 0);
print(d.value);           // 5.5 (double)
```

### Special Values Handling

```dart
const inf = double.infinity;
const neginf = double.negativeInfinity;
const nan = double.nan;

var infInf = Complex(inf, inf);
var oneInf = Complex(1, inf);
var nanZero = Complex(nan, 0);

print(infInf.isInfinite);  // true
print(nanZero.isNaN);      // true

// Operations with infinity
print(infInf + oneInf);    // Complex with infinity
print(Complex.zero() / Complex.zero());  // NaN
```

---

## ComplexArray

Efficient bulk operations on arrays of complex numbers.

### Creating Arrays

```dart
// Fixed size
var arr = ComplexArray(100);

// From list
var fromList = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);

// SIMD-optimized (native platforms only)
var simd = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);
```

### Bulk Operations

```dart
var a = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);
var b = ComplexArray.from([Complex(5, 6), Complex(7, 8)]);

// In-place operations
a.addInPlace(b);
a.subtractInPlace(b);
a.multiplyInPlace(b);
a.divideInPlace(b);
a.scaleInPlace(2.0);
a.conjugateInPlace();
a.negateInPlace();
a.addScalarInPlace(5.0);

// Non-mutating
var sum = a.add(b);
var product = a.multiply(b);
var copy = a.copy();
```

### Aggregation

```dart
var arr = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);

print(arr.sum());         // Sum of all elements
print(arr.mean());        // Average
print(arr.normSquared()); // Sum of |z|²
print(arr.dot(arr));      // Dot product
```

### Signal Processing

```dart
var signal = ComplexArray.from([
  Complex(1, 0), Complex(2, 0), Complex(3, 0), Complex(4, 0)
]);

// FFT (array size must be power of 2)
var fft = signal.fft();
var ifft = fft.ifft();  // Inverse

// Circular shift
var shifted = signal.circularShift(2);
```

### Element-wise Functions

```dart
var arr = ComplexArray.from([Complex(1, 1), Complex(2, 2)]);

arr.expInPlace();   // e^z for each element
arr.logInPlace();   // log(z) for each element
arr.sqrtInPlace();  // √z for each element
arr.powInPlace(2);  // z^2 for each element
```

---

## Imaginary Numbers

The `Imaginary` class represents pure imaginary numbers.

```dart
var i = Imaginary(1);    // 1i
var j = Imaginary(2);    // 2i

print(i + j);            // 3i
print(i * j);            // -2 (real number)
print(i / j);            // 0.5 (real number)
print(i - j);            // -1i

// Convert to Complex
var complex = i.toComplex();  // 0 + 1i
```

---

## Roman Numerals

Convert between integers and Roman numerals with multiple style configurations.

### Basic Usage

```dart
// Integer to Roman
var roman = RomanNumerals(5);
print(roman);             // V

print(RomanNumerals(69)); // LXIX
print(RomanNumerals(1989)); // MCMLXXXIX

// Roman to Integer
print('MCMLXXXIX'.toRomanNumeralValue());  // 1989
print(RomanNumerals.fromRoman('V̅MMMDCCLXXXV').value);

// Validation
print('CDXVIII'.isValidRomanNumeralValue()); // true
```

### Large Numbers

```dart
// Using overline (vinculum) for thousands
print(RomanNumerals(3999999, useOverline: true));
// M̅M̅M̅C̅M̅X̅C̅MX̅CMXCIX

// Using parentheses notation
print(RomanNumerals(8785, useOverline: false)); // (VIII)DCCLXXXV
```

### Configuration Styles

```dart
// Common style (default)
RomanNumerals.romanNumeralsConfig = CommonRomanNumeralsConfig();
print(418.toRomanNumeralString());  // CDXVIII

// Vinculum style (overlines for large numbers)
RomanNumerals.romanNumeralsConfig = VinculumRomanNumeralsConfig();
print(3449671.toRomanNumeralString()); // M̅M̅M̅C̅D̅X̅L̅MX̅DCLXXI

// Apostrophus style
RomanNumerals.romanNumeralsConfig = ApostrophusRomanNumeralsConfig();
print(2449671.toRomanNumeralString());
// CCCCIↃↃↃↃCCCCIↃↃↃↃCCCIↃↃↃIↃↃↃↃCCIↃↃIↃↃↃCIↃCCIↃↃIↃCLXXI

// Compact Apostrophus (special Unicode)
RomanNumerals.romanNumeralsConfig = CompactApostrophusRomanNumeralsConfig();
print(347449.toRomanNumeralString());  // ↈↈↈↂↇↁↀↀCCCCXLIX

// Zero support
RomanNumerals.romanNumeralsConfig = CommonRomanNumeralsConfig(nulla: 'N');
print(0.toRomanNumeralString());  // N
```

### Date Conversion

```dart
// Convert Roman numeral date to formatted date
print(RomanNumerals.romanToDate(
  'VIII・XXII・MCMLXXXIX',
  sep: '・',
  format: 'MMMM d, yyyy'
));  // August 22, 1989
```

---

## Perfect Numbers

Utilities for working with perfect, amicable, and related number types.

### Perfect Number Detection

```dart
// A perfect number equals the sum of its proper divisors
print(isPerfectNumber(6));    // true (1 + 2 + 3 = 6)
print(isPerfectNumber(28));   // true (1 + 2 + 4 + 7 + 14 = 28)
print(isPerfectNumber(12));   // false
```

### Abundant and Deficient Numbers

```dart
// Abundant: sum of divisors > number
print(isAbundantNumber(12));  // true (1+2+3+4+6 = 16 > 12)

// Deficient: sum of divisors < number
print(isDeficientNumber(8));  // true (1+2+4 = 7 < 8)
```

### Amicable Numbers

```dart
// Two numbers are amicable if each is the sum of the other's divisors
print(areAmicableNumbers(220, 284));  // true
// 220: 1+2+4+5+10+11+20+22+44+55+110 = 284
// 284: 1+2+4+71+142 = 220
```

---

## Special Number Tests

Utilities for testing interesting number properties.

### Collatz Sequence

```dart
// Generate Collatz sequence
print(collatz(6));  // [6, 3, 10, 5, 16, 8, 4, 2, 1]

// Get peak value in Collatz sequence
print(collatzPeak(6));   // 16
print(collatzPeak(27));  // 9232

// Find number with longest Collatz sequence in range
print(longestCollatzInRange(1, 30));  // {number: 27, length: 111}
```

### Kaprekar Numbers

```dart
// A Kaprekar number is one where n² can be split into parts that sum to n
print(isKaprekarNumber(9));   // true (9² = 81, 8+1 = 9)
print(isKaprekarNumber(45));  // true (45² = 2025, 20+25 = 45)
print(isKaprekarNumber(10));  // false
```

### Narcissistic Numbers

```dart
// Sum of digits raised to power of digit count equals the number
print(isNarcissisticNumber(153));  // true (1³ + 5³ + 3³ = 153)
print(isNarcissisticNumber(370));  // true (3³ + 7³ + 0³ = 370)
print(isNarcissisticNumber(100));  // false
```

### Happy Numbers

```dart
// Repeated sum of squared digits eventually reaches 1
print(isHappyNumber(19));  // true
// 1² + 9² = 82
// 8² + 2² = 68
// 6² + 8² = 100
// 1² + 0² + 0² = 1

print(isHappyNumber(4));   // false
```

---

## Related Tests

- [`test/number/`](../test/number/) - Number type tests (Complex, Decimal, Rational)
- [`test/test_nan_infinity.dart`](../test/test_nan_infinity.dart) - Special value handling

## Related Documentation

- [Basic Math](02_basic_math.md) - Core math functions and ranges
- [Algebra](01_algebra.md) - Matrix and vector operations
- [Quantity](06_quantity.md) - Physical quantities with numeric types
