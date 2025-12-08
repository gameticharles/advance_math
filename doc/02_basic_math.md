# Basic Math Module

Core mathematical functions, number types, utilities, and helper functions.

---

## Table of Contents

1. [Complex Numbers](#complex-numbers)
2. [Imaginary Numbers](#imaginary-numbers)
3. [Fractions](#fractions)
4. [Range](#range)
5. [Domain](#domain)
6. [Random Numbers](#random-numbers)
7. [Prime Numbers](#prime-numbers)
8. [GCD, LCM, Extended GCD](#gcd-lcm-extended-gcd)
9. [Modular Arithmetic](#modular-arithmetic)
10. [Combinations and Permutations](#combinations-and-permutations)
11. [Numerical Integration](#numerical-integration)
12. [Coordinate Conversion](#coordinate-conversion)
13. [Memoization](#memoization)
14. [VarArgsFunction](#varargsfunction)
15. [Extensions](#extensions)

---

## Complex Numbers

### Creating Complex Numbers

```dart
import 'package:advance_math/advance_math.dart';

// From real and imaginary parts
var c1 = Complex(3, 4);        // 3 + 4i
var c2 = Complex(2.5, -1.5);   // 2.5 - 1.5i

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
```

### Parsing Complex Numbers

```dart
// Basic parsing
print(Complex.parse('-5 - 6i'));      // -5 - 6i
print(Complex('7+0i'));                // 7
print(Complex('3+4i'));                // 3 + 4i
print(Complex('1-i'));                 // 1 - i
print(Complex('i'));                   // i
print(Complex('-i'));                  // -i

// From two arguments
print(Complex('-2.5', '3.7'));         // -2.5 + 3.7i

// Fractional formats
print(Complex('3/2+5/4i'));            // 1.5 + 1.25i
print(Complex.parse('3/4+5/2i'));      // 0.75 + 2.5i

// Mixed formats with constants
print(Complex('-√3+2πi'));             // -1.732... + 6.283...i
print(Complex.parse('π+ei'));          // 3.1415... + 2.7182...i
print(Complex.parse('√2-i'));          // 1.4142... - i

// Scientific notation
print(Complex.parse('1e3 + 2.5e-2i')); // 1000 + 0.025i
print(Complex('1.2e3+3.4e-5i'));       // 1200 + 0.000034i
```

### Complex from Complex Components

```dart
// z = (a + bi) + (c + di)i = (a - d) + (b + c)i
var result = Complex(Complex(5, -1), Complex(2, 2));
print(result);  // 3 + 1i

// Copy constructor
var a = Complex(2, 5);
var b = Complex(a);
print(b);  // 2 + 5i

// Complex real + num imaginary
print(Complex(Complex(2, 3), 4));  // 2 + 7i

// Num real + complex imaginary
print(Complex(5, Complex(1, 2)));  // 3 + 1i

// Mixed real/imaginary components
print(Complex(Complex(2, 3), Complex(4, 5)));  // -3 + 7i
print(Complex('3+2i', '5-4i'));                // 7 + 7i
```

### Arithmetic Operations

```dart
var a = Complex(3, 4);
var b = Complex(1, 2);

print(a + b);   // 4 + 6i
print(a - b);   // 2 + 2i
print(a * b);   // -5 + 10i
print(b / a);   // 0.44 + 0.08i

// With scalars
print(a + 5);   // 8 + 4i

// Inverse (reciprocal)
print(~a);      // 0.12 - 0.16i (1/a)
```

### Properties

```dart
var z = Complex(3, 4);

print(z.real);             // 3.0
print(z.imaginary);        // 4.0
print(z.abs());            // 5.0 (magnitude)
print(z.modulus);          // 5.0
print(z.complexModulus);   // Complex modulus
print(z.argument());       // 0.927... (phase angle)
print(z.conjugate());      // 3 - 4i

// Check properties
print(z.isReal);           // false
print(z.isImaginary);      // false
print(z.isZero);           // false
print(z.isNaN);            // false
print(z.isInfinite);       // false
```

### Type Simplification

```dart
// Real-only complex numbers simplify to num
var c1 = Complex(2, 0);
print(c1);                     // 2
print(c1 == 2);                // true
print(c1.value.runtimeType);   // int

var c2 = Complex(2.5, 0);
print(c2);                     // 2.5
print(c2 == 2.5);              // true
print(c2.value.runtimeType);   // double

// Arithmetic maintains simplification
final sum = Complex(3, 0) + Complex(4, 0);
print(sum);                    // 7
print(sum.value.runtimeType);  // int
```

### Formatting

```dart
var c = Complex(3, 4);

print(c.toString());           // 3 + 4i
print(c.toStringAsFixed(2));   // 3.00 + 4.00i
print(c.toStringAsFraction()); // 3 + 4i

var c2 = Complex(2.5, 0);
print(c2.toStringAsFraction()); // 2 1/2
```

### Conversion

```dart
print(Complex(3, 0).toInt());              // 3
print(Complex(3.5, 0).toInt());            // 3
print(Complex(3, 1e-16).toInt());          // 3 (near-zero imaginary)
print(Complex.parse('0.5+0.5i').toNum());  // throws (has imaginary part)
```

### Special Values (Infinity, NaN)

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
print(infInf + oneInf);                   // Complex with infinity
print(Complex.zero() / Complex.zero());   // NaN
```

---

## Imaginary Numbers

Pure imaginary number class:

```dart
var i = Imaginary(1);    // 1i
var j = Imaginary(2);    // 2i

print(i + j);            // 3i
print(i * j);            // -2 (real number, i*i = -1)
print(i / j);            // 0.5 (real number)
print(i - j);            // -1i

// Convert to Complex
var complex = i.toComplex();  // 0 + 1i
```

---

## Fractions

```dart
print(Fraction(5, 15).simplify());              // 1/3
print(Fraction.tryParse("4 8/2")!.simplify());  // 8
print(Fraction.tryParse("4 8/2")!.isImproper()); // true
```

---

## Range

Python-like range iteration with lazy evaluation.

### Basic Range

```dart
// Standard range (exclusive end)
var r1 = Range(0, 10, 2);
print(r1.toList());  // [0, 2, 4, 6, 8]

// Parse from string (Python slice notation)
var r = Range.parse("0:10:2");
print(r.toList());  // [0, 2, 4, 6, 8]
```

### Floating Point Ranges

```dart
// Negative step (countdown)
var r2 = Range(10, 8, -0.5);
print(r2.toList());  // [10, 9.5, 9.0, 8.5]
```

### Linspace

```dart
// Get evenly spaced points
var r3 = Range.linspace(0, 1, 5);
print(r3.toList());  // [0.0, 0.25, 0.5, 0.75, 1.0]
```

### Efficient Operations (No Loops)

```dart
// Large ranges are memory-efficient
var hugeRange = Range(0, 1000000000, 5);
print(hugeRange.length);        // Instant calculation
print(hugeRange.contains(500)); // true (Instant)
print(hugeRange.contains(501)); // false (Instant)

// Statistical operations
print(hugeRange.sum);
print(hugeRange.average);
```

### Random Element

```dart
var r = Range(0, 100, 5);
print(r.random());  // Returns 0, 5, 10, 15... (valid step value)
// Never returns 43, because 43 is not in the step sequence
```

### Array Slicing

```dart
final items = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];

// Python: items[::-2] (reversed, skip every 2nd)
final indices = Range.bounds(items.length, "::-2");
print("Indices: $indices");  // Range(6, -1, step: -2)

var result = indices.map((i) => items[i.toInt()]).toList();
print(result);  // [G, E, C, A]
```

### Iterable Features

```dart
var r = Range(0, 10);

// Use map, where, reduce
var sum = r.where((n) => n % 2 == 0).reduce((a, b) => a + b);
print(sum);  // Sum of even numbers
```

### Async Stream

```dart
// Countdown with delay
final countdown = Range(10, 0, -1);
await for (final n in countdown.toStream(interval: Duration(seconds: 1))) {
  print("T-minus $n");
}
print("Liftoff!");
```

---

## Domain

Map values between domains (useful for data visualization).

```dart
// Define data bounds (e.g., Temperature from -10 to 40)
final dataDomain = Domain(-10, 40);

// Define screen size (e.g., 300 pixels wide)
final screenDomain = Domain(0, 300);

// Map a value
double temperature = 15;
double pixelX = dataDomain.mapTo(temperature, screenDomain);
print("Draw point at x: $pixelX");  // 150.0 (middle)
```

---

## Random Numbers

### Basic Random

```dart
var random = Random(123);  // With seed

// Random bytes
var bytes = random.nextBytes(10);
print('Random bytes: $bytes');

// Random in range
var randomInt = random.nextIntInRange(100, 200);
var randomDouble = random.nextDoubleInRange(0.0, 1.0);

// Random BigInt
var bigIntValue = random.nextBigIntInRange(BigInt.from(10), BigInt.from(100));

// Random element from list
var list = ['apple', 'banana', 'cherry', 'date'];
var element = random.nextElementFromList(list);

// Gaussian distribution
var gaussianValue = random.nextGaussian(mean: 10.0, stddev: 2.0);

// UUID
var rand = Random.secure();
print('UUID: ${rand.nextUUID()}');
```

### Cryptographic Random

```dart
AbstractRandomProvider provider = CryptographicRandomProvider();

print('Random Numeric: ${randomNumeric(10, provider: provider)}');
print('Random Alpha: ${randomAlpha(10, provider: provider)}');
print('Random AlphaNumeric: ${randomAlphaNumeric(10, provider: provider)}');
```

---

## Prime Numbers

```dart
print(isPrime(5));                    // true (int)
print(isPrime(6));                    // false (int)
print(isPrime(BigInt.from(1433)));    // true (BigInt)
print(isPrime('567887653'));          // true (String)
print(isPrime('75611592179197710042')); // false (String)

// Large prime
print(isPrime('205561530235962095930138512256047424384916810786171737181163'));
// true

// nth prime
print(nthPrime(2));   // 3 (2nd prime)
print(nthPrime(10));  // 29 (10th prime)
```

### Prime Factors

```dart
int number = 35;
print('Prime factors of $number: ${primeFactors(number)}');  // [5, 7]
print('Factors of $number: ${factors(number)}');              // [1, 5, 7, 35]
```

---

## GCD, LCM, Extended GCD

```dart
// LCM
print(lcm([15, 20]));  // 60

// GCF (Greatest Common Factor)
print(gcf([10, 20, 15]));  // 5

// GCD (supports negative and decimals)
print(gcd([-4.5, 18]));       // 4.5
print(gcd([-12, -18, -24]));  // 6

// Extended GCD (with Bézout coefficients)
print(egcd([-4.5, 18.0]));    // [[4.5, -1, 1]]
print(egcd([-9, 36.0]));      // [[9, -1, 1]]
print(egcd([-12, -18, -24])); // [[6, 1, 0], [6, 1, 0]]
print(egcd([48, 18, 24]));    // [[6, -1, 3], [6, -1, 1]]
```

---

## Modular Arithmetic

### Modular Inverse

```dart
// 2*3 mod 5 = 1, so modInv(2,5) = 3
print(modInv(2, 5));   // 3

// No inverse exists: 4*x mod 18 ≠ 1
print(modInv(4, 18));  // null
```

### Binomial Coefficients Mod Prime

```dart
int N = 500;
int R = 250;
int P = 1000000007;  // Large prime

var result = bigIntNChooseRModPrime(N, R, P);
print(result);  // 515561345

var result2 = nChooseRModPrime(N, R, P);
print(result2);  // 515561345

print(nChooseRModPrime(5, 2, 13));   // 10
print(nChooseRModPrime(10, 3, 17));  // 1
```

---

## Combinations and Permutations

### Combinations

```dart
List<int> numbers = [1, 2, 3];
int m = 2;

// Get all combinations of 2 elements
var combinationsList = combinations(numbers, m);
print(combinationsList);  // [[1, 2], [1, 3], [2, 3]]

// With function applied
var sums = combinations(numbers, m, func: (comb) => comb.reduce((a, b) => a + b));
print(sums);  // [3, 4, 5]

// With integers (generates 1 to n)
var cc = combinations(4, 3, simplify: true, func: (comb) => comb.reduce((a, b) => a + b));
print(cc);  // [6, 7, 8, 9]

// String elements
print(combinations(["A", "B", "C", "D"], 2, generateCombinations: true));
// [[A, B], [A, C], [A, D], [B, C], [B, D], [C, D]]

// Count only
print(combinations(5, 3).length);  // 10
```

### Permutations

```dart
print(permutations(["A", "B", "C", "D"], 2));
print(permutations(5, 3).length);  // 60
print(permutations(3, 2));
// [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]

// With function
var productPerm = permutations(3, 2, func: (perm) => perm.reduce((a, b) => a * b));
print(productPerm);  // [2, 3, 2, 6, 3, 6]
```

---

## Numerical Integration

```dart
double f(double x) => x * x;  // f(x) = x²

double result = numIntegrate(f, 0, 2);
print(result);  // ≈ 2.667 (∫₀² x² dx = 8/3)
```

---

## Coordinate Conversion

### Rectangular to Polar (rec)

```dart
print(rec(3, 4));                // (r, θ) from rectangular
print(rec(56, degToRad(27)));    // With radians

// With degrees flag
print(rec(56, 27, isDegrees: true));
```

### Polar to Rectangular (pol)

```dart
print(pol(5, pi / 4));           // (x, y) from polar
print(pol(49.89, 25.42));        // With radians

// With degrees flag
print(pol(49.89, 25.42, isDegrees: true));
```

---

## Memoization

Cache function results for improved performance.

### Basic Memoization

```dart
// Regular function
var sum = (() => 1.to(999999999).sum());

// Memoized version
var sumMemo = sum.memoize();

for (var i = 0; i < 10; i++) {
  var res = time(() => sumMemo());
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');
}
// First call: slow, subsequent calls: instant
```

### Fibonacci with Memoization

```dart
// Simple function memoization
final memoFib = fib.memoize();
for (var i = 0; i < 10; i++) {
  var res = time(() => memoFib(9999));
  print('Result: ${res.result}, Time: ${res.elapsed.inMilliseconds}ms');
}
```

### Typed Memoization

```dart
// Memoized1<ReturnType, ArgumentType>
late final Memoized1<int, int> fib3;
fib3 = Memoized1((int n) {
  if (n <= 1) return n;
  return fib3(n - 1) + fib3(n - 2);
});

print(fib3(500));  // Instant after first call
```

### Multi-Argument Functions

```dart
int add2(int a, int b) => a + b;
final memoAdd = add2.memoize();
print(memoAdd(5, 3));  // Cached based on both arguments
```

### Cache Expiry

```dart
var numbers = 1.to(30000000);
final calculateSum = (() => numbers.sum()).memoize();

calculateSum();  // Cached

numbers = 1.to(9043483);
calculateSum.expire();  // Clear cache
calculateSum();  // Recomputed with new data
```

### Variable Arguments Memoization

```dart
final varArgsFn = Memoize.functionVarArgs((List<dynamic> args) {
  return args.reduce((a, b) => a + b);
});
print(varArgsFn([1, 2, 3, 4]));  // Sum: 10
```

---

## VarArgsFunction

Handle variable number of arguments in functions.

### Basic Usage

```dart
// Positional arguments only
dynamic superHeroes = VarArgsFunction<void>((args, kwargs) {
  for (final superHero in args) {
    print("There's no stopping $superHero");
  }
});

superHeroes('UberMan', 'Exceptional Woman', 'The Hunk');

// Both positional and named arguments
dynamic myFunc = VarArgsFunction<String>((args, kwargs) {
  return 'Got args: $args, kwargs: $kwargs';
});

print(myFunc(1, 2, 3, x: 'hello', y: 'world'));
print(myFunc(10, 20, x: true, y: false));
```

### Calculator Example

```dart
dynamic calculator = VarArgsFunction<num>((args, kwargs) {
  String operation = kwargs['operation'] ?? 'sum';

  switch (operation) {
    case 'sum':
      return args.fold<num>(0, (a, b) => a + (b as num));
    case 'multiply':
      return args.fold<num>(1, (a, b) => a * (b as num));
    case 'average':
      return args.fold<num>(0, (a, b) => a + (b as num)) / args.length;
    default:
      throw ArgumentError('Unknown operation: $operation');
  }
});

print(calculator([1, 2, 3, 4, 5]));  // 15
print(calculator([1, 2, 3, 4, 5], kwargs: {'operation': 'multiply'}));  // 120
print(calculator([1, 2, 3, 4, 5], kwargs: {'operation': 'average'}));   // 3.0
```

### avg Function

```dart
dynamic avg = VarArgsFunction<num>((args, kwargs) {
  if (args.length == 1 && args.first is List) {
    args = args.first;
  }
  return mean(args.map((e) => e as num).toList());
});

print(avg(1, 2, 3));           // 2.0
print(avg(1, 2, 3, 4, 5));     // 3.0
print(avg([1, 2, 3, 4, 5]));   // 3.0
```

### Currying

```dart
var add = VarArgsFunction<int>((args, _) => args[0] + args[1] + args[2]);
var curriedAdd = add.curry(3);
var add5 = curriedAdd(5);
var add5And10 = add5(10);
print(add5And10(15));  // 30 (5 + 10 + 15)
```

### Map Transformation

```dart
dynamic countArgs = VarArgsFunction<int>((args, _) => args.length);
var doubleCount = countArgs.map((count) => count * 2);
var formatCount = countArgs.map((count) => 'Number of arguments: $count');

print(countArgs(1, 2, 3));      // 3
print(doubleCount(1, 2, 3));    // 6
print(formatCount(1, 2, 3));    // "Number of arguments: 3"
```

### Partial Application

```dart
dynamic greet = VarArgsFunction<String>((args, kwargs) {
  var name = args.isNotEmpty ? args[0] : 'Guest';
  var greeting = kwargs['greeting'] ?? 'Hello';
  var punctuation = kwargs['excited'] == true ? '!' : '.';
  return '$greeting, $name$punctuation';
});

dynamic greetJohn = greet.partial(['John']);
dynamic sayHi = greet.partial([], {'greeting': 'Hi'});

print(greet());                // "Hello, Guest."
print(greetJohn());            // "Hello, John."
print(sayHi('Alice'));         // "Hi, Alice."
```

### Debounce

```dart
// Only execute once after delay, even if called multiple times
var searchFunction = VarArgsFunction<void>((args, _) {
  print('Searching for: ${args[0]}');
}).debounced(Duration(milliseconds: 300));

// Multiple rapid calls - only last one executes
searchFunction("a");
searchFunction("ap");
searchFunction("app");
searchFunction("appl");
searchFunction("apple");  // Only this one executes after 300ms
```

### Throttle

```dart
// Execute at most once per interval
dynamic saveFunction = VarArgsFunction<void>((args, _) {
  print('Saving data: ${args[0]}');
}).throttled(Duration(seconds: 2));

saveFunction("data1");  // Executes immediately
saveFunction("data2");  // Ignored (within 2 seconds)
saveFunction("data3");  // Ignored
// After 2 seconds, next call would execute
```

### Retry

```dart
var unreliableFunction = VarArgsFunction<String>((args, _) {
  if (Random().nextDouble() < 0.7) {
    throw Exception('Random failure');
  }
  return 'Success with ${args[0]}';
});

var reliableFunction = unreliableFunction.withRetry(5);

await reliableFunction('test').then((result) {
  print(result);  // Success if any of 5 attempts succeeds
}).catchError((e) {
  print('Failed after retries: $e');
});
```

---

## Extensions

### Sum with Mixed Types

```dart
print([1, 2, 4, 4.5, Complex(1, 5), 9.7].sum()); // Complex(12.7, 5)
print([1, 2, 3].sum());                           // 6 (num)
print([Complex(1, 1), Complex(2, 2)].sum());      // Complex(3, 3)
```

### String Extraction

```dart
String testString = "Hello123World456! Café au lait costs 3.50€. Contact: test@example.com or visit https://example.com";

print(testString.extractLetters());      // HelloWorldCafaulait
print(testString.extractNumbers());      // 123456350
print(testString.extractWords());        // List of words
print(testString.extractAlphanumeric()); // Hello123World456

print(testString.extractLettersList());  // [H, e, l, l, o, W, o, r, l, d]
print(testString.extractNumbersList());  // [1, 2, 3, 4, 5, 6]
print(testString.extractEmails());       // [test@example.com]
print(testString.extractUrls());         // [https://example.com]

// Custom pattern
print(testString.extractCustomPattern(r'\bC\w+'));  // Words starting with C
```

### GroupBy

```dart
List<Map<String, dynamic>> parcels = [
  {'id': 'AB123', 'area': 100, 'type': 'residential'},
  {'id': 'AB456', 'area': 150, 'type': 'commercial'},
  {'id': 'CD789', 'area': 200, 'type': 'residential'},
  {'id': 'CD012', 'area': 120, 'type': 'industrial'},
];

// Group by function
var groupedByScheme = parcels.groupBy((p) => p['id'].substring(0, 2));
// {AB: [...], CD: [...]}

// Group by key
var groupedByType = parcels.groupByKey('type');
// {residential: [...], commercial: [...], industrial: [...]}

// Group by custom range
var groupedByAreaRange = parcels.groupBy((parcel) {
  int area = parcel['area'];
  if (area < 120) return 'small';
  if (area < 180) return 'medium';
  return 'large';
});
```

### Integer Range Extension

```dart
// Creates Range from int
var range = 10.to(20);  // Range(10, 20)
print(range.toList());  // [10, 11, 12, ..., 19]
```

---

## Related Tests

- [`test/basic/`](../test/basic/) - Basic math function tests
- [`test/number/`](../test/number/) - Number type tests
- [`test/domain/`](../test/domain/) - Domain and Range tests

## Related Documentation

- [Numbers](05_numbers.md) - Complex, Decimal, Rational, Roman numerals
- [Algebra](01_algebra.md) - Matrix, Vector, Expressions
- [Utilities](07_utilities.md) - Extensions and memoization
