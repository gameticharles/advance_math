# Math Module

Provides a collection of basic mathematical functions, statistical operations, mathematical constants, trigonometric and logarithmic functions, random number generation utilities, and execution time measurement tools. This module supports both standard numeric types and `Complex` numbers for many operations.

## Table of Contents
- [Basic Math Functions](#basic-math-functions)
- [Statistical Operations](#statistical-operations)
- [Mathematical Constants](#mathematical-constants)
  - [General Constants](#general-constants)
  - [Angle Constants](#angle-constants)
  - [Physics Constants](#physics-constants)
- [Trigonometric Functions](#trigonometric-functions)
  - [Standard Trigonometric Functions](#standard-trigonometric-functions)
  - [Inverse Trigonometric Functions](#inverse-trigonometric-functions)
  - [Hyperbolic Trigonometric Functions](#hyperbolic-trigonometric-functions)
  - [Inverse Hyperbolic Trigonometric Functions](#inverse-hyperbolic-trigonometric-functions)
  - [Other Trigonometric-Related Functions](#other-trigonometric-related-functions)
- [Logarithmic Functions](#logarithmic-functions)
- [Random Number Generation](#random-number-generation)
  - [The `Random` Class](#the-random-class)
  - [Utility Random Functions](#utility-random-functions)
  - [Random Providers](#random-providers)
- [Execution Time Measurement](#execution-time-measurement)

---

## Basic Math Functions
*(Covers functions from `lib/src/math/basic/basic.dart`)*

### `sumTo(int n) -> int`
Returns the sum of all integers from 1 up to `n`. Calculated as `n * (n + 1) / 2`.
```dart
print(sumTo(5));   // Output: 15
print(sumTo(100)); // Output: 5050
```

### `sumUpTo(num start, num end, {num step = 1}) -> num`
Sums all values from `start` to `end` (inclusive), incrementing by `step`.
Throws an `ArgumentError` if `step` is zero or if its sign prevents reaching `end` from `start`.
```dart
print(sumUpTo(1, 5));                // Output: 15  (1+2+3+4+5)
print(sumUpTo(5, 1, step: -1));      // Output: 15  (5+4+3+2+1)
print(sumUpTo(0, 10, step: 2));      // Output: 30  (0+2+4+6+8+10)
// print(sumUpTo(1, 5, step: -1));   // Throws ArgumentError
```

### `abs(dynamic x) -> dynamic`
Returns the absolute value of `x`. Handles `num` and `Complex` types.
```dart
print(abs(-5));    // Output: 5
print(abs(-5.5));  // Output: 5.5
// print(abs(Complex(-3, -4))); // Output: 5.0 (magnitude of complex number)
```

### `sqrt(dynamic x) -> dynamic`
Returns the principal square root of `x`.
- If `x` is a non-negative `num`, returns `double`.
- If `x` is a negative `num`, returns a `Complex` number (`0 + i * sqrt(|x|)`).
- If `x` is a `Complex` number, computes its complex square root.
```dart
print(sqrt(9));    // Output: 3.0
print(sqrt(2));    // Output: 1.4142135623730951
print(sqrt(-4));   // Output: 0.0 + 2.0i (Complex)
// print(sqrt(Complex(-5, 12))); // Output: 2.0 + 3.0i (Complex)
```

### `cbrt(dynamic x) -> dynamic`
Returns the principal cube root of `x`. Delegates to `nthRoot(x, 3)`.
```dart
print(cbrt(8));    // Output: 2.0
print(cbrt(-27));  // Output: 0.0 + 3.0i (Complex, from nthRoot logic for negative num)
                   // Note: math.pow(-27, 1/3) would be -3.0. This returns principal complex root.
// print(cbrt(Complex(0,8))); // Example for complex input
```

### `nthRoot(dynamic x, int nth) -> dynamic`
Returns the principal `nth` root of `x`.
- If `x` is a non-negative `num`, returns `double`.
- If `x` is a negative `num`, returns a `Complex` number representing the principal root.
- If `x` is `Complex`, computes its complex nth root.
```dart
print(nthRoot(16, 4)); // Output: 2.0
print(nthRoot(-16, 2)); // Output: 0.0 + 4.0i (Complex)
// print(nthRoot(Complex(1,1), 3));
```

### `exp(dynamic x) -> dynamic`
Returns Euler's number `e` raised to the power of `x` (e<sup>x</sup>). Handles `num` and `Complex`.
```dart
print(exp(1));    // Output: 2.718281828459045 (e)
print(exp(0));    // Output: 1.0
// print(exp(Complex(0, pi))); // Output: -1.0 + 1.2246467991473532e-16i (approx. -1)
```

### `pow(dynamic x, dynamic exponent) -> dynamic`
Raises `x` to the power of `exponent`. Handles `num` and `Complex` types for both base and exponent.
```dart
print(pow(2, 3));      // Output: 8.0
print(pow(9, 0.5));    // Output: 3.0
// print(pow(Complex(1,1), 2)); // Output: 0.0 + 2.0i
// print(pow(2, Complex(1,1)));
```

### `step(double x) -> double`
Heaviside step function. Returns 1.0 if `x > 0`, 0.0 if `x < 0`, and 0.5 if `x == 0`.
```dart
print(step(5.0));  // Output: 1.0
print(step(-5.0)); // Output: 0.0
print(step(0.0));  // Output: 0.5
```

### `rect(double x) -> dynamic`
Rectangle function (rect(x)).
- Returns 0 if `abs(x) > 0.5`.
- Returns 0.5 if `abs(x) == 0.5`.
- Returns 1 if `abs(x) < 0.5`.
```dart
print(rect(0.25)); // Output: 1
print(rect(0.5));  // Output: 0.5
print(rect(0.75)); // Output: 0
```

### `sinc(double x) -> dynamic`
Sinc function, also known as the sampling function. Defined as `sin(x)/x` for `x != 0`, and `1` for `x == 0`.
```dart
print(sinc(0.0)); // Output: 1.0
print(sinc(pi / 2)); // Output: (sin(pi/2))/(pi/2) = 1/(pi/2) = 2/pi approx 0.6366
```

### `modF(double x) -> ({double fraction, int integer})`
Splits `x` into its integer and fractional parts. Returns a record `(fraction: double, integer: int)`.
```dart
var result = modF(4.56);
print('Integer: ${result.integer}, Fraction: ${result.fraction}');
// Output: Integer: 4, Fraction: 0.5600000000000005 (approx)

var resultNeg = modF(-3.14);
print('Integer: ${resultNeg.integer}, Fraction: ${resultNeg.fraction}');
// Output: Integer: -3, Fraction: -0.14000000000000012 (approx)
```

### `mod(dynamic a, dynamic b) -> dynamic`
Returns the remainder of the division of `a` by `b` (modulo operation). Handles `int` and other `num` types.
```dart
print(mod(10, 3));   // Output: 1
print(mod(10.5, 3)); // Output: 1.5
// print(mod(Complex(5,2), Complex(2,1))); // Modulo for complex numbers might be defined differently
```

### `modInv(num a, num m) -> dynamic`
Returns the modular multiplicative inverse of `a` modulo `m`.
`m` must be > 0. `a` and `m` must be relatively prime. Returns `null` if the inverse does not exist.
```dart
print(modInv(3, 11)); // Output: 4 (since 3*4 = 12 ≡ 1 mod 11)
print(modInv(4, 12)); // Output: null (4 and 12 are not coprime)
```

### `nChooseRModPrime(int N, int R, int P) -> dynamic`
Computes "N choose R" modulo a prime `P` (C(N,R) % P) using Fermat's Little Theorem.
`P` must be prime.
```dart
print(nChooseRModPrime(5, 2, 7)); // C(5,2) = 10. 10 mod 7 = 3. Output: 3
print(nChooseRModPrime(10, 3, 13)); // C(10,3)=120. 120 = 9*13 + 3. 120 mod 13 = 3. Output: 3
```

### `bigIntNChooseRModPrime(int N, int R, int P) -> BigInt`
Computes "N choose R" modulo a prime `P` using `BigInt` for calculations, suitable for large N and R.
`P` must be prime.
```dart
print(bigIntNChooseRModPrime(50, 5, 1000000007)); // Example with larger numbers
// C(50,5) = 2118760.
// Output: 2118760
```

### `floor(dynamic x) -> int`
Returns the largest integer less than or equal to `x`.
```dart
print(floor(2.9));  // Output: 2
print(floor(-2.1)); // Output: -3
```

### `ceil(dynamic x) -> int`
Returns the smallest integer greater than or equal to `x`.
```dart
print(ceil(2.1));   // Output: 3
print(ceil(-2.9));  // Output: -2
```

### `round(dynamic x, [int decimalPlaces = 0]) -> dynamic`
Rounds `x` to `decimalPlaces`. If `decimalPlaces` is 0, rounds to the nearest integer. Handles `num` and `Complex` (rounds real and imaginary parts).
```dart
print(round(123.456, 2)); // Output: 123.46
print(round(123.456));    // Output: 123
// print(round(Complex(3.72, -2.13), 1)); // Output: 3.7 - 2.1i
```

### `max<T extends dynamic>(T a, T b) -> T`
Returns the greater of two values `a` and `b`. Works with `num`, `String`, `Complex` (compares magnitudes).
```dart
print(max(5, 10));   // Output: 10
print(max(-1.0, -5.0)); // Output: -1.0
// print(max(Complex(3,4), Complex(1,1)))); // Output: 3.0 + 4.0i (magnitude 5)
```

### `min<T extends dynamic>(T a, T b) -> T`
Returns the smaller of two values `a` and `b`. Works with `num`, `String`, `Complex` (compares magnitudes).
```dart
print(min(5, 10));    // Output: 5
// print(min(Complex(3,4), Complex(1,1)))); // Output: 1.0 + 1.0i (magnitude ~1.414)
```

### `hypot(dynamic x, dynamic y) -> dynamic`
Returns the Euclidean norm, `sqrt(x² + y²)`. Handles `num` and `Complex` inputs. For complex numbers, it correctly computes the magnitude of the complex sum of squares.
```dart
print(hypot(3, 4)); // Output: 5.0
// print(hypot(Complex(3,0), Complex(0,4))); // Output: 5.0 (magnitude of 3+4i)
```

### `sign(dynamic x) -> dynamic`
Returns the sign of `x`.
- For `num`: -1 if negative, 1 if positive, 0 if zero.
- For `Complex`: sign of the real part; if real part is zero, sign of imaginary part.
```dart
print(sign(-15));   // Output: -1
print(sign(0));     // Output: 0
print(sign(100));   // Output: 1
// print(sign(Complex(0, -5))); // Output: -1 (sign of imaginary part)
```

### `clamp(dynamic x, num minBound, num maxBound) -> dynamic`
Clamps `x` to be within the inclusive range [`minBound`, `maxBound`].
- For `num`: standard clamping.
- For `Complex`: clamps both real and imaginary parts independently to [`minBound`, `maxBound`].
```dart
print(clamp(15, 0, 10));    // Output: 10
print(clamp(-5, 0, 10));    // Output: 0
print(clamp(5, 0, 10));     // Output: 5
// print(clamp(Complex(12, -3), 0, 5)); // Output: 5.0 + 0.0i (real clamped to 5, imag clamped to 0)
```

### `lerp(dynamic a, dynamic b, num t) -> dynamic`
Linearly interpolates between `a` and `b` by a factor `t`. Result is `a + (b - a) * t`.
Handles `num` and `Complex` types.
```dart
print(lerp(0, 10, 0.5)); // Output: 5.0
print(lerp(10, 20, 0.25)); // Output: 12.5
// print(lerp(Complex(0,0), Complex(10,20), 0.5)); // Output: 5.0 + 10.0i
```

### `rec(num r, num theta, {bool isDegrees = false}) -> ({double x, double y})`
Converts polar coordinates (`r`, `theta`) to rectangular coordinates (`x`, `y`).
- `theta` is in radians by default. Set `isDegrees: true` if `theta` is in degrees.
```dart
final rectCoordsRad = rec(2, pi / 2); // r=2, theta=90 deg
print(rectCoordsRad); // Output: (x: 1.2246...e-16, y: 2.0) (approx x=0, y=2)

final rectCoordsDeg = rec(2, 90, isDegrees: true);
print(rectCoordsDeg); // Output: (x: 1.2246...e-16, y: 2.0)
```

### `pol(num x, num y, {bool isDegrees = false}) -> ({double r, double theta})`
Converts rectangular coordinates (`x`, `y`) to polar coordinates (`r`, `theta`).
- `theta` is returned in radians by default. Set `isDegrees: true` to get `theta` in degrees.
```dart
final polarCoordsRad = pol(0, 2); // x=0, y=2
print(polarCoordsRad); // Output: (r: 2.0, theta: 1.5707... ) (theta is pi/2)

final polarCoordsDeg = pol(1, 1, isDegrees: true); // x=1, y=1
print(polarCoordsDeg); // Output: (r: 1.414..., theta: 45.0)
```

### `isClose(double a, double b, {double relTol = 1e-9, double absTol = 1e-15}) -> bool`
Determines if two floating-point numbers `a` and `b` are approximately equal, considering relative tolerance `relTol` and absolute tolerance `absTol`.
```dart
print(isClose(0.1 + 0.2, 0.3));        // Output: true
print(isClose(100.0, 100.000000001)); // Output: true
print(isClose(1.0, 1.1, absTol: 0.05)); // Output: false (0.1 > 0.05)
print(isClose(1.0, 1.1, absTol: 0.15)); // Output: true (0.1 <= 0.15)
```

### `isDigit(String input) -> bool`
Checks if all characters in the `input` string are digits (0-9).
```dart
print(isDigit("12345")); // Output: true
print(isDigit("12a45")); // Output: false
print(isDigit("7"));     // Output: true
```

### `isAlpha(String input) -> bool`
Checks if all characters in the `input` string are alphabetic (A-Z, a-z).
```dart
print(isAlpha("HelloWorld")); // Output: true
print(isAlpha("Hello World"));// Output: false (space is not alpha)
print(isAlpha("Alpha1"));     // Output: false
```

### `isAlphaNumeric(String input) -> bool`
Checks if all characters in the `input` string are alphanumeric (A-Z, a-z, 0-9).
```dart
print(isAlphaNumeric("Version42")); // Output: true
print(isAlphaNumeric("Version 42"));// Output: false (space)
print(isAlphaNumeric("V4.2"));      // Output: false (period)
```

### `isDivisible(num n, num divisor) -> bool`
Checks if number `n` is perfectly divisible by `divisor`.
```dart
print(isDivisible(10, 2)); // Output: true
print(isDivisible(10, 3)); // Output: false
print(isDivisible(10.5, 0.5)); // Output: true
```

### `isEven(int n) -> bool`
Checks if integer `n` is even.
```dart
print(isEven(4)); // Output: true
print(isEven(5)); // Output: false
```

### `isOdd(int n) -> bool`
Checks if integer `n` is odd.
```dart
print(isOdd(5)); // Output: true
print(isOdd(4)); // Output: false
```

### `isPrime(dynamic number, [int certainty = 12]) -> bool`
Checks if `number` (int, BigInt, or String representation of an integer) is prime. Uses trial division for small numbers and the Rabin-Miller probabilistic test for larger numbers.
- `certainty`: Number of Rabin-Miller iterations (higher means more confidence).
```dart
print(isPrime(7));    // Output: true
print(isPrime(10));   // Output: false
print(isPrime(BigInt.from(999999937))); // Output: true (a large prime)
print(isPrime("13")); // Output: true
```

### `nthPrime(int n) -> int`
Returns the n-th prime number (e.g., 1st prime is 2, 2nd is 3, etc.).
Throws `ArgumentError` if `n < 1`.
```dart
print(nthPrime(1));  // Output: 2
print(nthPrime(6));  // Output: 13 (primes: 2,3,5,7,11,13)
print(nthPrime(25)); // Output: 97
```

### `isPerfectSquare(int n) -> bool`
Checks if integer `n` is a perfect square.
```dart
print(isPerfectSquare(25)); // Output: true
print(isPerfectSquare(26)); // Output: false
print(isPerfectSquare(0));  // Output: true
```

### `isPerfectCube(int n) -> bool`
Checks if integer `n` is a perfect cube.
```dart
print(isPerfectCube(27)); // Output: true
print(isPerfectCube(28)); // Output: false
print(isPerfectCube(-8)); // Output: true ((-2)^3 = -8)
```

### `isFibonacci(int n) -> bool`
Checks if non-negative integer `n` is a Fibonacci number. A number is Fibonacci if `5n² + 4` or `5n² - 4` is a perfect square.
```dart
print(isFibonacci(8));  // Output: true (0,1,1,2,3,5,8,...)
print(isFibonacci(9));  // Output: false
print(isFibonacci(0));  // Output: true
```

### `isPalindrome(int n) -> bool`
Checks if integer `n` is a palindrome (reads the same forwards and backwards).
```dart
print(isPalindrome(121));   // Output: true
print(isPalindrome(12321)); // Output: true
print(isPalindrome(123));   // Output: false
```

### `isArmstrongNumber(int n) -> bool`
Checks if integer `n` is an Armstrong number (sum of its digits each raised to the power of the number of digits equals `n`).
```dart
print(isArmstrongNumber(153)); // Output: true (1³ + 5³ + 3³ = 1 + 125 + 27 = 153)
print(isArmstrongNumber(370)); // Output: true (3³ + 7³ + 0³ = 27 + 343 + 0 = 370)
print(isArmstrongNumber(100)); // Output: false
```

### `trunc(double x) -> double`
Returns the integer part of `x` by removing fractional digits (truncates towards zero).
```dart
print(trunc(4.7));   // Output: 4.0
print(trunc(-4.7));  // Output: -4.0
print(trunc(4.0));   // Output: 4.0
```

### `primeFactors(int n) -> List<int>`
Returns a sorted list of prime factors of integer `n`. Returns empty list if `n < 2`.
```dart
print(primeFactors(56)); // Output: [2, 2, 2, 7] (2*2*2*7 = 56)
print(primeFactors(81)); // Output: [3, 3, 3, 3]
print(primeFactors(17)); // Output: [17]
```

### `factors(int n) -> List<int>`
Returns a sorted list of all positive divisors of integer `n`.
```dart
print(factors(12)); // Output: [1, 2, 3, 4, 6, 12]
print(factors(17)); // Output: [1, 17]
```

### `nthTriangleNumber(int n) -> int`
Returns the n-th triangle number (sum of integers from 1 to `n`).
```dart
print(nthTriangleNumber(5));  // Output: 15 (1+2+3+4+5)
print(nthTriangleNumber(10)); // Output: 55
```

### `nthPentagonalNumber(int n) -> int`
Returns the n-th pentagonal number, calculated as `n * (3n - 1) / 2`.
```dart
print(nthPentagonalNumber(5));  // Output: 35 (1,5,12,22,35,...)
print(nthPentagonalNumber(3));  // Output: 12
```

### `nthHexagonalNumber(int n) -> int`
Returns the n-th hexagonal number, calculated as `n * (2n - 1)`.
```dart
print(nthHexagonalNumber(5)); // Output: 45 (1,6,15,28,45,...)
print(nthHexagonalNumber(3)); // Output: 15
```

### `nthTetrahedralNumber(int n) -> int`
Returns the n-th tetrahedral number, calculated as `n * (n+1) * (n+2) / 6`. (Sum of first n triangular numbers).
```dart
print(nthTetrahedralNumber(5)); // Output: 35 (1,4,10,20,35,...)
print(nthTetrahedralNumber(3)); // Output: 10
```

### `nthHarmonicNumber(int n) -> double`
Returns the n-th harmonic number (H<sub>n</sub> = 1 + 1/2 + 1/3 + ... + 1/n).
```dart
print(nthHarmonicNumber(3)); // Output: 1.8333333333333333 (1 + 0.5 + 0.333...)
print(nthHarmonicNumber(5)); // Output: 2.283333333333333
```

### `diff(Function f, [double h = 0.001]) -> Function`
Computes the numerical derivative of a single-variable function `f` using the central difference method.
- `f`: The function `num Function(num)` to differentiate.
- `h`: Step size for approximation (default: 0.001).
Returns a new function `num Function(num)` that approximates `f'(x)`.
```dart
var myFunc = (double x) => x * x * x; // f(x) = x³
var myFuncPrime = diff(myFunc);     // f'(x) = 3x²
print(myFuncPrime(2));              // Approx 3*(2)² = 12. Output: 12.000000000000002
print(myFuncPrime(3));              // Approx 3*(3)² = 27. Output: 27.00000000000001
```

### `simpson(Function f, double a, double b, [double step = 0.0001]) -> double`
Approximates the definite integral of `f(x)` from `a` to `b` using Simpson's Rule.
- `f`: The function `double Function(double)` to integrate.
- `a`, `b`: Interval of integration.
- `step`: Step size for the approximation (default: 0.0001).
```dart
double squareFunc(double x) => x * x; // ∫x²dx = x³/3
// Integral of x² from 0 to 2 is (2³/3) - (0³/3) = 8/3 = 2.666...
print(simpson(squareFunc, 0, 2)); // Output: 2.6666666666666665

double sineFunc(double x) => sin(x); // ∫sin(x)dx = -cos(x)
// Integral of sin(x) from 0 to pi is (-cos(pi)) - (-cos(0)) = -(-1) - (-1) = 1 + 1 = 2
print(simpson(sineFunc, 0, pi));  // Output: 2.0000000000000004 (approx)
```

### `integerPart(double x) -> int`
Returns the integer part of `x`. For positive `x`, it's `floor(x)`; for negative `x`, it's `ceil(x)` as per source `sign * x.abs().floor()`.
This truncates towards zero.
```dart
print(integerPart(4.7));  // Output: 4
print(integerPart(-4.7)); // Output: -4 (Source implementation: -1 * floor(4.7) = -4)
```

### `numIntegrate(Function f, double a, double b, [double tol = 1e-9, int maxDepth = 45]) -> double`
Approximates the definite integral of `f(x)` from `a` to `b` using adaptive Simpson's method.
- `f`: Function `double Function(double)` to integrate.
- `tol`: Tolerance for the approximation (default: 1e-9).
- `maxDepth`: Maximum recursion depth (default: 45).
```dart
double cubeFunc(double x) => x * x * x; // ∫x³dx = x⁴/4
// Integral of x³ from 0 to 1 is 1/4 = 0.25
print(numIntegrate(cubeFunc, 0, 1)); // Output: 0.25
```

### `gamma(num z) -> double`
Computes the gamma function Γ(z), an extension of the factorial function.
```dart
print(gamma(0.5)); // Output: 1.7724538509055159 (sqrt(pi))
print(gamma(5));   // Output: 24.0 ( (5-1)! = 4! = 24 )
print(gamma(1));   // Output: 1.0
```

### `factorial(int n) -> int`
Returns the factorial of a non-negative integer `n` (n!). Throws `ArgumentError` for negative `n`.
```dart
print(factorial(5));  // Output: 120
print(factorial(0));  // Output: 1
// print(factorial(-1)); // Throws ArgumentError
```

### `factorial2(dynamic x) -> dynamic`
Computes the factorial of `x`.
- For small positive integers (`<=20`), returns `int`.
- For larger positive integers, returns `BigInt`.
- For non-integers (`double`), uses the gamma function: `gamma(x + 1)`.
- For negative integers, returns `double.nan`.
```dart
print(factorial2(5));        // Output: 120
print(factorial2(25));       // Output: 15511210043330985984000000 (BigInt)
print(factorial2(4.5));      // Output: gamma(5.5) approx 52.34277778455352
print(factorial2(-2));       // Output: NaN
```

### `doubleFactorial(double x) -> double`
Computes the double factorial (n!!) of `x`.
- For integers `n`, it's the product of all integers from `n` down to 1 with the same parity as `n`.
- For non-integers, uses a formula involving the gamma function.
```dart
print(doubleFactorial(5.0)); // Output: 15.0 (5 * 3 * 1)
print(doubleFactorial(6.0)); // Output: 48.0 (6 * 4 * 2)
print(doubleFactorial(0.5)); // Uses gamma function. Output: ~0.87000...
```

### `sieve(int n) -> List<num>`
Generates a list of all prime numbers up to `n` (inclusive) using the Sieve of Eratosthenes.
```dart
print(sieve(30)); // Output: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
print(sieve(10)); // Output: [2, 3, 5, 7]
```

### `fib(int n) -> dynamic`
Returns the n-th Fibonacci number. Handles negative `n` correctly (e.g., F<sub>-1</sub>=1, F<sub>-2</sub>=-1). Returns `int` if it fits, otherwise `BigInt`.
```dart
print(fib(0));  // Output: 0
print(fib(7));  // Output: 13
print(fib(-1)); // Output: 1
print(fib(-8)); // Output: -21
print(fib(50)); // Output: 12586269025 (BigInt)
```

### `fibRange(int start, int end) -> List<num>`
Returns a list of Fibonacci numbers from F<sub>start</sub> to F<sub>end</sub> (inclusive, 0-indexed).
```dart
// F_0=0, F_1=1, F_2=1, F_3=2, F_4=3, F_5=5, F_6=8, F_7=13
print(fibRange(0, 7));  // Output: [0, 1, 1, 2, 3, 5, 8, 13]
print(fibRange(3, 5));  // Output: [2, 3, 5]
```

### `isPandigital(int n) -> bool`
Checks if `n` is pandigital in base 10 using digits 1 through `n.toString().length`.
A number is pandigital if it contains each digit from 1 to its number of digits exactly once.
```dart
print(isPandigital(123));    // Output: true
print(isPandigital(132));    // Output: true (sorted digits are 1,2,3)
print(isPandigital(1234));   // Output: true
print(isPandigital(1223));   // Output: false (2 is repeated, 3 is length, 1 is missing)
print(isPandigital(124));    // Output: false (3 is missing for length 3)
print(isPandigital(1234567890)); // Output: false (contains 0, expects 1-10)
```

### `getDigits(int n) -> List<int>`
Returns a list of the digits of integer `n`.
```dart
print(getDigits(12345)); // Output: [1, 2, 3, 4, 5]
print(getDigits(0));     // Output: [0]
```

### `isPerfectNumber(dynamic n) -> bool`
Checks if `n` (int, BigInt, or String representation of integer) is a perfect number. A perfect number is a positive integer equal to the sum of its proper positive divisors.
```dart
print(isPerfectNumber(6));   // Output: true (1+2+3=6)
print(isPerfectNumber(28));  // Output: true (1+2+4+7+14=28)
print(isPerfectNumber(12));  // Output: false
// print(isPerfectNumber("8128")); // Output: true
```

### `isMersennePrime(int p) -> bool`
Checks if 2<sup>p</sup> - 1 is a Mersenne prime using the Lucas-Lehmer test. `p` itself must be prime for 2<sup>p</sup> - 1 to be a candidate.
```dart
print(isMersennePrime(2));  // 2^2-1 = 3 (prime). Output: true
print(isMersennePrime(3));  // 2^3-1 = 7 (prime). Output: true
print(isMersennePrime(4));  // p=4 is not prime. Output: false (2^4-1 = 15, not prime)
print(isMersennePrime(5));  // 2^5-1 = 31 (prime). Output: true
```

### `binomialCoefficient(int n, int k) -> int`
Computes the binomial coefficient "n choose k", C(n,k).
Throws `ArgumentError` if `k < 0` or `k > n`.
```dart
print(binomialCoefficient(5, 2));  // Output: 10
print(binomialCoefficient(10, 3)); // Output: 120
print(binomialCoefficient(7, 0));  // Output: 1
```

### `collatz(int n, [bool returnSequence = true]) -> dynamic`
Computes the Collatz (3n+1) sequence starting from positive integer `n`.
- `returnSequence`: If `true` (default), returns `List<int>` of the sequence. If `false`, returns `int` (number of steps to reach 1).
Throws `ArgumentError` if `n <= 0`.
```dart
print(collatz(6, returnSequence: true)); // Output: [6, 3, 10, 5, 16, 8, 4, 2, 1]
print(collatz(6, returnSequence: false)); // Output: 8 (steps)
```

### `collatzPeak(int n) -> int`
Computes the maximum value reached in the Collatz sequence for positive integer `n`.
```dart
print(collatzPeak(6));  // Output: 16
print(collatzPeak(27)); // Output: 9232
```

### `longestCollatzInRange(int start, int end) -> Map<String, int>`
Finds the number within the range [`start`, `end`] (inclusive) that has the longest Collatz sequence.
Returns a map `{'number': ..., 'length': ...}` where 'length' is the number of steps.
```dart
var result = longestCollatzInRange(1, 10);
print(result); // Output: {number: 9, length: 19}
```

### `isKaprekarNumber(int n) -> bool`
Checks if `n` (a positive integer) is a Kaprekar number. A number is Kaprekar if its square can be split into two parts (where the right part is non-zero) that sum up to the original number.
```dart
print(isKaprekarNumber(9));   // Output: true (9²=81, 8+1=9)
print(isKaprekarNumber(45));  // Output: true (45²=2025, 20+25=45)
print(isKaprekarNumber(1));   // Output: true (1²=1, 0+1=1)
print(isKaprekarNumber(10));  // Output: false
```

### `isNarcissisticNumber(int n) -> bool`
Checks if `n` is a narcissistic number (Armstrong number). A number that is the sum of its own digits each raised to the power of the number of digits.
```dart
print(isNarcissisticNumber(153)); // Output: true (1³+5³+3³ = 1+125+27 = 153)
print(isNarcissisticNumber(9));   // Output: true (9¹ = 9)
print(isNarcissisticNumber(100)); // Output: false
```

### `isHappyNumber(int n) -> bool`
Checks if `n` is a happy number. A number is happy if replacing it with the sum of the squares of its digits eventually leads to 1.
```dart
print(isHappyNumber(19)); // Output: true (1²+9²=82 -> 8²+2²=68 -> ... -> 1)
print(isHappyNumber(7));  // Output: true
print(isHappyNumber(4));  // Output: false (enters a cycle: 4->16->37->58->89->145->42->20->4)
```

---
## Statistical Operations
*(Covers functions from `lib/src/math/basic/statistics.dart`)*

### `mean(List<num> list) -> num`
Returns the arithmetic mean (average) of numbers in `list`.
```dart
print(mean([1, 2, 3, 4, 5]));    // Output: 3.0
print(mean([10, 0, 20, -5, 15])); // Output: 8.0
```

### `average(List<num> list) -> num`
Alias for `mean(List<num> list)`.
```dart
print(average([2, 4, 6, 8])); // Output: 5.0
```

### `avg(dynamic ...args) -> dynamic`
A `VarArgsFunction` that returns the average of its arguments.
Arguments can be individual numbers or a single list of numbers.
```dart
print(avg(10, 20, 30));       // Output: 20.0
print(avg([1, 2, 3, 4, 5]));  // Output: 3.0
// print(avg.call([1,2,3,4,5])); // Direct call if needed for VarArgsFunction
```

### `median(List<num> list) -> num`
Returns the median (middle value) of numbers in `list`. Sorts the list first.
```dart
print(median([1, 3, 2, 5, 4]));    // Sorted: [1,2,3,4,5]. Output: 3
print(median([1, 4, 2, 3]));      // Sorted: [1,2,3,4]. Output: 2.5 ((2+3)/2)
```

### `mode(List<num> list) -> List<num>`
Returns a list of modes (most frequent values) in `list`.
```dart
print(mode([1, 2, 2, 3, 3, 3, 4])); // Output: [3]
print(mode([1, 2, 2, 3, 3, 4]));    // Output: [2, 3] (sorted by occurrence if tie-broken by key order)
print(mode([1, 2, 3, 4]));          // Output: [1, 2, 3, 4] (all elements are modes)
```

### `variance(List<num> list) -> double`
Returns the sample variance of numbers in `list`.
```dart
print(variance([1, 2, 3, 4, 5])); // Output: 2.5
// (Mean=3. Deviations: -2,-1,0,1,2. Squared: 4,1,0,1,4. SumSq=10. Variance=10/(5-1)=2.5)
```

### `stdDev(List<num> list) -> double`
Returns the sample standard deviation (square root of variance) of numbers in `list`.
```dart
print(stdDev([1, 2, 3, 4, 5])); // Output: 1.5811388300841898 (sqrt(2.5))
```

### `standardDeviation(List<num> list) -> double`
Alias for `stdDev(List<num> list)`.
```dart
print(standardDeviation([1, 2, 3, 4, 5])); // Output: 1.5811388300841898
```

### `stdErrMean(List<num> list) -> double`
Returns the standard error of the sample mean (SEM = stdDev / sqrt(n)).
Returns 0 if list is empty or has one element.
```dart
print(stdErrMean([1, 2, 3, 4, 5])); // Output: 0.7071067811865476 (1.5811... / sqrt(5))
```

### `stdErrEst(List<num> x, List<num> y) -> double`
Calculates the standard error of the estimate for two lists of numbers, `x` (e.g., predicted values) and `y` (e.g., observed values), typically in regression.
Assumes `x` and `y` have the same length. Formula used: `sqrt( sum( (y[i] - meanY - (x[i] - meanX))^2 ) / (N-2) )`.
This seems to be the standard error of residuals for a simple linear regression where the model is `(y - y_mean) = beta * (x - x_mean) + error`. If `beta=1` (slope is 1), then it's `sqrt( sum( ( (y[i]-y_mean) - (x[i]-x_mean) )^2 ) / (N-2) )`.
```dart
List<num> observed = [2, 4, 5, 4, 5];
List<num> predicted = [1.8, 3.8, 5.2, 4.2, 4.8]; // Example predictions
// print(stdErrEst(predicted, observed)); // Output depends on the formula's exact interpretation in code.
// The source code example "print(stdErrEst([1, 2, 3, 4, 5]));" is incorrect as it needs two lists.
// The formula in code: numerator += pow(y[i] - meanY - (x[i] - meanX), 2);
// This means it calculates residuals for y_i against a model y_i_hat = meanY + (x_i - meanX)
// (assuming a slope of 1 if x and y were centered).
// A more common use involves actual predicted values from a regression model.
// Let's use a simple y=x case.
print(stdErrEst([1,2,3,4,5], [1,2,3,4,5])); // Expected: 0.0
print(stdErrEst([1,2,3,4,5], [1.1,1.9,3.1,3.9,5.1])); // Will be small non-zero
```

### `tValue(List<num> list) -> double`
Returns the t-value for a one-sample t-test against a population mean of 0. Calculated as `mean(list) / stdErrMean(list)`.
Returns 0 if list is empty or has one element.
```dart
print(tValue([1, 2, 3, 4, 5])); // Output: 4.242640687119285 (3.0 / 0.7071...)
```

### `quartiles(List<num> list) -> List<num>`
Returns the 1st quartile (Q1), 2nd quartile (median, Q2), and 3rd quartile (Q3) of numbers in `list`.
Uses a simple method: Q1 is median of lower half, Q3 is median of upper half.
```dart
print(quartiles([1, 2, 3, 4, 5, 6, 7, 8, 9])); // Output: [2.5, 5, 7.5]
// Lower half for Q1: [1,2,3,4], Median = 2.5
// Overall Median Q2: 5
// Upper half for Q3: [6,7,8,9], Median = 7.5

print(quartiles([1,5,2,8,7,3,6,4])); // Sorted: [1,2,3,4,5,6,7,8]
// Lower: [1,2,3,4] -> Q1=2.5
// Median: (4+5)/2 = 4.5
// Upper: [5,6,7,8] -> Q3=6.5
// Output: [2.5, 4.5, 6.5]
```

### `permutations(dynamic n, int r, {Function? func, bool simplify = true, Random? random, int? seed}) -> dynamic`
Generates all permutations of `r` elements taken from `n`.
- `n`: Can be an `int` (generates from `1` to `n`) or a `List` of elements.
- `r`: The number of elements in each permutation.
- `func` (optional): A function to apply to each generated permutation.
- `simplify` (optional, default `true`): If `func` is provided, returns a flat list of `func` results. If `false`, returns list of `[permutation, func_result]`.
- `random`, `seed` (optional): For reproducibility if `func` involves randomness (permutations themselves are generated deterministically in order).
```dart
print(permutations(3, 2));
// Output: [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]] (order may vary)

print(permutations(['A','B'], 2));
// Output: [[A, B], [B, A]]

var products = permutations([1,2,3], 2, func: (p) => (p[0] as num) * (p[1] as num));
print(products); // Output: [2, 3, 2, 6, 3, 6] (order corresponds to permutations)
```

### `combinations(dynamic n, int r, {Function? func, bool simplify = true, bool generateCombinations = true}) -> dynamic`
Generates all combinations of `r` elements taken from `n`.
- `n`: Can be an `int` (generates from `1` to `n`) or a `List`.
- `r`: The number of elements in each combination.
- `func` (optional): Function to apply to each combination.
- `simplify` (optional, default `true`): If `func` provided, controls output structure.
- `generateCombinations` (optional, default `true`): If `false`, returns only the count of combinations.
```dart
print(combinations(4, 3));
// Output: [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]

print(combinations(['A','B','C'], 2));
// Output: [[A, B], [A, C], [B, C]]

var sums = combinations([1,2,3,4], 2, func: (c) => (c[0] as num) + (c[1] as num));
print(sums); // Output: [3, 4, 5, 5, 6, 7]

print(combinations(5, 2, generateCombinations: false)); // Output: 10 (C(5,2))
```

### `gcf(List<num> numbers) -> num`
Calculates the Greatest Common Factor (GCF) of numbers in the `numbers` list. Alias for `gcd`.
```dart
print(gcf([48, 18, 30])); // Output: 6
```

### `gcd(List<num> numbers) -> num`
Returns the Greatest Common Divisor (GCD) of numbers in the `numbers` list. Handles positive numbers.
```dart
print(gcd([48, 180, -30])); // Output: 6 (uses absolute values)
print(gcd([7, 13, 29]));   // Output: 1 (coprime)
```

### `egcd(List<num> numbers) -> List<List<num>>`
Extended Euclidean Algorithm. For each pair of consecutive numbers (a, b) in the input `numbers` list, it finds `[d, x, y]` such that `d = gcd(a, b)` and `a*x + b*y = d`.
Returns a list of such `[d, x, y]` lists.
```dart
print(egcd([48, 18]));    // Output: [[6, -1, 3]]  (48*(-1) + 18*3 = 6)
print(egcd([48, 18, 6])); // Output: [[6, -1, 3], [6, 0, 1]] (for (18,6): 18*0 + 6*1 = 6)
```

### `lcm(List<num> numbers) -> num`
Returns the Least Common Multiple (LCM) of numbers in the `numbers` list.
```dart
print(lcm([4, 6]));    // Output: 12.0
print(lcm([3, 5, 7])); // Output: 105.0
print(lcm([2,4,8]));   // Output: 8.0
```

### `correlation(List<num> x, List<num> y) -> double`
Returns the Pearson correlation coefficient between two lists of numbers, `x` and `y`.
Assumes `x` and `y` have the same length.
```dart
List<num> xVals = [1, 2, 3, 4, 5];
List<num> yVals = [2, 3, 4, 5, 6]; // Perfectly correlated (y = x+1)
print(correlation(xVals, yVals)); // Output: 1.0 (or very close, like 0.999...)

List<num> yValsNeg = [5, 4, 3, 2, 1]; // Perfectly negatively correlated
print(correlation(xVals, yValsNeg)); // Output: -1.0 (or very close)

List<num> yValsUncorr = [2, 4, 1, 5, 3]; // Less correlated
print(correlation(xVals, yValsUncorr)); // Output: e.g., 0.3
```

### `confidenceInterval(List<num> data, double confidenceLevel) -> List<num>`
Returns the confidence interval for the mean of `data`.
**Note:** The `confidenceLevel` parameter is present but **not used** in the current implementation to determine a critical t-value from a T-distribution based on `confidenceLevel`. The margin of error is calculated as `tValue(data) * stdErrMean(data)`, where `tValue` is simply `mean / stdErrMean`. This is not a standard confidence interval calculation.
```dart
// The result of this function should be interpreted with caution due to its non-standard formula.
// It effectively calculates [mean - (mean/stdErrMean)*stdErrMean, mean + (mean/stdErrMean)*stdErrMean]
// which simplifies to [mean - mean, mean + mean] = [0, 2*mean] if stdErrMean is not zero.
// This is not a statistically standard confidence interval.
print(confidenceInterval([1, 2, 3, 4, 5], 0.95));
// mean=3, stdErrMean=0.7071..., tValue=4.2426...
// margin = 3.0
// Output: [0.0, 6.0]
```

### `regression(List<num> x, List<num> y) -> List<num>`
Performs a simple linear regression for `y` on `x`.
Returns `[m, b]` where `m` is the slope and `b` is the y-intercept of the line `y = mx + b`.
Assumes `x` and `y` have the same length.
```dart
List<num> xReg = [1, 2, 3, 4, 5];
List<num> yReg = [2, 4.1, 5.9, 8.2, 9.8]; // Approx y = 2x
var result = regression(xReg, yReg);
print('Slope: ${result[0]}, Intercept: ${result[1]}');
// Output: Slope: 1.9300000000000002, Intercept: 0.13999999999999968 (approx y = 1.93x + 0.14)
```

---
## Mathematical Constants
*(Covers constants from `lib/src/math/basic/constants.dart`)*

### General Constants

-   **`pi: double`**: The mathematical constant Pi (π). Ratio of a circle's circumference to its diameter.
    Value: `3.141592653589793`
-   **`e: double`**: The mathematical constant e, the base of natural logarithms.
    Value: `2.718281828459045`
-   **`ln10: double`**: Natural logarithm of 10 (ln(10)).
    Value: `2.302585092994046`
-   **`ln2: double`**: Natural logarithm of 2 (ln(2)).
    Value: `0.6931471805599453`
-   **`log2e: double`**: Base-2 logarithm of e (log<sub>2</sub>(e)).
    Value: `1.4426950408889634`
-   **`log10e: double`**: Base-10 logarithm of e (log<sub>10</sub>(e)).
    Value: `0.4342944819032518`
-   **`sqrt1_2: double`**: Square root of 1/2 (1/√2).
    Value: `0.7071067811865476`
-   **`sqrt2: double`**: Square root of 2 (√2).
    Value: `1.4142135623730951`
-   **`sqrt3: double`**: Square root of 3 (√3).
    Value: `1.7320508075688`

### Angle Constants
Defined in `AngleConstants` class.
-   **`AngleConstants.pi: double`**: Pi (π), `3.14159265358979323846`.
-   **`AngleConstants.tau: double`**: Tau (τ = 2π), `6.28318530717958647692`.
-   **`AngleConstants.halfPi: double`**: π/2, `1.57079632679489661923`.
-   **`AngleConstants.quarterPi: double`**: π/4, `0.78539816339744830962`.
-   **`AngleConstants.piOver180: double`**: Conversion factor degrees to radians (π/180), `0.01745329251994329576`.
-   **`AngleConstants.d180OverPi: double`**: Conversion factor radians to degrees (180/π), `57.2957795130823208768`.

### Physics Constants
Defined in `PhysicsConstants` class. Values are in SI units.
-   **`PhysicsConstants.speedOfLight: double`**: Speed of light in vacuum (c). Value: `299792458.0` m/s.
-   **`PhysicsConstants.planckConstant: double`**: Planck constant (h). Value: `6.62607015e-34` J·s.
-   **`PhysicsConstants.reducedPlanckConstant: double`**: Reduced Planck constant (ħ = h/2π). Value: `1.054571817...e-34` J·s.
-   **`PhysicsConstants.gravitationalConstant: double`**: Gravitational constant (G). Value: `6.67430e-11` m³·kg⁻¹·s⁻².
-   **`PhysicsConstants.standardGravity: double`**: Standard acceleration due to gravity on Earth (g). Value: `9.80665` m/s².
-   **`PhysicsConstants.boltzmannConstant: double`**: Boltzmann constant (k<sub>B</sub>). Value: `1.380649e-23` J/K.
-   **`PhysicsConstants.electronMass: double`**: Electron mass (m<sub>e</sub>). Value: `9.10938356e-31` kg.
-   **`PhysicsConstants.protonMass: double`**: Proton mass (m<sub>p</sub>). Value: `1.672621898e-27` kg.
-   **`PhysicsConstants.neutronMass: double`**: Neutron mass (m<sub>n</sub>). Value: `1.674927471e-27` kg.
-   **`PhysicsConstants.elementaryCharge: double`**: Elementary charge (e). Value: `1.602176634e-19` C.
-   **`PhysicsConstants.avogadrosNumber: double`**: Avogadro's number (N<sub>A</sub>). Value: `6.02214076e23` mol⁻¹.
-   **`PhysicsConstants.gasConstant: double`**: Ideal gas constant (R). Value: `8.314462618` J·mol⁻¹·K⁻¹.
-   **`PhysicsConstants.stefanBoltzmannConstant: double`**: Stefan-Boltzmann constant (σ). Value: `5.670374419e-8` W·m⁻²·K⁻⁴.

---
## Trigonometric Functions
*(Covers functions from `lib/src/math/basic/trigonometry.dart`)*
These functions operate on `num` or `Complex` inputs and generally return `double` or `Complex` results. Angles are in radians unless specified.

### Standard Trigonometric Functions
-   **`sin(dynamic x) -> dynamic`**: Sine of `x`.
    ```dart
    print(sin(pi / 2)); // Output: 1.0
    // print(sin(Complex(0,1))); // Output: 0.0 + 1.1752...i (sinh(1)*i)
    ```
-   **`cos(dynamic x) -> dynamic`**: Cosine of `x`.
    ```dart
    print(cos(pi)); // Output: -1.0
    // print(cos(Complex(0,1))); // Output: 1.543... + 0.0i (cosh(1))
    ```
-   **`tan(dynamic x) -> dynamic`**: Tangent of `x`.
    ```dart
    print(tan(pi / 4)); // Output: 0.9999999999999999 (approx 1.0)
    ```
-   **`sec(dynamic x) -> dynamic`**: Secant of `x` (1/cos(x)).
    ```dart
    print(sec(pi / 3)); // Output: 2.0000000000000004 (approx 2.0)
    ```
-   **`csc(dynamic x) -> dynamic`**: Cosecant of `x` (1/sin(x)).
    ```dart
    print(csc(pi / 2)); // Output: 1.0
    ```
-   **`cot(dynamic x) -> dynamic`**: Cotangent of `x` (1/tan(x)).
    ```dart
    print(cot(pi / 4)); // Output: 1.0
    ```

### Inverse Trigonometric Functions
-   **`asin(dynamic x) -> dynamic`**: Arcsine (inverse sine) of `x`. Result in radians. For `num` inputs outside [-1,1], returns `Complex`.
    ```dart
    print(asin(1));    // Output: 1.5707... (pi/2)
    // print(asin(2));    // Output: Complex(1.5707..., -1.3169...)
    ```
-   **`acos(dynamic x) -> dynamic`**: Arccosine (inverse cosine) of `x`. Result in radians. For `num` inputs outside [-1,1], returns `Complex`.
    ```dart
    print(acos(-1));   // Output: 3.1415... (pi)
    // print(acos(2));    // Output: Complex(0.0, -1.3169...)
    ```
-   **`atan(dynamic x) -> dynamic`**: Arctangent (inverse tangent) of `x`. Result in radians.
    ```dart
    print(atan(1));    // Output: 0.7853... (pi/4)
    ```
-   **`atan2(dynamic a, dynamic b) -> dynamic`**: Angle whose tangent is `a/b`. Result in radians, range (-π, π]. Handles `num` and `Complex`.
    ```dart
    print(atan2(1, 1));  // Output: 0.7853... (pi/4)
    print(atan2(1, -1)); // Output: 2.3561... (3pi/4)
    ```
-   **`asec(dynamic x) -> dynamic`**: Arcsecant of `x`. Throws `ArgumentError` if `abs(x) < 1` for `num`.
    ```dart
    print(asec(2));    // Output: 1.0471... (pi/3)
    ```
-   **`acsc(dynamic x) -> dynamic`**: Arccosecant of `x`. Throws `ArgumentError` if `abs(x) < 1` for `num`.
    ```dart
    print(acsc(2));    // Output: 0.5235... (pi/6)
    ```
-   **`acot(dynamic x) -> dynamic`**: Arccotangent of `x`.
    ```dart
    print(acot(1));    // Output: 0.7853... (pi/4)
    ```

### Hyperbolic Trigonometric Functions
-   **`sinh(dynamic x) -> dynamic`**: Hyperbolic sine of `x`.
    ```dart
    print(sinh(1)); // Output: 1.1752011936438014
    ```
-   **`cosh(dynamic x) -> dynamic`**: Hyperbolic cosine of `x`.
    ```dart
    print(cosh(1)); // Output: 1.5430806348152437
    ```
-   **`tanh(dynamic x) -> dynamic`**: Hyperbolic tangent of `x`.
    ```dart
    print(tanh(1)); // Output: 0.7615941559557649
    ```
-   **`sech(dynamic x) -> dynamic`**: Hyperbolic secant of `x` (1/cosh(x)).
    ```dart
    print(sech(1)); // Output: 0.6480542736638853
    ```
-   **`csch(dynamic x) -> dynamic`**: Hyperbolic cosecant of `x` (1/sinh(x)).
    ```dart
    print(csch(1)); // Output: 0.8509181282393215
    ```
-   **`coth(dynamic x) -> dynamic`**: Hyperbolic cotangent of `x` (1/tanh(x)).
    ```dart
    print(coth(1)); // Output: 1.3130352854993312
    ```

### Inverse Hyperbolic Trigonometric Functions
These typically operate on `num` and return `double`.
-   **`asinh(num x) -> double`**: Inverse hyperbolic sine of `x`.
    ```dart
    print(asinh(1.1752011936438014)); // Output: 1.0 (approx)
    ```
-   **`acosh(num x) -> double`**: Inverse hyperbolic cosine of `x`. Throws `ArgumentError` if `x < 1`.
    ```dart
    print(acosh(1.5430806348152437)); // Output: 1.0 (approx)
    ```
-   **`atanh(num x) -> double`**: Inverse hyperbolic tangent of `x`. Throws `ArgumentError` if `abs(x) >= 1`.
    ```dart
    print(atanh(0.7615941559557649)); // Output: 1.0 (approx)
    ```
-   **`asech(num x) -> double`**: Inverse hyperbolic secant of `x`. `x` must be in `(0, 1]`.
    ```dart
    print(asech(0.6480542736638853)); // Output: 1.0 (approx)
    ```
-   **`acsch(num x) -> double`**: Inverse hyperbolic cosecant of `x`. `x` must not be 0.
    ```dart
    print(acsch(0.8509181282393215)); // Output: 1.0 (approx)
    ```
-   **`acoth(num x) -> double`**: Inverse hyperbolic cotangent of `x`. `abs(x)` must be `> 1`.
    ```dart
    print(acoth(1.3130352854993312)); // Output: 1.0 (approx)
    ```

### Other Trigonometric-Related Functions
These operate on `num` and return `double`.
-   **`vers(num x) -> double`**: Versine of `x` (1 - cos(x)).
    ```dart
    print(vers(pi / 2)); // Output: 1.0
    ```
-   **`covers(num x) -> double`**: Coversine of `x` (1 - sin(x)).
    ```dart
    print(covers(pi / 2)); // Output: 0.0
    ```
-   **`havers(num x) -> double`**: Haversine of `x` ((1 - cos(x)) / 2).
    ```dart
    print(havers(pi)); // Output: 1.0
    ```
-   **`exsec(num x) -> double`**: Exsecant of `x` (sec(x) - 1).
    ```dart
    print(exsec(pi/3)); // Output: 1.0 (sec(pi/3)=2)
    ```
-   **`excsc(num x) -> double`**: Excosecant of `x` (csc(x) - 1).
    ```dart
    print(excsc(pi/6)); // Output: 1.0 (csc(pi/6)=2)
    ```
-   **`sawtooth(num x) -> double`**: Sawtooth wave function. Returns fractional part of `x`.
    ```dart
    print(sawtooth(2.7));  // Output: 0.7000000000000002
    ```
-   **`squareWave(double x) -> int`**: Square wave function. Alternates between -1 and 1 with period 2.
    ```dart
    print(squareWave(0.5)); // Output: -1
    print(squareWave(1.5)); // Output: 1
    ```
-   **`triangleWave(double x) -> double`**: Triangle wave function. Oscillates between -1 and 1 with period 1.
    ```dart
    print(triangleWave(0.25)); // Output: 1.0
    print(triangleWave(0.75)); // Output: -1.0
    ```

---
## Logarithmic Functions
*(Covers functions from `lib/src/math/basic/logarithm.dart`)*
These functions handle `num`, `Decimal`, `Complex`, and `Imaginary` inputs.

### `log10(dynamic x) -> dynamic`
Returns the base-10 logarithm of `x`.
```dart
print(log10(100));    // Output: 2.0
// print(log10(Complex(100,0))); // Output: 2.0 + 0.0i
```

### `log(dynamic x, [dynamic base]) -> dynamic`
Returns the logarithm of `x`.
- If `base` (`b`) is provided, computes log base `b` of `x`.
- If `base` is null, computes the natural logarithm (base e) of `x`.
Throws `ArgumentError` if `x` or numeric `base` is `<= 0`.
```dart
print(log(100, 10)); // Output: 2.0
print(log(e));       // Output: 1.0 (natural log)
// print(log(Complex(e*e, 0))); // Output: 2.0 + 0.0i
```

### `logBase(dynamic base, dynamic x) -> dynamic`
Returns the logarithm of `x` to the given `base`. This is an alternative way to call `log(x, base)`.
```dart
print(logBase(2, 8));     // Output: 3.0
// print(logBase(Complex(10,0), Complex(100,0))); // Output: 2.0 + 0.0i
```

---
## Random Number Generation
*(Covers `Random` class and utilities from `lib/src/math/basic/math.dart`)*

This section covers the `Random` class for generating various types of random data and utility functions for common random generation tasks.

### The `Random` Class
A generator of random byte, bool, int, BigInt, or double values. The default implementation is not cryptographically secure. Use `Random.secure()` for cryptographic purposes.

**Constructors:**
- `Random([int? seed])`: Creates a pseudo-random number generator. An optional `seed` can be provided to produce a deterministic sequence of numbers.
- `Random.secure()`: Creates a cryptographically secure random number generator. Throws `UnsupportedError` if a secure source is unavailable.

**Methods:**

#### `nextBool() -> bool`
Returns the next pseudo-random, uniformly distributed boolean value.
```dart
var boolValue = Random().nextBool(); // true or false
print(boolValue);
```

#### `nextDouble() -> double`
Returns the next pseudo-random, uniformly distributed double value between 0.0 (inclusive) and 1.0 (exclusive).
```dart
var doubleValue = Random().nextDouble(); // e.g., 0.738
print(doubleValue);
```

#### `nextInt(int max) -> int`
Returns a non-negative pseudo-random integer uniformly distributed in the range from 0 (inclusive) to `max` (exclusive).
```dart
var intValue = Random().nextInt(10); // Value is >= 0 and < 10.
print(intValue);
```

#### `nextBytes(int length) -> Uint8List`
Generates a list of `length` random bytes. Each byte is a random integer from 0 to 255.
```dart
var bytes = Random().nextBytes(5); // Generates 5 random bytes.
print(bytes); // e.g., [138, 20, 253, 12, 87]
```

#### `nextNonZeroByte() -> int`
Generates a random byte (0-255) that is guaranteed not to be zero.
```dart
var nonZeroByte = Random().nextNonZeroByte();
print('Random non-zero byte: $nonZeroByte'); // e.g., 173
```

#### `nextBytesInRange(int min, int max, int length) -> Uint8List`
Generates a list of `length` random bytes, where each byte is a random integer in the range [`min`, `max`).
```dart
var bytes = Random().nextBytesInRange(10, 20, 3); // 3 bytes, each >= 10 and < 20.
print('Random bytes in range [10, 20): $bytes');
```

#### `nextIntInRange(int min, int max) -> int`
Generates a random integer in the range [`min`, `max`).
```dart
var intValue = Random().nextIntInRange(50, 55); // Value is >= 50 and < 55.
print(intValue);
```

#### `nextDoubleInRange(double min, double max) -> double`
Generates a random double in the range [`min`, `max`).
```dart
var doubleValue = Random().nextDoubleInRange(10.0, 10.5); // Value is >= 10.0 and < 10.5.
print(doubleValue);
```

#### `nextBigInt(BigInt max) -> BigInt`
Generates a random `BigInt` less than `max` using hex string parsing for uniform distribution.
```dart
var bigIntValue = Random().nextBigInt(BigInt.from(1000000));
print(bigIntValue); // e.g., 734583
```
_Note: `nexBigInt2(BigInt max)` is an alternative implementation using direct byte accumulation, also present in the source, which might have different distribution properties, especially if `max` is not a power of 2._

#### `nextBigIntInRange(BigInt min, BigInt max) -> BigInt`
Generates a random `BigInt` in the range [`min`, `max`).
```dart
var val = Random().nextBigIntInRange(BigInt.from(10).pow(9), BigInt.from(10).pow(9) + BigInt.from(100));
print(val); // A BigInt between 10^9 and 10^9 + 99
```

#### `nextBigIntWithBitLength(int bitLength) -> BigInt`
Generates a random `BigInt` with a specified `bitLength`. The value will be in the range [2<sup>(bitLength-1)</sup>, 2<sup>bitLength</sup> - 1]. Throws `ArgumentError` if `bitLength <= 0`.
```dart
var bigIntValue = Random().nextBigIntWithBitLength(10); // A 10-bit random BigInt
print(bigIntValue); // e.g., a number between 512 and 1023
```

#### `nextElementFromList<T>(List<T> list) -> T`
Randomly selects an element from the provided `list`. Throws `ArgumentError` if the list is empty.
```dart
var list = ['apple', 'banana', 'cherry'];
var randomElement = Random().nextElementFromList(list);
print('Randomly selected element: $randomElement');
```

#### `nextString(int length, {String charset = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'}) -> String`
Generates a random string of `length` characters from the given `charset`.
```dart
var randomString = Random().nextString(10);
print(randomString); // e.g., "aK3pL9sX7q"

var hexString = Random().nextString(8, charset: '0123456789abcdef');
print(hexString); // e.g., "3f7a1b9c"
```

#### `nextDateTime(DateTime min, DateTime max) -> DateTime`
Generates a random `DateTime` within the given range [`min`, `max`). `min` must be before `max`.
```dart
var randomDate = Random().nextDateTime(DateTime(2023, 1, 1), DateTime(2023, 12, 31));
print(randomDate); // e.g., 2023-07-15 10:35:22.123Z
```

#### `nextGaussian({double mean = 0.0, double stddev = 1.0}) -> double`
Generates a random number from a Gaussian (normal) distribution with specified `mean` and standard deviation `stddev`. Uses the Box-Muller transform.
```dart
var gaussianValue = Random().nextGaussian(mean: 5.0, stddev: 1.5);
print(gaussianValue); // e.g., 5.83 or 3.97
```

#### `nextUUID() -> String`
Generates a random Version 4 UUID (Universally Unique Identifier).
```dart
var uuid = Random().nextUUID();
print(uuid); // e.g., "f47ac10b-58cc-4372-a567-0e02b2c3d479"
```

#### `nextNonRepeatingIntList(int min, int max, int length) -> List<int>`
Generates a list of `length` unique random integers within the range [`min`, `max`).
Throws `ArgumentError` if the range `max - min` is smaller than `length`.
```dart
var uniqueInts = Random().nextNonRepeatingIntList(1, 10, 5); // 5 unique ints from 1 to 9
print(uniqueInts); // e.g., [3, 7, 1, 9, 4] (order may vary)
```

#### `shuffleList<T>(List<T> list) -> List<T>`
Shuffles the provided `list` in place using the Fisher-Yates algorithm and returns the (same) shuffled list.
```dart
var list = [1, 2, 3, 4, 5];
Random().shuffleList(list);
print('Shuffled list: $list'); // e.g., [3, 1, 5, 2, 4]
```

### Utility Random Functions
These top-level functions typically use a default `Random` instance but can accept a custom `AbstractRandomProvider` for more control over the source of randomness.

#### `randomBetween(int from, int to, {AbstractRandomProvider? provider}) -> int`
Generates a random integer between `from` (inclusive) and `to` (inclusive).
```dart
print(randomBetween(5, 10)); // Random integer between 5 and 10
```

#### `randomString(int length, CharacterType type, {AbstractRandomProvider? provider}) -> String`
Generates a random string of `length` using characters specified by `CharacterType`.
- `CharacterType` enum values: `numeric`, `lowerAlpha`, `upperAlpha`, `ascii` (printable ASCII from 33 to 126).
```dart
print(randomString(5, CharacterType.lowerAlpha)); // e.g., "qwert"
print(randomString(3, CharacterType.numeric));    // e.g., "731"
print(randomString(4, CharacterType.ascii));      // e.g., "%T#v"
```

#### `randomNumeric(int length, {AbstractRandomProvider? provider}) -> String`
Generates a random numeric string (digits 0-9) of the specified `length`.
```dart
print(randomNumeric(5)); // e.g., "03729"
```

#### `randomAlpha(int length, {AbstractRandomProvider? provider}) -> String`
Generates a random alphabetic string (mixed upper and lower case) of the specified `length`.
```dart
print(randomAlpha(10)); // e.g., "aBcXyZpqRs"
```

#### `randomAlphaNumeric(int length, {AbstractRandomProvider? provider}) -> String`
Generates a random alphanumeric string (mixed case letters and digits) of the specified `length`.
```dart
print(randomAlphaNumeric(8)); // e.g., "aB1xYz9P"
```

#### `randomMerge(String a, String b) -> String`
Merges two strings `a` and `b`, shuffles their combined characters, and returns the result.
```dart
print(randomMerge("abc", "123")); // e.g., "a1b2c3" or "3cba21" etc.
```

### Random Providers
The library defines an `AbstractRandomProvider` interface and provides implementations for more control over randomness:
- `DefaultRandomProvider`: Uses the standard `dart:math Random()`.
- `SeededRandomProvider(int seed)`: Uses `dart:math Random(seed)` for deterministic sequences.
- `CryptographicRandomProvider`: Uses `Random.secure()` for cryptographically strong random numbers.
These can be passed to the utility functions like `randomBetween` or `randomString`.

---
## Execution Time Measurement
*(Covers `time` and `timeAsync` from `lib/src/math/basic/math.dart`)*

This section describes functions used for measuring the execution time of synchronous and asynchronous code.

### `time<T>(dynamic functionOrValue) -> ({T result, Duration elapsed})`
Measures the execution time of a synchronous function, expression, or computation. It returns a record containing the `result` of the computation and the `elapsed` time as a `Duration`.

This function can be used in several ways:
1.  **With a function reference**: Pass a zero-argument function.
    ```dart
    final timedResult = time(() => factorial(20)); // factorial is defined in basic.dart
    print('Result: ${timedResult.result}, Time: ${timedResult.elapsed.inMicroseconds}µs');
    ```
2.  **With a direct expression/value**: Pass the value directly. The `elapsed` time will be `Duration.zero` as the expression is evaluated before `time()` is called. To measure, wrap it in a function.
    ```dart
    final resultFact20 = factorial(20);
    final timedResult = time(resultFact20);
    print('Result: ${timedResult.result}, Time: ${timedResult.elapsed.inMicroseconds}µs'); // Elapsed will be ~0
    ```
3.  **With a callback that receives a `measure` function**: This allows measuring multiple sub-operations within the main timed block. The `measure` function itself prints the duration of sub-operations.
    ```dart
    // Example function for sub-operation
    String operation1() {
      // Simulate work
      for(int i=0; i<100000; i++){}
      return "Op1 Done";
    }
    final timedResult = time((measure) {
      final a = measure(() => operation1())(); // Note the extra () to call the wrapped function
      // final b = measure(anotherOperation)(argForAnother);
      return a;
    });
    print('Overall Result: ${timedResult.result}, Overall Time: ${timedResult.elapsed.inMicroseconds}µs');
    // 'Operation took: XXXµs' will also be printed by the measure function for operation1.
    ```

The `Duration` can be inspected using properties like `inMicroseconds`, `inMilliseconds`, `inSeconds`.

### `timeAsync<T>(dynamic functionOrValue) async -> ({T result, Duration elapsed})`
Measures the execution time of an asynchronous function or computation. It returns a `Future` that resolves to a record containing the `result` and the `elapsed` time as a `Duration`.

Usage is similar to the synchronous `time` function but for asynchronous operations:
1.  **With an async function reference**:
    ```dart
    Future<String> fetchData() async {
      await Future.delayed(Duration(milliseconds: 50));
      return "Data fetched";
    }

    final timedResult = await timeAsync(() => fetchData());
    print('Async Result: ${timedResult.result}, Async Time: ${timedResult.elapsed.inMilliseconds}ms');
    ```
2.  **With an async callback that receives a `measure` function**:
    ```dart
    Future<String> step1() async { await Future.delayed(Duration(milliseconds: 20)); return "Step1 Done"; }
    Future<String> step2(String prev) async { await Future.delayed(Duration(milliseconds: 30)); return "$prev, Step2 Done"; }

    final timedResult = await timeAsync((measure) async {
      final result1 = await measure(() => step1())(); // measure returns a Future<R> Function()
      final result2 = await measure(() => step2(result1))();
      return result2;
    });
    print('Overall Async Result: ${timedResult.result}, Overall Async Time: ${timedResult.elapsed.inMilliseconds}ms');
    // 'Async operation took: XXXµs' will also be printed for step1 and step2.
    ```
