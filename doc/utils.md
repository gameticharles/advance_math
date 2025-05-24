# Utilities Module (`utils`)

This module provides a collection of utility functions, extensions, and classes that offer general-purpose helper functionalities used throughout the library or available for external use.

## Table of Contents
- [Argument Utilities (`args.dart`)](#argument-utilities)
  - [Overview](#args-overview)
  - [`VarArgsFunction<T>`](#varargsfunction)
  - [`FutureVarArgsFunction<T>`](#futurevarargsfunction)
- [Chinese Remainder Theorem (`chinese_remainder_theorem.dart`)](#chinese-remainder-theorem)
  - [Overview](#crt-overview)
  - [`ChineseRemainderTheorem` Class](#chineseremaindertheorem-class)
- [Compressed Prime Sieve (`compressed_prime_sieve.dart`)](#compressed-prime-sieve)
  - [Overview](#sieve-overview)
  - [Generating a Sieve](#generating-a-sieve)
  - [Querying Primes](#querying-primes)
  - [Getting a List of Primes](#getting-a-list-of-primes)
- [General Extensions (`ext.dart`)](#general-extensions)
  - [Top-Level Functions](#ext-top-level-functions)
  - [Classes (`Range`, `Domain`)](#ext-classes)
- [Fast Fourier Transform (`fast_fourier.dart`)](#fast-fourier-transform)
  - [Overview](#fft-overview)
  - [`FastFourierTransform` Class](#fastfouriertransform-class)
- [Function Extensions (`func_ext.dart`)](#function-extensions)
  - [Overview](#func-ext-overview)
- [Iterable Extensions (`iterable_ext.dart`)](#iterable-extensions)
  - [`GroupingExtension<T> on Iterable<T>`](#groupingextension)
  - [`MapListGroupingExtension on List<Map<String, dynamic>>`](#maplistgroupingextension)
  - [`IterableExt<E> on Iterable<E>`](#iterableext)
- [Memoization (`memoize.dart`)](#memoization)
  - [Overview](#memoization-overview)
  - [`MemoizeOptions` Class](#memoizeoptions-class)
  - [`Memoize` Class - Static Factory Methods](#memoize-class)
  - [Extension Methods for Memoization](#memoization-extension-methods)
  - [Managing Cache and Status (`MemoizedBase` features)](#managing-cache)
- [Numeric Extensions (`num_ext.dart`)](#numeric-extensions)
  - [`NumExtension on num`](#numextension)
  - [`BigIntSqrt on BigInt`](#bigintsqrt-extension)
- [String Extensions (`string_ext.dart`)](#string-extensions)
  - [`ExtString on String`](#extstring)
    - [Validation Methods](#string-validation-methods)
    - [Case Manipulation & Formatting](#string-case-manipulation)
    - [Character Type Checks](#string-character-type-checks)
    - [Character Manipulation](#string-character-manipulation)
    - [Extraction Methods](#string-extraction-methods)

---

## Argument Utilities (`args.dart`)
*(Documentation for `VarArgsFunction` and `FutureVarArgsFunction` from `lib/src/utils/args.dart`)*

### Args Overview
The `args.dart` file provides utilities for creating functions that can accept a variable number of arguments, both positional and named. This is primarily achieved through the `VarArgsFunction` class and its asynchronous counterpart, `FutureVarArgsFunction`. These classes also offer built-in support for functional programming patterns like memoization, currying, partial application, debouncing, and throttling, enhancing function call flexibility and reusability.

### `VarArgsFunction<T>`
This class allows a standard Dart function or a custom callback to be invoked with dynamic arguments.

**Purpose:**
- To create functions that can take a varying number of positional arguments.
- To create functions that can accept named arguments dynamically.
- To apply functional programming utilities like memoization, currying, etc., to such functions.

**Constructors:**
-   **`VarArgsFunction(VarArgsCallback<T> callback)`**
    *   Creates a `VarArgsFunction` with a custom `callback`. The `callback` is of type `T Function(List<dynamic> args, Map<String, dynamic> kwargs)`.
-   **`static VarArgsFunction<R>.fromFunction<R>(Function function)`**
    *   Wraps a standard Dart function.

**Key Methods & Examples:**
*(Note: `VarArgsFunction` instances are callable directly, e.g., `myFunc(arg1, name: kwarg1)`, due to `noSuchMethod` overriding, or more explicitly via `myFunc.call(positionalArgsList, namedArgsMap)`).*

-   **`map<R>(R Function(T result) transform)`**: Transforms the function's result.
    ```dart
    var add = VarArgsFunction<int>((args, _) => (args[0] as int) + (args[1] as int));
    var addAndDouble = add.map((sum) => sum * 2);
    print(addAndDouble([3, 4])); // Output: 14  ((3+4)*2)
    ```

-   **`curry(int arity)`**: Converts a function of `arity` arguments into a sequence of functions each taking one argument.
    ```dart
    var multiplyThree = VarArgsFunction<int>((args, _) => args[0] * args[1] * args[2]);
    var curriedMultiply = multiplyThree.curry(3);
    var mulBy2 = curriedMultiply(2);
    var mulBy2And3 = mulBy2(3);
    print(mulBy2And3(4)); // Output: 24 (2*3*4)
    ```

-   **`partial([List<dynamic> preArgs = const [], Map<String, dynamic> preKwargs = const {}])`**: Pre-fills some arguments.
    ```dart
    var power = VarArgsFunction<num>((args, _) => math.pow(args[0], args[1]));
    var square = power.partial([args[0], 2]); // This argument passing is conceptual for partial.
                                             // Actual usage: var square = power.partial([], {'base': someBase, 'exponent': 2});
                                             // Or, if fromFunction(math.pow): var square = VarArgsFunction.fromFunction(math.pow).partial([args[0],2]);
    // Corrected example for partial:
    var powerFunc = VarArgsFunction<num>((args, kwargs) {
        num base = args.isNotEmpty ? args[0] : kwargs['base'];
        num exp = args.length > 1 ? args[1] : kwargs['exponent'];
        return math.pow(base, exp);
    });
    var squareOf = powerFunc.partial([], {'exponent': 2});
    print(squareOf([5])); // Output: 25 (5^2)
    var fiveCubed = powerFunc.partial([5], {'exponent': 3});
    print(fiveCubed());   // Output: 125 (5^3)
    ```

-   **`memoized()` / `memoizedWithKey(...)`**: Caches results to avoid re-computation.
    ```dart
    var complexCalc = VarArgsFunction<String>((args, kwargs) {
      print("Complex calc for ${args[0]}, ${kwargs['opt']}");
      return "Result: ${args[0] * (kwargs['opt'] as int)}";
    }).memoized();
    print(complexCalc(['A', 10], {'opt': 2})); // Prints "Complex calc...", Output: Result: AAAAAAAAAAAAAAAAAAAA (String * int)
    print(complexCalc(['A', 10], {'opt': 2})); // No print, cached result.
    ```

-   **`debounced(Duration delay) -> FutureVarArgsFunction<T>`**: Delays execution until `delay` after the last call.
    ```dart
    // Simulate API call that should only happen after user stops typing
    var apiCall = VarArgsFunction<String>((args, _) {
      print("Calling API with query: ${args[0]}");
      return "Results for ${args[0]}";
    }).debounced(Duration(milliseconds: 500));

    // apiCall(['search1']);
    // apiCall(['search12']); // Previous call is cancelled
    // Future.delayed(Duration(milliseconds: 600), () => apiCall(['search123'])); // This one will execute
    ```

-   **`throttled(Duration interval) -> FutureVarArgsFunction<T>`**: Executes at most once per `interval`.
    ```dart
    // Simulate a window resize handler
    // var resizeHandler = VarArgsFunction<void>((_,__) => print("Window resized, updating layout..."))
    //    .throttled(Duration(milliseconds: 200));
    // resizeHandler(); // Executes
    // resizeHandler(); // Ignored if within 200ms
    // Future.delayed(Duration(milliseconds: 250), resizeHandler); // Executes
    ```

-   **`withRetry(int maxRetries, [Duration? delay]) -> FutureVarArgsFunction<T>`**: Retries execution on failure.
    ```dart
    // int counter = 0;
    // var flakyNetworkCall = VarArgsFunction<String>((_,__) {
    //   counter++;
    //   print("Attempting call #$counter");
    //   if (counter < 3) throw Exception("Network Error");
    //   return "Data received!";
    // }).withRetry(3, Duration(milliseconds: 100));
    //
    // flakyNetworkCall().then(print).catchError((e) => print("Failed after retries: $e"));
    // Expected: Attempting call #1, Attempting call #2, Attempting call #3, Data received!
    ```
    
-   **`compose<R>(VarArgsFunction<R> Function(T) g)`**: Composes `f.compose(g)` as `g(f(...))`.
    ```dart
    var add5 = VarArgsFunction<int>((args, _) => args[0] + 5);
    var multiplyBy2 = VarArgsFunction<int>((args, _) => args[0] * 2);
    // composed(x) = multiplyBy2(add5(x)) = (x+5)*2
    var add5AndMultiplyBy2 = add5.compose((int res) => multiplyBy2.partial([res]));
    print(add5AndMultiplyBy2([10])); // Output: 30  ((10+5)*2)
    ```

### `FutureVarArgsFunction<T>`
Extends `VarArgsFunction<Future<T>>` for async functions.
-   **`mapFuture<R>(R Function(T result) transform)`**: Maps the `Future<T>` result to `Future<R>`.
-   **`withTimeout(Duration timeout)`**: Adds a timeout to the future.
-   **`withFallback(T fallbackValue)`**: Provides a fallback if the future fails.
-   **`composeAsync<R>(VarArgsFunction<R> Function(T) g)`**: Composes with another function that takes the async result.

---

## Chinese Remainder Theorem (`chinese_remainder_theorem.dart`)
*(From `lib/src/utils/chinese_remainder_theorem.dart`)*

### CRT Overview
The Chinese Remainder Theorem (CRT) solves systems of simultaneous linear congruences `x ≡ a[i] (mod m[i])`, where moduli `m[i]` are pairwise coprime. It finds a unique solution `x` modulo `M = product(m[i])`.

### `ChineseRemainderTheorem` Class
Contains static methods for CRT.

#### `static List<int> crt(List<int> a, List<int> m)`
  - **Description:** Solves `x ≡ a[i] (mod m[i])`. Assumes moduli `m` are pairwise coprime.
    *(Note: The source code has a known issue where a line for calculating modular inverses is commented out, which will lead to incorrect results. The example below shows intended usage and expected correct output.)*
  - **Returns:** `List<int> [x, M]`, where `x` is the solution, `M` is product of moduli.
  - **Example:**
    ```dart
    // System: x ≡ 2 (mod 3), x ≡ 3 (mod 5), x ≡ 2 (mod 7)
    // Moduli 3, 5, 7 are pairwise coprime.
    // M = 3*5*7 = 105.
    // Solution: x = 23 (23%3=2, 23%5=3, 23%7=2)
    // List<int> solution = ChineseRemainderTheorem.crt([2, 3, 2], [3, 5, 7]);
    // print("Conceptual correct solution: x ≡ ${solution[0]} (mod ${solution[1]})"); // Expected: x ≡ 23 (mod 105)
    print("Note: CRT.crt method has known issue in source. Conceptual output for [2,3,2],[3,5,7] is [23, 105]");
    ```

#### `static List<num>? eliminateCoefficient(num c, num a, num m)`
  - **Description:** Solves `cx ≡ a (mod m)` to `x ≡ a_new (mod m_new)`.
  - **Returns:** `[a_new, m_new]` or `null` if no solution (if `a` is not divisible by `gcd(c,m)`).
  - **Purpose:** To simplify a single congruence before including it in a system for CRT.
  - **Example:**
    ```dart
    // 4x ≡ 2 (mod 6) => gcd(4,6)=2. 2%2=0. Divide by 2: 2x ≡ 1 (mod 3)
    // Now solve 2x ≡ 1 (mod 3). gcd(2,3)=1. 1%1=0.
    // Modular inverse of 2 mod 3 is 2 (2*2=4≡1 mod 3).
    // x ≡ 1*2 (mod 3) => x ≡ 2 (mod 3).
    print(ChineseRemainderTheorem.eliminateCoefficient(4, 2, 6)); // Output: [2, 3]
    ```

#### `static List<List<int>>? reduce(List<int> a, List<int> m)`
  - **Description:** Reduces a system `x ≡ a[i] (mod m[i])` to an equivalent system where moduli are pairwise coprime by splitting moduli into prime power factors. Returns `null` if inconsistent.
  - **Purpose:** Preprocessing for `crt` if initial moduli are not coprime.
  - **Example:**
    ```dart
    var reduced = ChineseRemainderTheorem.reduce([1, 7], [6, 15]);
    // x ≡ 1 (mod 6) => x ≡ 1 (mod 2), x ≡ 1 (mod 3)
    // x ≡ 7 (mod 15) => x ≡ 2 (mod 3) (7%3=1, not 2. Let's use x≡7(mod15) => x≡1(mod3), x≡2(mod5)
    //   x ≡ 7 (mod 15) => 7%3=1, so x≡1(mod3). 7%5=2, so x≡2(mod5).
    // System: x≡1(mod2), x≡1(mod3), x≡2(mod5)
    print(reduced); // Output: [[1, 1, 2], [2, 3, 5]] (order may vary)
    ```

---

## Compressed Prime Sieve (`compressed_prime_sieve.dart`)
*(From `lib/src/utils/compressed_prime_sieve.dart`)*

### Sieve Overview
`CompressedPrimeSieve` generates primes up to a limit using a memory-optimized Sieve of Eratosthenes (bit array for odd numbers).

### Generating a Sieve
#### `static List<int> primeSieve(int limit)`
  - Generates a prime sieve (bit array) up to `limit`.
  ```dart
  final sieveData = CompressedPrimeSieve.primeSieve(1000);
  ```

### Querying Primes
#### `static bool isPrime(List<int> sieve, int n)`
  - Checks if `n` is prime using the pre-computed `sieve`.
  ```dart
  print(CompressedPrimeSieve.isPrime(sieveData, 997)); // Output: true (if limit >= 997)
  print(CompressedPrimeSieve.isPrime(sieveData, 998)); // Output: false
  ```

### Getting a List of Primes
To get a list of primes, iterate and use `isPrime`:
```dart
List<int> getPrimesInRange(List<int> sieve, int start, int end) {
  final primes = <int>[];
  for (int i = start; i <= end; i++) {
    if (CompressedPrimeSieve.isPrime(sieve, i)) {
      primes.add(i);
    }
  }
  return primes;
}
final sieveForRange = CompressedPrimeSieve.primeSieve(50);
final primes_0_50 = getPrimesInRange(sieveForRange, 0, 50);
print("Primes 0-50: $primes_0_50");
// Output: Primes 0-50: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47]
```

---

## General Extensions (`ext.dart`)
*(From `lib/src/utils/ext.dart`)*

### Ext Top-Level Functions
#### `void printLine([String s = ''])`
  - Prints a decorative line with optional string `s`.
  ```dart
  printLine("Task Complete");
  ```

### Ext Classes
#### `Range` Class
  - **Overview:** Represents a generic range `[min, max]`.
  - **Constructor:** `Range(dynamic min, dynamic max)`
  - **Properties:** `min: dynamic`, `max: dynamic`
  - **Use Case:** Defining valid input ranges, e.g., `Range(0, 100)` for a percentage.
  ```dart
  final validPercentage = Range(0, 100);
  if (95 >= validPercentage.min && 95 <= validPercentage.max) { /* ... */ }
  ```

#### `Domain` Class
  - **Overview:** Represents a 1D domain (e.g., x-axis) with `minX` and `maxX`.
  - **Constructor:** `Domain(double minX, double maxX)`
  - **Properties:** `minX: double`, `maxX: double`
  - **Use Case:** Defining the extent of a function or plot on an axis.
  ```dart
  final plotDomain = Domain(-pi, pi);
  print("Plot from ${plotDomain.minX} to ${plotDomain.maxX}");
  ```

---

## Fast Fourier Transform (`fast_fourier.dart`)
*(From `lib/src/utils/fast_fourier.dart`)*

### FFT Overview
This `FastFourierTransform` is **specialized for polynomial multiplication with integer coefficients** using Number Theoretic Transform (NTT), an FFT variant modulo a prime. It is **not** a general-purpose complex FFT for signal processing.

### `FastFourierTransform` Class
#### `static List<int> multiply(List<int> x, List<int> y)`
  - **Description:** Multiplies polynomials `x` and `y` (coefficient lists) using NTT. Handles negative coefficients.
  - **Note:** Relies on an internal `_initialize()` method (called by its own `main()`). Ensure this is implicitly or explicitly handled if using `multiply` directly.
  - **Example:**
    ```dart
    // P1(x) = 1 + 2x + 3x^2  => [1, 2, 3]
    // P2(x) = 4 + 5x         => [4, 5]
    // Product = (1+2x+3x^2)(4+5x) = 4 + 5x + 8x + 10x^2 + 12x^2 + 15x^3
    //         = 4 + 13x + 22x^2 + 15x^3 => [4, 13, 22, 15]
    // FastFourierTransform.main(); // Ensures powers table is initialized.
    List<int> result = FastFourierTransform.multiply([1, 2, 3], [4, 5]);
    print("Product (FFT): $result");
    // Output: Product (FFT): [4, 13, 22, 15] (or with trailing zeros depending on FFT padding)
    ```

---

## Function Extensions (`func_ext.dart`)
*(From `lib/src/utils/func_ext.dart`)*

### Func Ext Overview
This file currently contains commented-out code for an extension `FunctionExt` intended to add a `.memo` getter for easy memoization. As it's commented out, use the `Memoize` class directly (see [Memoization](#memoization)).

---

## Iterable Extensions (`iterable_ext.dart`)
*(From `lib/src/utils/iterable_ext.dart`)*

### `GroupingExtension<T> on Iterable<T>`
#### `Map<K, List<T>> groupBy<K>(K Function(T) keyExtractor)`
  - Groups elements by a key.
  ```dart
  final words = ['sky', 'cat', 'dog', 'sun', 'moon'];
  final byLength = words.groupBy((s) => s.length);
  print(byLength); // Output: {3: [sky, cat, dog, sun], 4: [moon]}
  ```

### `MapListGroupingExtension on List<Map<String, dynamic>>`
#### `Map<dynamic, List<Map<String, dynamic>>> groupByKey(String key)`
  - Groups a list of maps by values of a `key`.
  ```dart
  final sales = [{'product':'A', 'region':'North'}, {'product':'B', 'region':'South'}, {'product':'C', 'region':'North'}];
  print(sales.groupByKey('region'));
  // Output: {North: [{product: A, ...}, {product: C, ...}], South: [{product: B, ...}]}
  ```

### `IterableExt<E> on Iterable<E>`
#### `Iterable<T> insertBetween<T>(T separator)`
  - Inserts `separator` between elements.
  ```dart
  print(['a','b','c'].insertBetween<String>('-').join()); // Output: a-b-c
  ```
#### `dynamic sum([num Function(E element)? selector])`
  - Sums elements. Converts to `Complex` if `Complex` elements are present.
  ```dart
  print([10, 20, Complex(5, -2)].sum()); // Output: 35.0 - 2.0i
  ```

---

## Memoization (`memoize.dart`)
*(From `lib/src/utils/memoize.dart`)*

### Memoization Overview
Caches function results. Use `MemoizeOptions`, `Memoize` factories, or `Function` extensions.

### `MemoizeOptions` Class
Configures cache: `maxSize` (LRU), `ttl` (time-to-live).
- **Static Options:** `unlimited`, `smallLRU` (100), `mediumLRU` (1000), `largeLRU` (10000), `shortLived` (1min), `mediumLived` (10min), `longLived` (1hr).
```dart
final myOptions = MemoizeOptions(maxSize: 200, ttl: Duration(minutes: 30));
```

### `Memoize` Class
Static factories: `Memoize.function0`, `Memoize.function1<A,R>`, `Memoize.asyncFunction1<A,R>`, etc., up to 5 arguments, and versions `WithKey` for custom cache keys, and `VarArgs` versions.
```dart
String greet(String name) { print("Generating greeting for $name..."); return "Hello, $name!"; }
final memoizedGreet = Memoize.function1(greet, options: MemoizeOptions.smallLRU);
print(memoizedGreet("Alice")); // Prints "Generating...", Output: Hello, Alice!
print(memoizedGreet("Alice")); // No print, Output: Hello, Alice!
```

### Memoization Extension Methods
`.memoize()` or `.memo` (getter) on `Function` types.
```dart
// Example:
// double heavyComputation(double input) {
//   print("Computing for $input...");
//   return input * math.pi;
// }
// final memoizedHeavyComp = heavyComputation.memoize();
// print(memoizedHeavyComp(2.0)); // Prints "Computing..."
// print(memoizedHeavyComp(2.0)); // Returns cached value
```
For recursive functions (e.g., Fibonacci), `memoizeRecursive()` for single-argument functions helps structure the memoization correctly.

### Managing Cache (`MemoizedBase` features)
Memoized functions (instances of `MemoizedX`) provide:
- `isExpired`, `isNotComputedYet`, `isComputed`: Status.
- `expire()`: Marks cache entry/entries as expired.
- `clearCache()`: Clears all entries.
- `cacheSize`: Number of cached items.
- `cacheStats`: Cache statistics map.
- `call(..., {bool forceRecompute = false})`: Bypasses cache.

---

## Numeric Extensions (`num_ext.dart`)
*(From `lib/src/utils/num_ext.dart`)*

### `NumExtension on num`
For `num`, `int`, `double`.

-   **`Iterable<num> to(num end, {num step = 1})`**: Generates numbers from `this` to `end` (inclusive) by `step`.
    ```dart
    print(0.to(1, step: 0.25).toList()); // Output: [0.0, 0.25, 0.5, 0.75, 1.0]
    ```
-   **`num absolute()`**: Alias for `abs()`.
-   **`dynamic squareRoot()`**: Returns `double` or `Complex`.
-   **`dynamic cubeRoot()` / `dynamic nthRoot(double nth)`**: Principal root. Returns `double` or `Complex`.
-   **`dynamic exponentiation(num exponent)`**: `math.exp(this)`. (Source signature seems to have unused `exponent` param).
-   **`dynamic power(num exponent)`**: `math.pow(this, exponent)`.
-   **`bool isEven()` / `bool isOdd()`**: Parity for integers; for doubles, `this % 2 == 0`.
    ```dart
    print(10.isEven());   // true
    print(10.5.isEven()); // false
    print(11.isOdd());    // true
    ```
-   **`bool isPerfectSquare()`**: Integer part's square root is integer.
    ```dart
    print(49.isPerfectSquare()); // true
    print(50.0.isPerfectSquare());// false
    ```
-   **`bool isPrime()`**: Integer primality test (`>1`).
-   **`num roundTo([int decimalPlaces = 0])`**: Rounds to `decimalPlaces`.
    ```dart
    print(math.pi.roundTo(4)); // Output: 3.1416
    print(12345.67.roundTo(-2)); // Output: 12300.0
    ```

### `BigIntSqrt on BigInt`
-   **`BigInt sqrt()`**: Integer square root.
    ```dart
    print(BigInt.parse("12345678987654321").sqrt()); // Output: 111111111
    ```
-   **`bool get isPowerOfTwo`**: Checks if `BigInt > 0` is a power of two.
    ```dart
    print(BigInt.from(1024).isPowerOfTwo); // true
    print(BigInt.from(1000).isPowerOfTwo); // false
    ```

---

## String Extensions (`string_ext.dart`)
*(From `lib/src/utils/string_ext.dart`)*

### `ExtString on String`

#### String Validation Methods
-   **`bool isValidEmail()`**: Basic email format check. *Source logic `!RegExp.hasMatch` means it returns `true` for strings that DON'T match the email pattern. Assuming typical intent (true for valid) for example.*
    ```dart
    // Conceptual if fixed: print('a@b.co'.isValidEmail()); // true
    print('a@b.co'.isValidEmail()); // Actual source logic: false
    ```
-   **`bool isValidName()`**: Checks if string contains *only* letters (A-Za-z), no symbols, spaces, or digits.
    ```dart
    print('ValidName'.isValidName()); // true
    print('Invalid Name'.isValidName()); // false
    ```
-   **`bool isValidPassword([int minLength = 6])`**: Checks for uppercase, lowercase, digit, special symbol, and min length. *Source logic `!RegExp.hasMatch` inverted for example.*
    ```dart
    // Conceptual if fixed: print('Str0ngP@ss!'.isValidPassword()); // true
    print('Str0ngP@ss!'.isValidPassword()); // Actual source logic: false
    ```
-   **`String? passwordValidationMessage([int minLength = 6])`**: Returns specific error message or `null` if valid.
-   **`bool containsSymbol()`**: True if `!@#\$&*~` is present.
-   **`bool containsUpperMixCaseLetter()`**: True if both upper and lower case letters exist.
-   **`bool containsNumber()`**: True if any digit 0-9 exists.
-   **`bool isValidPhone({int length = 10})`**: Checks `^(?:[+0]9)?[0-9]{length}$`.
    ```dart
    print('0987654321'.isValidPhone()); // true
    ```
-   **`bool isValidNumeric()`**: Checks `(^(?:[+0]9)?[0-9]$)`. (Single digit, possibly prefixed).
    ```dart
    print('5'.isValidNumeric()); // true
    ```

#### String Case Manipulation
-   **`String allInCaps()`**: `toUpperCase()`.
-   **`String capitalize({bool all = true})`**: Capitalizes first letter of string (if `all=false`) or each word (if `all=true`).
    ```dart
    print('test string'.capitalize()); // Output: Test String
    ```

#### String Character Type Checks
-   **`bool isDigit()`**: All characters are digits.
-   **`bool isAlpha()`**: All characters are alphabetic.
-   **`bool isAlphaNumeric()`**: All characters are alphanumeric.

#### String Character Manipulation
-   **`String removeSpecialCharacters({bool alphabets = true, bool numeric = true, String replaceWith = ''})`**: Removes non-alphanumeric based on flags.
    ```dart
    print('Data-123!@#'.removeSpecialCharacters(replaceWith: '_')); // Output: Data_123___
    ```
-   **`List<String> replaceCharactersInList(List<String> list, Map<String, String> replacements)`**: Operates on `list`, not `this`.

#### String Extraction Methods
-   **`String extractLetters({bool excludeSymbols = false})`**: Extracts letters. `excludeSymbols:true` uses `\p{L}`.
    ```dart
    print('Word1, Sign&'.extractLetters(excludeSymbols: true)); // Output: WordSign
    ```
-   **`String extractNumbers({bool excludeDecimalsAndSymbols = false})`**: Extracts numeric parts. `excludeDecimalsAndSymbols:true` uses `\d`.
    ```dart
    print('Price: $19.99'.extractNumbers()); // Output: $19.99
    print('Code: 123-45'.extractNumbers(excludeDecimalsAndSymbols: true)); // Output: 12345
    ```
-   **`String extractAlphanumeric({bool excludeSymbols = false})`**: Extracts letters and numbers.
-   **`List<String> extractLettersList(...)`**, **`List<String> extractNumbersList(...)`**, **`List<String> extractWords(...)`**
-   **`List<String> extractEmails()`**, **`List<String> extractUrls()`**
-   **`List<String> extractCustomPattern(String pattern, {bool unicode = true})`**
    ```dart
    print('Call (123) 456-7890'.extractCustomPattern(r'\d{3}')); // Output: [123, 456, 789]
    ```
*Note on regex logic for `isValidEmail` and `isValidPassword`: The documentation reflects typical validation intent (true for valid). If the source's negated logic is strictly followed, the meaning of "valid" in those methods is inverted (true if it *doesn't* match the pattern of a valid item).*

---
