# Utilities Module

Extensions, FFT, interpolation, memoization, and general helper functions.

---

## Table of Contents

1. [Argument Utilities](#argument-utilities)
2. [Chinese Remainder Theorem](#chinese-remainder-theorem)
3. [Compressed Prime Sieve](#compressed-prime-sieve)
4. [Interpolation](#interpolation)
5. [Fast Fourier Transform (FFT)](#fast-fourier-transform-fft)
6. [Memoization](#memoization)
7. [Range](#range)
8. [Domain](#domain)
9. [Extensions](#extensions)
10. [Code Translators](#code-translators)
11. [Random Number Generation](#random-number-generation)
12. [Mathematical Functions](#mathematical-functions)

---

## Argument Utilities

The `VarArgsFunction` class allows creating functions that accept variable numbers of arguments (variadic functions) and supports functional patterns like currying and partial application.

### Basic Usage

```dart
import 'package:advance_math/advance_math.dart';

// Function receiving args list and kwargs map
var printer = VarArgsFunction<void>((args, kwargs) {
  print('Positional: $args');
  print('Named: $kwargs');
});

printer(1, 2, 3, name: 'Test');
// Output:
// Positional: [1, 2, 3]
// Named: {name: Test}
```

### Functional Features

#### Map Result

```dart
var add = VarArgsFunction<int>((args, _) => (args[0] as int) + (args[1] as int));
var addAndDouble = add.map((sum) => sum * 2);
print(addAndDouble(3, 4)); // 14
```

#### Currying

```dart
var multiply3 = VarArgsFunction<int>((args, _) => args[0] * args[1] * args[2]);
var curried = multiply3.curry(3);
print(curried(2)(3)(4)); // 24
```

#### Partial Application

```dart
var power = VarArgsFunction<num>((args, kwargs) {
  num base = args.isNotEmpty ? args[0] : kwargs['base'];
  num exp = args.length > 1 ? args[1] : kwargs['exponent'];
  return math.pow(base, exp);
});

var square = power.partial([], {'exponent': 2});
print(square(5)); // 25
```

#### Debounce and Throttle

```dart
// Debounce: Execute only after constraints (e.g. user stops typing)
var search = VarArgsFunction((args, _) => print('Search: ${args[0]}'))
    .debounced(Duration(milliseconds: 300));
search('a'); search('ap'); search('app'); // Only 'app' prints if fast

// Throttle: Execute max once per interval
var save = VarArgsFunction((_, __) => print('Saved'))
    .throttled(Duration(seconds: 1));
```

---

## Chinese Remainder Theorem

Solves systems of simultaneous linear congruences.

### usage

```dart
// x ≡ 2 (mod 3)
// x ≡ 3 (mod 5)
// x ≡ 2 (mod 7)
var result = ChineseRemainderTheorem.crt([2, 3, 2], [3, 5, 7]);
print("Solution: x ≡ ${result[0]} (mod ${result[1]})");
// x ≡ 23 (mod 105)
```

### Utils

- `eliminateCoefficient(c, a, m)`: Solves `cx ≡ a (mod m)`.
- `reduce(a, m)`: Reduces a system to pairwise coprime moduli.

---

## Compressed Prime Sieve

Memory-optimized Sieve of Eratosthenes using checking bit arrays.

```dart
// Generate sieve up to 1000
final sieve = CompressedPrimeSieve.primeSieve(1000);

// Check primality using sieve
print(CompressedPrimeSieve.isPrime(sieve, 997)); // true
print(CompressedPrimeSieve.isPrime(sieve, 100)); // false
```

---

## Interpolation

### 1D Interpolation

The `Interp1D` class provides interpolation for 1-D functions.

```dart
List<num> x = [0, 1, 2, 3, 4, 5];
List<num> y = [0, 1, 4, 9, 16, 25];  // y = x²

// Linear
var linear = Interp1D(x, y, method: MethodType.linear);
print(linear(2.5)); // 6.5 (approx)

// Cubic Spline
var cubic = Interp1D(x, y, method: MethodType.cubic);
print(cubic(2.5));  // 6.25 (exact for quadratic)
```

**Methods**: `linear`, `nearest`, `previous`, `next`, `quadratic`, `cubic`, `newton`.

### 2D Interpolation

```dart
var interp2d = Interp2D(x, y, zGrid);
print(interp2d(0.5, 0.5));
```

---

## Fast Fourier Transform (FFT)

### Complex FFT

Standard FFT for signal processing.

```dart
var signal = ComplexArray.fromComplex([...]);
var spectrum = signal.fft();
var reconstructed = spectrum.ifft();
```

### Polynomial Multiplication (NTT)

Specialized Number Theoretic Transform for exact polynomial multiplication with integer coefficients.

```dart
// P1(x) = 1 + 2x + 3x^2
// P2(x) = 4 + 5x
// Multiply polynomials
List<int> result = FastFourierTransform.multiply([1, 2, 3], [4, 5]);
print(result); // [4, 13, 22, 15] => 4 + 13x + 22x^2 + 15x^3
```

---

## Memoization

Cache function results to optimize performance.

### Usage

```dart
int difficultCalc(int n) { ... }

// Create memoized version
final memoized = difficultCalc.memoize();

// First call runs logic
memoized(10);

// Second call returns cached result
memoized(10);
```

### Configuration

Use `MemoizeOptions` to control cache size and expiration.

```dart
final memoized = Memoize.function1(
  myFunc,
  options: MemoizeOptions(
    maxSize: 100,
    ttl: Duration(minutes: 5)
  )
);
```

---

## Range

Python-like range iteration.

```dart
// Standard
var r = Range(0, 10, 2); // 0, 2, 4, 6, 8

// From string slice
var r2 = Range.parse("0:10:2");

// Linspace
var r3 = Range.linspace(0, 1, 5); // 0.0, 0.25, 0.5, 0.75, 1.0

// Memory efficient
var huge = Range(0, 1000000000);
print(huge.contains(500)); // true (constant time)
```

---

## Domain

Map values between numerical domains.

```dart
final tempDomain = Domain(-10, 40);
final pixelDomain = Domain(0, 100);

double x = tempDomain.mapTo(15, pixelDomain); // Map 15°C to pixel position
```

---

## Extensions

### Numeric Extensions (`num`, `int`, `BigInt`)

```dart
// Ranges
0.to(5); // [0, 1, 2, 3, 4, 5]

// Properties
10.isEven();
49.isPerfectSquare();
3.14159.roundTo(2); // 3.14

// BigInt
BigInt.parse("123...").sqrt();
BigInt.from(1024).isPowerOfTwo; // true
```

### Iterable Extensions

```dart
// Sum (handles num and Complex)
[1, 2, Complex(1, 1)].sum(); // Complex(4, 1)

// Grouping
var words = ['apple', 'cat', 'dog'];
var byLength = words.groupBy((w) => w.length); // {5: [apple], 3: [cat, dog]}

// List of Maps grouping
var sales = [{'region': 'N', 'val': 10}, {'region': 'S', 'val': 20}];
var byRegion = sales.groupByKey('region');

// Insert between
['a', 'b'].insertBetween('-'); // a, -, b
```

### String Extensions

Validation and manipulation.

```dart
// Validation
'abc'.isAlpha();
'123'.isDigit();
'test@example.com'.isValidEmail(); // Basic regex check
'Password123!'.isValidPassword();

// Extraction
"Price: $10.50".extractNumbers(); // "1050"
"Price: $10.50".extractNumbers(excludeDecimalsAndSymbols: false); // "10.50"
"Hello World".extractLetters(); // "HelloWorld"

// Case
"hello world".capitalize(all: true); // "Hello World"
```

---

## Code Translators

### Morse Code

```dart
var morse = MorseCode();
print(morse.encode('SOS')); // ... --- ...
print(morse.decode('... --- ...')); // SOS
```

### Number to Words

```dart
var nw = NumOrWords();
print(nw.toWords(123)); // "One Hundred And Twenty-Three"
print(nw.toWords(10.50, currency: usd)); // "Ten Dollars And Fifty Cents Only"
```

---

## Random Number Generation

Extensions on `Random` class.

```dart
var rng = Random();
rng.nextIntInRange(10, 20);
rng.nextGaussian(mean: 0, stddev: 1);
rng.nextElementFromList(['a', 'b', 'c']);
rng.nextUUID();
```

---

## Mathematical Functions

Utilities often found in `basic/` but exported here for convenience.

- **Prime Factors**: `primeFactors(n)`
- **GCD/LCM**: `gcd(list)`, `lcm(list)`
- **Modular Inverse**: `modInv(a, m)`
- **Extended GCD**: `egcd(a, b)`

---

## Related Tests

- [`test/utils/`](../test/utils/) - Tests for extensions and utilities.
- [`test/math/`](../test/math/) - Interpolation tests.
