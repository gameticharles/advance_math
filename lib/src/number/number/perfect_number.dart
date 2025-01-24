import 'dart:core';

import '../../../advance_math.dart';

/// A perfect number is a positive integer that is equal to the sum of its
/// positive divisors, excluding the number itself.
/// For example, the first perfect number is 6, because it is equal to the sum
/// of its divisors, excluding itself: 1, 2, 3, 6.
///
/// The perfect number theorem states that there are infinitely many perfect
/// numbers. The first few perfect numbers are:
/// - 6, 28, 496, 8128, 33550336, 8589869056, 137438691328, 2305843008139952128 and so on.
///
/// Source: https://en.wikipedia.org/wiki/List_of_Mersenne_primes_and_perfect_numbers
///
class PerfectNumber {
  // Immutable state
  late final int? nth;
  // List of known Mersenne prime exponents (for faster lookup)
  static final List<int> _knownMersenneExponents = [
    2,
    3,
    5,
    7,
    13,
    17,
    19,
    31,
    61,
    89,
    107,
    127,
    521,
    607,
    1279,
    2203,
    2281,
    3217,
    4253,
    4423,
    9689,
    9941,
    11213,
    19937,
    21701,
    23209,
    44497,
    86243,
    110503,
    132049,
    216091,
    756839,
    859433,
    1257787,
    1398269,
    2976221,
    3021377,
    6972593,
    13466917,
    20996011,
    24036583,
    25964951,
    30402457,
    32582657,
    37156667,
    42643801,
    43112609,
    57885161,
    74207281,
    77232917,
    82589933,
    136279841
  ];

  // Cache storage
  final _perfectNumberCache = <int, BigInt>{};
  final _mersenneExponentCache = <int, int>{};
  final _mersennePrimeCache = <int, BigInt>{};

  // Property caches
  List<BigInt>? _properDivisors;
  List<int>? _oddCubes;
  String? _binaryForm;
  List<int>? _consecutiveTwoPowers;

  // Timing metrics
  final _timingStats = <String, Duration>{
    'perfectNumber': Duration.zero,
    'properties': Duration.zero,
  };

  /// Constructs a `PerfectNumber` instance and pre-warms the cache for the given `nth` perfect number.
  ///
  /// This constructor is useful when you know the specific perfect number you want to work with, as it
  /// ensures the necessary computations are performed and cached ahead of time.
  PerfectNumber([this.nth]) {
    // Pre-warm cache for constructor value
    if (nth != null) _computePerfectNumber(nth!);
  }

  /// Main computation method with layered caching
  void _computePerfectNumber(int n) {
    if (_perfectNumberCache.containsKey(n)) return;

    final stopwatch = Stopwatch()..start();

    final p = nthMersennePrimeExponent(n);
    final mersenne = mersenneNumber(p);
    final perfect = (BigInt.one << (p - 1)) * mersenne;

    _perfectNumberCache[n] = perfect;
    _mersenneExponentCache[n] = p;
    _mersennePrimeCache[n] = mersenne;

    _timingStats['perfectNumber'] = stopwatch.elapsed;
  }

  /// Safe property access with validation
  /// Provides a map of various properties related to the current perfect number, including its exponent,
  /// Mersenne prime, digit counts, proper divisors, odd cubes, and power of two sums. This method
  /// ensures the necessary computations are performed and cached before returning the properties.
  Map<String, dynamic> get properties {
    final stopwatch = Stopwatch()..start();

    _computePerfectNumber(nth!);

    final result = {
      'mersenne_exponent': _mersenneExponentCache[nth],
      'mersenne_prime': _getNumberPreview(mersennePrime.toString()),
      'mersenne_digits': mersennePrimeLength,
      'perfect_number': _getNumberPreview(perfectNumber.toString()),
      'perfect_digits': perfectNumberLength,
      'proper_divisors': _getListPreview(properDivisors),
      'odd_cubes': _getListPreview(consecutiveOddCubes),
      'power_of_two_sums': _getListPreview(consecutiveTwoPowers),
      'binary_form': _getNumberPreview(binaryForm.toString()),
    };

    _timingStats['properties'] = stopwatch.elapsed;
    return result;
  }

  /// Optimized digit count without full string conversion
  int _digitCount(BigInt number) {
    return (number.bitLength * log10(2)).floor() + 1;
  }

  // Calculation methods
  List<BigInt> _calculateDivisors() {
    final divisors = <BigInt>[];
    final maxPower = mersenneExponent - 1;

    // Add powers of 2
    for (var i = 0; i <= maxPower; i++) {
      divisors.add(BigInt.one << i);
    }

    // Add Mersenne multiples
    for (var i = 0; i < maxPower; i++) {
      divisors.add((BigInt.one << i) * mersennePrime);
    }

    return divisors..sort();
  }

  List<int> _calculateOddCubes() {
    if (mersenneExponent == 2) return [];
    final n = pow(2, (mersenneExponent - 1) ~/ 2).toInt();
    // return List.generate(n, (i) {
    //   final odd = 2 * i + 1;
    //   return BigInt.from(odd).pow(3);
    // });
    return List.generate(n, (i) => 2 * i + 1);
  }

  List<int> _calculatePowerSums() {
    final start = mersenneExponent - 1;
    final end = 2 * mersenneExponent - 2;
    // return List.generate(end - start + 1, (i) => BigInt.one << (start + i));
    return List.generate(end - start + 1, (i) => start + i);
  }

  /// Efficient preview generation
  String _getNumberPreview(String numStr, [int maxLength = 6]) {
    return numStr.length <= 20
        ? numStr
        : '${numStr.substring(0, maxLength)}...${numStr.substring(numStr.length - maxLength)}';
  }

  String _getListPreview(List<dynamic> list,
      [int elementsAtEnds = 3, bool showEnds = false]) {
    if (list.isEmpty) return '[]';
    if (elementsAtEnds < 1) elementsAtEnds = 3;

    final totalElements = list.length;
    final buffer = StringBuffer('[');

    if (totalElements <= elementsAtEnds * 2) {
      return list.toString();
    }

    // Add first elements
    for (var i = 0; i < elementsAtEnds; i++) {
      if (i > 0) buffer.write(', ');
      buffer.write(list[i]);
    }

    // Add middle ellipsis
    buffer.write(', ...');

    if (showEnds) {
      // Add last elements
      for (var i = totalElements - elementsAtEnds; i < totalElements; i++) {
        buffer.write(', ');
        buffer.write(list[i]);
      }
    } else {
      // Add ellipsis for middle elements
      buffer.write('${list.length - elementsAtEnds} more elements');
    }

    buffer.write(']');
    return buffer.toString();
  }

  // Compute 2^p - 1
  static BigInt mersenneNumber(int p) {
    return (BigInt.one << p) - BigInt.one;
  }

  /// Finds the nth Mersenne prime exponent.
  ///
  /// Mersenne primes are prime numbers of the form 2^p - 1, where p is a positive integer.
  /// This function first checks if the nth Mersenne prime exponent is already known, and
  /// returns it if so. Otherwise, it iterates through the possible Mersenne prime exponents,
  /// starting from 2, and checks each one using the [isMersennePrime] function until it
  /// finds the nth Mersenne prime exponent.
  ///
  /// Args:
  ///   n (int): The index of the Mersenne prime exponent to find, where 1 is the first.
  ///
  /// Returns:
  ///   int: The nth Mersenne prime exponent.
  ///
  /// Throws:
  ///   ArgumentError: If `n` is less than 1.
  static int nthMersennePrimeExponent(int n) {
    if (n < 1) throw ArgumentError("n must be a positive integer.");

    if (n < _knownMersenneExponents.length) {
      return _knownMersenneExponents[n - 1];
    }

    int count = 0;
    int p = 2; // Start from the first possible Mersenne exponent

    while (true) {
      if (isMersennePrime(p)) {
        count++;
        if (count == n - 1) {
          return p; // Return the nth Mersenne prime exponent
        }
      }
      p++; // Increment to test the next exponent
    }
  }

  /// Timing information
  Map<String, Duration> get timings => Map.unmodifiable(_timingStats);

  /// Get the perfect number
  BigInt get perfectNumber => _perfectNumberCache[nth]!;

  /// Get the perfect number's digits length
  int get perfectNumberLength => _digitCount(_perfectNumberCache[nth]!);

  /// Get the Mersenne prime exponent
  int get mersenneExponent => _mersenneExponentCache[nth]!;

  /// Get the Mersenne prime
  BigInt get mersennePrime => _mersennePrimeCache[nth]!;

  /// Get the Mersenne prime's digits length
  int get mersennePrimeLength => _digitCount(_mersennePrimeCache[nth]!);

  // Optimized property calculations with caching
  List<BigInt> get properDivisors => _properDivisors ??= _calculateDivisors();

  /// Get the nth perfect number's consecutive odd cubes
  /// This is a list of the odd cubes that sum to the perfect number
  ///
  /// Example:
  /// ```dart
  /// final pn = PerfectNumber(1); // => 6
  /// print(pn.consecutiveOddCubes); // []
  ///
  /// pn = PerfectNumber(2); // => 28
  /// print(pn.consecutiveOddCubes); // [1, 3] => 1^3 + 3^3 = 28
  ///
  /// pn = PerfectNumber(3); // => 496
  /// print(pn.consecutiveOddCubes); // [1, 3, 5, 7] => 1^3 + 3^3 + 5^3 + 7^3 = 496
  ///
  /// pn = PerfectNumber(4); // => 8128
  /// print(pn.consecutiveOddCubes); // [1, 3, 5, 7, 9, 11, 13] => 1^3 + 3^3 + 5^3 + 7^3 + 9^3 +11^3 + 13^3 + 15^3 = 8128
  /// ```
  List<int> get consecutiveOddCubes => _oddCubes ??= _calculateOddCubes();

  /// Get the nth perfect number's power of two sums
  /// This is a list of the powers of two that sum to the perfect number.
  /// The length of the list is the mersenne prime exponent.
  ///
  /// Example:
  /// ```dart
  /// final pn = PerfectNumber(1); // => 6
  /// print(pn.consecutiveTwoPowers); // [1, 2] => 2^1 + 2^2 = 6
  ///
  /// pn = PerfectNumber(2); // => 28
  /// print(pn.consecutiveTwoPowers); // [2, 3, 4] => 2^2 + 3^2 + 4^2 = 28
  ///
  /// pn = PerfectNumber(3); // => 496
  /// print(pn.consecutiveTwoPowers); // [4, 5, 6, 7, 8] => 2^4 + 2^5 + 2^6 + 2^7 + 2^8 = 496
  ///
  /// pn = PerfectNumber(4); // => 8128
  /// print(pn.consecutiveTwoPowers); // [6, 7, 8, 9, 10, 11, 12] => 2^6 + 2^7 + 2^8 + 2^9 + 2^10 + 2^11 + 2^12 = 8128
  /// ```
  List<int> get consecutiveTwoPowers =>
      _consecutiveTwoPowers ??= _calculatePowerSums();

  /// Get the nth perfect number's binary form
  String get binaryForm => _binaryForm ??= perfectNumber.toRadixString(2);

  /// Get the nth perfect number's hexadecimal form
  String get hexadecimal => perfectNumber.toRadixString(16);

  /// Checks if the given number is a perfect number.
  ///
  /// A perfect number is a positive integer that is equal to the sum of its proper divisors, excluding the number itself.
  ///
  /// Example:
  ///
  /// final calculator = PerfectNumber(6);
  /// print(calculator.isPerfect(calculator.perfectNumber)); // true
  ///
  static bool isPerfect(dynamic number) {
    return isPerfectNumber(number);
  }
}
