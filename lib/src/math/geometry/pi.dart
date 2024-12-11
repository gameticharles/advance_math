// ignore_for_file: constant_identifier_names

part of 'geometry.dart';

/// Specifies the algorithm to use when calculating the value of pi.
///
/// The [gaussLegendre] method uses the Gauss-Legendre algorithm to compute the value of pi.
/// The [chudnovsky] method uses the Chudnovsky algorithm to compute the value of pi.
enum PiCalcAlgorithm {
  /// Calculates the value of pi using the Chudnovsky algorithm.
  GaussLegendre,

  /// Computes the value of π to the specified precision using the Gauss-Legendre algorithm.
  Chudnovsky,

  /// Calculates the value of pi using the BBP (Bailey–Borwein–Plouffe) algorithm.
  BBP,

  /// Calculates the value of pi using the Madhava algorithm.
  Madhava,

  /// Calculates the value of pi using the Ramanujan algorithm.
  Ramanujan,

  NewtonEuler
}

class PI {
  /// The precision of the computed value of pi, in decimal places.
  final int precision;

  late final String _piString;

  /// The time taken per digit of the computed value of pi.
  late final double timePerDigit;

  // Ref Pi:https://stackoverflow.com/questions/56022623/avoid-overflow-when-calculating-%cf%80-by-evaluating-a-series-using-16-bit-arithmetic/56035284#56035284

  /// Constructs a [PI] object with the specified precision.
  ///
  /// The [precision] parameter determines the number of decimal places to compute for the value of π.
  /// If no [precision] is provided, the default is 100 decimal places.
  ///
  /// `method`: The method to use to calculate the value of pi.
  ///
  /// The computed value of π is stored in the [_piString] field as a string.
  PI({PiCalcAlgorithm algorithm = PiCalcAlgorithm.Chudnovsky, int? precision})
      : precision = precision ?? decimalPrecision {
    dynamic pi;

    switch (algorithm) {
      case PiCalcAlgorithm.BBP:
        pi = BBP(this.precision);
        break;

      case PiCalcAlgorithm.GaussLegendre:
        pi = GaussLegendre(this.precision);
        break;

      case PiCalcAlgorithm.Chudnovsky:
        pi = Chudnovsky(this.precision);
        break;

      case PiCalcAlgorithm.Ramanujan:
        pi = Ramanujan(this.precision);
        break;

      case PiCalcAlgorithm.NewtonEuler:
        pi = NewtonEuler(this.precision);
        break;

      case PiCalcAlgorithm.Madhava:
        pi = Madhava(this.precision);
        break;
    }

    // Perform pi calculation.
    Decimal piValue = pi.calculate();
    _piString = piValue.toStringAsFixed(this.precision);

    timePerDigit = pi.getTimePerDigit();
  }

  /// Performs a binary split on the given range [a, b] to calculate the
  /// values of P, Q, and R for the Chudnovsky algorithm.
  ///
  /// The Chudnovsky algorithm is a method for calculating the digits of pi.
  /// This function is a helper for the main Chudnovsky algorithm implementation.
  ///
  /// The function recursively splits the range [a, b] in half until the
  /// base case of [a, a+1] is reached. It then calculates the values of P, Q, and R for that small range and combines them to get the values for the original range.
  ///
  /// Source://https://en.wikipedia.org/wiki/Chudnovsky_algorithm
  /// Parameters:
  /// - `a`: The start of the range.
  /// - `b`: The end of the range.
  ///
  /// Returns:
  /// A tuple containing the calculated values of P, Q, and R for the given range.
  (Decimal Pab, Decimal Qab, Decimal Rab) binarySplit(int a, int b) {
    if (b == a + 1) {
      var Pab = Decimal.parse('-1.0') *
          Decimal(((6 * a) - 5) * ((2 * a) - 1) * ((6 * a) - 1));
      var Qab = Decimal('10939058860032000') * Decimal(a * a * a);
      var Rab = Pab * (Decimal(545140134 * a) + Decimal(13591409));
      return (Pab, Qab, Rab);
    } else {
      int m = (a + b) ~/ 2;
      var (Pam, Qam, Ram) = binarySplit(a, m);
      var (Pmb, Qmb, Rmb) = binarySplit(m, b);

      var Pab = Pam * Pmb;
      var Qab = Qam * Qmb;
      var Rab = Qmb * Ram + Pam * Rmb;

      return (Pab, Qab, Rab);
    }
  }

  /// Gets the nth decimal digit of π.
  ///
  /// This method retrieves the nth decimal digit of the value of π, where n is a positive integer
  /// between 1 and the specified precision of the PI object.
  ///
  /// Parameters:
  /// - `n`: The index of the decimal digit to retrieve, starting from 1.
  ///
  /// Returns:
  /// The integer value of the nth decimal digit of π.
  ///
  /// Throws:
  /// - [ArgumentError] if `n` is less than 1 or greater than the specified precision of the PI object.
  int getNthDigit(int n) {
    if (n < 1 || n > precision) {
      throw ArgumentError('n must be between 1 and the specified precision');
    }
    return int.parse(_piString[n + 1]); // Skip "3."
  }

  /// Checks if a given digit pattern exists in the decimal representation of π.
  ///
  /// This method takes a string `pattern` and checks if it is present in the decimal
  /// representation of π, which is stored in the `_piString` field.
  ///
  /// Parameters:
  /// - `pattern`: The digit pattern to search for in the decimal representation of π.
  ///
  /// Returns:
  /// `true` if the `pattern` is found in the decimal representation of π, `false` otherwise.
  bool containsPattern(String pattern) {
    return _piString.contains(pattern);
  }

  /// Gets the digits of π from the specified start to end indices.
  ///
  /// This method retrieves a substring of the decimal representation of π, starting from the
  /// `start` index and ending at the `end` index (inclusive). The first decimal digit is at
  /// index 1 (skipping the "3.").
  ///
  /// Parameters:
  /// - `start`: The starting index of the digits to retrieve, must be between 1 and the
  ///   specified precision of the PI object.
  /// - `end`: The ending index of the digits to retrieve, must be between 1 and the
  ///   specified precision of the PI object, and greater than or equal to the `start` index.
  ///
  /// Returns:
  /// A string containing the digits of π from the specified `start` to `end` indices.
  ///
  /// Throws:
  /// - [ArgumentError] if `start` is less than 1, `end` is greater than the specified
  ///   precision, or `start` is greater than `end`.
  String getDigits(int start, int end) {
    if (start < 1 || end > precision || start > end) {
      throw ArgumentError('Invalid range for start and end');
    }
    return _piString.substring(start + 1, end + 2); // Skip "3."
  }

  /// The decimal value of π, with the specified precision.
  Decimal get value => Decimal(_piString, sigDigits: precision);

  /// Computes a function that requires the value of π.
  ///
  /// This method takes a function that accepts a [Decimal] parameter and returns a [Decimal]
  /// result, and applies it to the [value] property of the current [PI] object, which
  /// represents the decimal value of π with the specified precision.
  ///
  /// Parameters:
  /// - `func`: The function to compute, which must take a [Decimal] parameter and return a
  ///   [Decimal] result.
  ///
  /// Returns:
  /// The result of applying the provided function to the [value] of the current [PI] object.
  Decimal compute<T>(Decimal Function(Decimal) func) {
    return func(value);
  }

  /// Counts the frequency of each digit in the provided string representation of pi.
  ///
  /// This function takes the string representation of pi and counts the frequency of each
  /// digit (0-9) in the decimal representation. The results are returned as a map, where
  /// the keys are the digits and the values are the counts.
  ///
  /// Note that the function skips the first two characters ("3.") of the pi string, as
  /// these are not part of the decimal representation.
  ///
  /// Parameters:
  /// - `pi`: The string representation of pi.
  ///
  /// Returns:
  /// A map containing the frequency of each digit in the pi string.
  Map<String, int> countDigitFrequency() {
    Map<String, int> frequency = {
      '0': 0,
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
      '6': 0,
      '7': 0,
      '8': 0,
      '9': 0
    };
    for (int i = 2; i < _piString.length; i++) {
      // Start at 2 to skip "3."
      String digit = _piString[i];
      if (frequency.containsKey(digit)) {
        frequency[digit] = frequency[digit]! + 1;
      }
    }
    return frequency;
  }

  /// Finds the indices of a given pattern in the string representation of pi, skipping the first two characters ("3.").
  ///
  /// This method searches for the provided [pattern] in the string representation of pi, starting from index 2 to skip the "3."
  /// It keeps track of the frequency of the pattern and the indices where the pattern is found.
  ///
  /// Parameters:
  /// - `pattern`: The pattern to search for in the pi string.
  ///
  /// Returns:
  /// A map containing the frequency of the pattern and the indices where the pattern was found.
  Map<String, dynamic> findPatternIndices(String pattern) {
    int frequency = 0;
    List<int> indices = [];
    int index = _piString.indexOf(
        pattern, 2); // Start searching from index 2 to skip "3."

    while (index != -1) {
      frequency++;
      indices.add(index - 2); // Adjust index to account for skipping "3."
      index = _piString.indexOf(pattern, index + 1);
    }

    return {"frequency": frequency, "indices": indices};
  }

  @override
  String toString() {
    return value.toString();
  }
}

/// Abstract base class for algorithms that compute the value of pi.
///
/// This class defines the common properties and methods for algorithms that
/// calculate the value of pi to a specified number of digits. Subclasses
/// must implement the `calculate()` method to provide the specific algorithm
/// for computing pi.
abstract class PiAlgorithm {
  final int digits;
  final double digitsPerIteration;
  late int startTime;
  late int endTime;

  PiAlgorithm(this.digits, this.digitsPerIteration);

  Decimal factorial(int n) {
    Decimal result = Decimal.one;
    for (int i = 2; i <= n; i++) {
      result *= Decimal.fromInt(i);
    }
    return result;
  }

  /// Calculates the time taken to compute one digit of pi.
  ///
  /// This method calculates the time taken to compute one digit of pi by
  /// dividing the total time taken to compute the digits by the number of
  /// digits computed.
  double getTimePerDigit() {
    return (endTime - startTime) / digits;
  }

  /// Calculates the value of pi to the specified number of digits.
  Decimal calculate();
}

/// Computes the value of π using the BBP (Bailey-Borwein-Plouffe) algorithm.
/// The BBP algorithm is an efficient method for calculating digits of π without
/// computing the entire value. This implementation calculates the specified
/// number of digits of π.
class BBP extends PiAlgorithm {
  BBP(int digits) : super(digits, 1.0);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;
    Decimal.setPrecision(digits + 2);

    var pi = Rational.zero;
    int iterations = (digits / digitsPerIteration).ceil() + 1;

    for (int k = 0; k < iterations; k++) {
      var M = Decimal.one / Decimal(16).pow(k);
      var T1 = Decimal(4) / (Decimal(8 * k) + Decimal.one);
      var T2 = Decimal(2) / (Decimal(8 * k) + Decimal(4));
      var T3 = Decimal.one / (Decimal(8 * k) + Decimal(5));
      var T4 = Decimal.one / (Decimal(8 * k) + Decimal(6));
      pi += M * (T1 - T2 - T3 - T4);
    }

    endTime = DateTime.now().millisecondsSinceEpoch;
    return pi.toDecimal(precision: digits);
  }
}

/// Computes the value of π to the specified precision using the Madhava algorithm.
class Madhava extends PiAlgorithm {
  Madhava(int digits) : super(digits, 0.4);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;

    Decimal.setPrecision(digits + 2);

    var pi = Rational.zero;
    int iterations = (digits / digitsPerIteration).ceil() + 2;

    for (int k = 1; k < iterations; k++) {
      Decimal Nk = Decimal(-1).pow(k + 1);
      Decimal Dk = Decimal((2 * k) - 1) * Decimal(3).pow(k - 1);
      pi += Nk / Dk;
    }

    pi *= Decimal(12).sqrt().toRational();

    endTime = DateTime.now().millisecondsSinceEpoch;
    return pi.toDecimal(precision: digits);
  }
}

/// Calculates the value of pi using the Chudnovsky algorithm.
class Chudnovsky extends PiAlgorithm {
  Chudnovsky(int digits) : super(digits, 14.1816474627254776555);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;

    Decimal.setPrecision(digits + 2);

    var pi = Rational.zero;
    int iterations = (digits / digitsPerIteration).ceil() + 1;

    for (int k = 0; k < iterations; k++) {
      var Mk = this.factorial(6 * k) /
          (this.factorial(3 * k) * this.factorial(k).pow(3));
      Decimal Lk = Decimal.fromInt(545140134 * k) + Decimal.fromInt(13591409);
      Decimal Xk = Decimal('-262537412640768000').pow(k);
      pi += Decimal(Mk) * Lk / Xk;
    }

    var C = (Decimal(426880) * Decimal(10005).sqrt()).inverse;
    pi = (C * pi).inverse;

    endTime = DateTime.now().millisecondsSinceEpoch;
    return pi.toDecimal(precision: digits);
  }
}

/// Computes the value of π to the specified precision using the Gauss-Legendre algorithm.
class GaussLegendre extends PiAlgorithm {
  GaussLegendre(int digits) : super(digits, 1.0);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;

    Decimal.setPrecision(digits + 2);

    Decimal three = Decimal(3);
    Decimal lasts = Decimal.zero;
    Decimal t = three;
    Decimal s = Decimal(3);
    Decimal n = Decimal.one;
    Decimal na = Decimal.zero;
    Decimal d = Decimal.zero;
    Decimal da = Decimal(24);

    while (s != lasts) {
      lasts = s;
      n = n + na;
      na = na + Decimal(8);
      d = d + da;
      da = da + Decimal(32);
      t = ((t * n) / d).toDecimal(precision: digits + 2);
      s = s + t;
    }

    endTime = DateTime.now().millisecondsSinceEpoch;
    return s;
  }
}

/// Computes the value of π to the specified precision using the Ramanujan algorithm.
/// The Ramanujan algorithm is an efficient method for calculating the digits of π.
/// This implementation calculates π to the specified number of digits.
class Ramanujan extends PiAlgorithm {
  Ramanujan(int digits) : super(digits, 8.0);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;

    Decimal.setPrecision(digits + 2);

    var pi = Rational.zero;
    int iterations = (digits / digitsPerIteration).ceil() + 1;

    for (int k = 0; k < iterations; k++) {
      var Mk = this.factorial(4 * k) / this.factorial(k).pow(4);
      Decimal Lk = Decimal(26390 * k) + Decimal(1103);
      Decimal Xk = Decimal(396).pow(4 * k);
      pi += Decimal(Mk) * Lk / Xk;
    }

    var C = (Decimal(2) * Decimal(2).sqrt()) / Decimal(9801);
    pi = (C * pi).inverse;

    endTime = DateTime.now().millisecondsSinceEpoch;
    return pi.toDecimal(precision: digits);
  }
}

/// Computes the value of π to the specified precision using the Newton-Euler algorithm.
/// The Newton-Euler algorithm is an efficient method for calculating the digits of π.
/// This implementation calculates π to the specified number of digits.
class NewtonEuler extends PiAlgorithm {
  NewtonEuler(int digits) : super(digits, 0.3);

  @override
  Decimal calculate() {
    startTime = DateTime.now().millisecondsSinceEpoch;

    Decimal.setPrecision(digits + 2);

    var pi = Rational.zero;
    int iterations = (digits / digitsPerIteration).ceil() + 1;

    for (int k = 0; k < iterations; k++) {
      Decimal Nk = Decimal(2).pow(k) * this.factorial(k).pow(2);
      var Dk = this.factorial((2 * k) + 1);
      pi += Nk / Dk;
    }

    pi *= Rational.fromInt(2);

    endTime = DateTime.now().millisecondsSinceEpoch;
    return pi.toDecimal(precision: digits);
  }
}
