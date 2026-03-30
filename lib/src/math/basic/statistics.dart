part of 'math.dart';

// Helper to flatten args
List<dynamic> _flattenArgs(List<dynamic> args) {
  if (args.isEmpty) return [];
  if (args.length == 1 && args.first is List) {
    return args.first as List;
  }
  if (args.length == 1 && args.first is Vector) {
    return (args.first as Vector).toList();
  }
  return args;
}

List<num> _getArgsParams(List<dynamic> args) {
  return _flattenArgs(args).map((e) {
    if (e is Complex) return e.real;
    if (e is String) {
      try {
        return num.parse(e);
      } catch (_) {
        // Handle symbol string by letting it fail later or return 0
        return 0;
      }
    }
    return e as num;
  }).toList();
}

Polynomial _toPoly(dynamic p) {
  if (p is Polynomial) {
    // Re-dispatch through fromList to ensure we have the most specific subclass (Quadratic, etc.)
    return Polynomial.fromList(p.coefficients, variable: p.variable);
  }
  return Polynomial.fromString(p.toString());
}

List<num> _toNumList(dynamic dat) {
  if (dat is List) {
    return dat.map((e) => e is Complex ? e.real : e as num).toList();
  }
  return [];
}

// Internal implementations to avoid VarArgsFunction dispatch overhead
num _sum(List<dynamic> list) {
  if (list.isEmpty) return 0;

  var nums = list.map((e) {
    if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
    return e;
  }).toList();

  if (nums.any((e) => e is Complex)) {
    return (nums
        .map((e) => e is Complex ? e : Complex(e, 0))
        .reduce((a, b) => a + b)).real;
  }
  return nums.cast<num>().reduce((a, b) => a + b);
}

num _mean(List<num> list) {
  if (list.isEmpty) return 0;
  return list.reduce((a, b) => a + b) / list.length;
}

num _variance(List<num> list) {
  if (list.length < 2) return 0.0;
  num m = _mean(list);
  return list.map((num x) => math.pow(x - m, 2)).reduce((a, b) => a + b) /
      (list.length - 1);
}

num _stdDev(List<num> list) {
  return math.sqrt(_variance(list));
}

num _stdErrMean(List<num> list) {
  if (list.isEmpty || list.length == 1) return 0;
  return _stdDev(list) / math.sqrt(list.length);
}

num _correlation(List<num> x, List<num> y) {
  if (x.length != y.length) {
    throw ArgumentError('Lists must have the same length');
  }
  num meanX = _mean(x);
  num meanY = _mean(y);

  num numerator = 0;
  num denominator1 = 0;
  num denominator2 = 0;

  for (int i = 0; i < x.length; i++) {
    numerator += (x[i] - meanX) * (y[i] - meanY);
    denominator1 += math.pow(x[i] - meanX, 2);
    denominator2 += math.pow(y[i] - meanY, 2);
  }

  return numerator / math.sqrt(denominator1 * denominator2);
}

/// Returns the sum of a list of numbers (num or Complex).
///
/// Accepts variable arguments or a single list.
///
/// Example:
/// ```dart
/// print(sum(1, 2, 3)); // 6
/// print(sum([1, 2, 3])); // 6
/// print(sum(Complex(1, 1), Complex(2, 2))); // 3.0 + 3.0i
/// ```
dynamic sum = VarArgsFunction((args, kwargs) => _sum(_flattenArgs(args)));

/// Returns the mean (average) of a list of numbers.
///
/// Example:
/// ```dart
/// print(mean([1, 2, 3, 4, 5])); // prints: 3.0
/// print(mean(1, 2, 3, 4, 5));   // prints: Complex:<3 + 0i>
/// ```
dynamic mean =
    VarArgsFunction((args, kwargs) => Complex(_mean(_getArgsParams(args)), 0));

/// Alias for mean.
dynamic average = mean;

/// Returns the average of two or more numbers.
dynamic avg = mean;

/// Returns the median of a list of numbers.
///
/// The median is the middle value when the list is sorted.
/// If the list has an even number of elements, returns the average of the two middle values.
///
/// Example:
/// ```dart
/// print(median(1, 3, 2)); // 2
/// print(median([1, 2, 3, 4])); // 2.5
/// ```
dynamic median = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty) return Complex(0);
  list.sort();
  if (list.length % 2 == 1) {
    return Complex(list[list.length ~/ 2]);
  } else {
    return Complex((list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2);
  }
});

/// Returns the mode (most common element(s)) of a list of numbers.
///
/// Returns a list of the most frequent elements.
///
/// Example:
/// ```dart
/// print(mode(1, 2, 2, 3)); // [2]
/// print(mode([1, 1, 2, 2])); // [1, 2]
/// ```
dynamic mode = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty) return [];

  Map<num, int> freqMap = {};
  for (num item in list) {
    freqMap[item] = (freqMap[item] ?? 0) + 1;
  }

  var maxFreq = freqMap.values.reduce(math.max);
  return freqMap.entries
      .where((entry) => entry.value == maxFreq)
      .map((entry) => Complex(entry.key))
      .toList();
});

/// Returns the variance of a list of numbers.
///
/// Calculates the sample variance.
///
/// Example:
/// ```dart
/// print(variance(1, 2, 3, 4, 5)); // 2.5
/// ```
dynamic variance = VarArgsFunction(
    (args, kwargs) => Complex(_variance(_getArgsParams(args)), 0));

/// Returns the standard deviation of a list of numbers.
///
/// Calculates the sample standard deviation.
///
/// Example:
/// ```dart
/// print(stdDev(1, 2, 3, 4, 5)); // ~1.58
/// ```
dynamic stdDev = VarArgsFunction(
    (args, kwargs) => Complex(_stdDev(_getArgsParams(args)), 0));

/// Returns the standard deviation of a list of numbers.
dynamic standardDeviation = stdDev;

/// Returns the standard error of the mean of a list of numbers.
///
/// Example:
/// ```dart
/// print(stdErrMean(1, 2, 3, 4, 5)); // ~0.707
/// ```
dynamic stdErrMean = VarArgsFunction(
    (args, kwargs) => Complex(_stdErrMean(_getArgsParams(args)), 0));

/// Standard error of estimate.
/// Expects two lists: stdErrEst(List x, List y) or flattened if appropriate (though intended for paired data).
///
/// Example:
/// ```dart
/// var x = [1, 2, 3];
/// var y = [2, 4, 6];
/// print(stdErrEst(x, y));
/// ```
dynamic stdErrEst = VarArgsFunction((args, kwargs) {
  if (args.length != 2 || args[0] is! List || args[1] is! List) {
    throw ArgumentError('stdErrEst requires two lists: x and y');
  }
  List<num> x = _toNumList(args[0]);
  List<num> y = _toNumList(args[1]);

  num meanX = _mean(x);
  num meanY = _mean(y);
  double numerator = 0;
  for (int i = 0; i < x.length; i++) {
    numerator += math.pow(y[i] - meanY - (x[i] - meanX), 2);
  }
  return Complex(math.sqrt(numerator / (x.length - 2)));
});

/// Returns the t-Value of the list.
///
/// Example:
/// ```dart
/// print(tValue(1, 2, 3, 4, 5));
/// ```
dynamic tValue = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty || list.length == 1) return Complex(0);
  return Complex(_mean(list) / _stdErrMean(list));
});

/// Returns the 1st, 2nd, and 3rd quartiles of a list of numbers.
///
/// Example:
/// ```dart
/// print(quartiles(1, 2, 3, 4, 5, 6, 7)); // [2, 4, 6]
/// ```
dynamic quartiles = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty) return [0, 0, 0];

  list.sort();
  num q1 = _median(list.sublist(0, list.length ~/ 2));
  num q2 = _median(list);
  num q3 = _median(list.sublist((list.length + 1) ~/ 2));
  return [Complex(q1), Complex(q2), Complex(q3)];
});

num _median(List<num> list) {
  if (list.isEmpty) return 0;
  list.sort();
  if (list.length % 2 == 1) {
    return list[list.length ~/ 2];
  } else {
    return (list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2;
  }
}

/// Generates all permutations of elements from `n` taken `r` at a time.
///
/// Mimics the behavior of the `sample` function in R.
///
/// Parameters:
/// - `n`:
///   - If `n` is a positive integer, generates permutations from `1` to `n`.
///   - If `n` is a List, generates permutations from the elements of the list.
/// - `r`: The number of elements to take in each permutation (must be between 1 and the length of `n`).
/// - `func` (optional): A function to apply to each permutation.
/// - `simplify` (optional, default: true):
///   - If true, returns a flat List of results from applying `func` to each permutation.
///   - If false, returns a List of Lists, where each inner list contains the permutation and the result of applying `func`.
/// - `seed` (optional): A seed value for the random number generator to ensure repeatability.
/// - `random` (optional): Random number generator to ensure repeatability.
///
/// **Note:** When `simplify` is true, the structure of the result depends on the output of `func` for the first permutation. This might cause issues if `func` doesn't produce consistent output lengths.
///
/// Examples:
/// ```dart
/// print(permutations(3, 2)); // [[1, 2], [2, 1], [1, 3], [3, 1], [2, 3], [3, 2]]
/// ```
dynamic permutations(dynamic n, dynamic rInput,
    {Function? func, bool simplify = true, Random? random, int? seed}) {
  int r = rInput is Complex ? rInput.real.toInt() : (rInput as num).toInt();
  if (random == null) {
    random = seed != null ? Random(seed) : Random();
  } else if (seed != null) {
    throw ArgumentError("Cannot provide both seed and random");
  }

  if (n is int) {
    n = List<int>.generate(n, (i) => i + 1);
  } else if (n is! List) {
    throw ArgumentError("x must be an integer or a List");
  }
  if (r < 1 || r > n.length) {
    throw ArgumentError("m must be between 1 and the length of x");
  }

  List<List> result = [];

  void generatePermutations(int index, List<dynamic> current) {
    if (index == r) {
      result.add(List.from(current));
      return;
    }

    for (int i = 0; i < n.length; i++) {
      if (!current.contains(n[i])) {
        current.add(n[i]);
        generatePermutations(index + 1, current);
        current.removeLast();
      }
    }
  }

  generatePermutations(0, []);

  if (func != null) {
    if (simplify) {
      return result.map((perm) => func(perm)).toList();
    } else {
      return result.map((perm) => [perm, func(perm)]).toList();
    }
  } else {
    return result;
  }
}

/// Generates all combinations of elements from `n` taken `r` at a time.
///
/// Mimics the behavior of the `combinations` function in R.
///
/// Parameters:
/// - `n`:
///   - If `n` is a positive integer, generates combinations from `1` to `n`.
///   - If `n` is a List, generates combinations from the elements of the list.
/// - `r`: The number of elements to take in each combination (must be between 1 and the length of `n`).
/// - `func` (optional): A function to apply to each combination.
/// - `simplify` (optional, default: true):
///   - If true, returns a flat List of results from applying `func` to each combination.
///   - If false, returns a List of Lists, where each inner list contains the combination and the result of applying `func`.
/// - `generateCombinations` (optional, default: true):
///   - If true, generates the actual combinations.
///   - If false, only calculates and returns the number of possible combinations.
///
/// Examples:
/// ```dart
/// print(combinations(4, 3)); // [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]
/// ```
dynamic combinations(dynamic n, dynamic rInput,
    {Function? func, bool simplify = true, bool generateCombinations = true}) {
  int r = rInput is Complex ? rInput.real.toInt() : (rInput as num).toInt();
  if (n is int) {
    n = List<int>.generate(n, (i) => i + 1);
  } else if (n is! List) {
    throw ArgumentError("x must be an integer or a List");
  }

  if (r < 1 || r > n.length) {
    throw ArgumentError("m must be between 1 and the length of x");
  }

  if (!generateCombinations) {
    int x = n is int ? n : n.length;
    return factorial(x) ~/ (factorial(r) * factorial(x - r));
  }

  List<List> result = [];

  void getCombinations(int start, List<dynamic> current) {
    if (current.length == r) {
      result.add(List.from(current));
      return;
    }

    for (int i = start; i < n.length; i++) {
      current.add(n[i]);
      getCombinations(i + 1, current);
      current.removeLast();
    }
  }

  getCombinations(0, []);

  if (func != null) {
    if (simplify) {
      // Apply func to each combination and return a flat List
      return result.map((combo) => func(combo)).toList();
    } else {
      // Return a List of Lists with [combination, func(combination)]
      List results = [];
      for (var combo in result) {
        var funcResult = func(combo);
        if (results.isEmpty) {
          // Determine output structure based on the first result
          if (funcResult is List) {
            // If first result is a List, create nested Lists for all results
            results.add([combo, funcResult]);
          } else {
            // Otherwise, store results directly
            results.add(funcResult);
          }
        } else {
          // Process subsequent results based on the determined structure
          if (results[0] is List) {
            results.add([combo, funcResult]);
          } else {
            results.add(funcResult);
          }
        }
      }
      return results;
    }
  } else {
    return result;
  }
}

/// Alias for combinations.
dynamic nCr =
    (dynamic n, dynamic r) => combinations(n, r, generateCombinations: false);

/// Alias for permutations.
dynamic nPr = (dynamic n, dynamic r) => permutations(n, r).length;

/// Returns the greatest common factor (GCF) of a list of numbers.
///
/// Example:
/// ```dart
/// print(gcf(12, 18, 24)); // 6
/// ```
dynamic gcf = VarArgsFunction((args, kwargs) {
  List<num> numbers = _getArgsParams(args);
  if (numbers.isEmpty) {
    throw ArgumentError('List of numbers cannot be empty.');
  }

  num ggcf(num a, num b) {
    return b == 0 ? a : ggcf(b, a % b);
  }

  num result = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    result = ggcf(result, numbers[i]);
  }
  return Complex(result);
});

dynamic gcd = VarArgsFunction((args, _) {
  if (args.length == 2 &&
      args.any((e) =>
          e is! num && e is! Complex ||
          (e is String && e.contains(RegExp(r'[a-zA-Z]'))))) {
    return _toPoly(args[0]).gcd(_toPoly(args[1]));
  }

  List<num> numbers = _getArgsParams(args);
  if (numbers.isEmpty) {
    throw ArgumentError('List of numbers cannot be empty.');
  }

  // Sort and ensure all numbers are positive
  numbers = numbers.map((x) => x.abs()).toList()..sort();
  num a = numbers.removeAt(0);

  for (var b in numbers) {
    while (true) {
      if (b == 0) break;
      a %= b;
      if (a == 0) {
        a = b;
        break;
      }
      b %= a;
      if (b == 0) break;
    }
  }

  return Complex(a);
});

/// Extended Euclidean algorithm.
///
/// Returns a list of lists where each sublist contains `[d, x, y]` for each pair.
///
/// Example:
/// ```dart
/// print(egcd(48, 18, 24));  // Output: [[6, -1, 3], [6, -1, 1]]
/// ```
dynamic egcd = VarArgsFunction((args, kwargs) {
  List<num> numbers = _getArgsParams(args);

  List<List<Complex>> results = [];

  // Helper function to compute egcd for a pair of numbers
  List<Complex> egcdPair(num a, num b) {
    num x = 1, y = 0, x1 = 0, y1 = 1;
    while (b != 0) {
      num q = a ~/ b;
      num r = mod(a, b); // Modulo operation using custom function
      num x2 = x - q * x1;
      num y2 = y - q * y1;
      x = x1;
      y = y1;
      x1 = x2;
      y1 = y2;
      a = b;
      b = r;
    }
    return [Complex(a), Complex(x), Complex(y)];
  }

  // Iterate through pairs of numbers and compute egcd using the iterative function
  for (int i = 0; i < numbers.length - 1; i++) {
    results.add(egcdPair(numbers[i], numbers[i + 1]));
  }

  return results;
});

dynamic lcm = VarArgsFunction((args, _) {
  if (args.length == 2 &&
      args.any((e) =>
          e is! num && e is! Complex ||
          (e is String && e.contains(RegExp(r'[a-zA-Z]'))))) {
    return _toPoly(args[0]).lcm(_toPoly(args[1]));
  }

  List<num> numbers = _getArgsParams(args);
  if (numbers.isEmpty) {
    throw ArgumentError('List of numbers cannot be empty.');
  }

  num llcm(num a, num b) {
    if (a == 0 || b == 0) {
      return 0;
    } else {
      final g = (gcd as VarArgsFunction).callback([a, b], <String, dynamic>{});
      return (a * b) / (g is Complex ? g.real : g as num);
    }
  }

  num result = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    result = llcm(result, numbers[i]);
  }
  return Complex(result);
});

/// Returns the correlation of two lists.
///
/// Example:
/// ```dart
/// print(correlation([1,2,3], [1,2,3])); // 1.0
/// ```
dynamic correlation = VarArgsFunction((args, kwargs) {
  if (args.length != 2 || args[0] is! List || args[1] is! List) {
    throw ArgumentError('correlation requires two lists: x and y');
  }
  return Complex(_correlation(_toNumList(args[0]), _toNumList(args[1])));
});

/// Returns the confidence interval of a list of numbers.
///
/// Example:
/// ```dart
/// print(confidenceInterval([1,2,3], 0.95)); // [1.0, 3.0]
/// ```
dynamic confidenceInterval = VarArgsFunction((args, kwargs) {
  List<num> data;

  if (args.length >= 2 && args[0] is List) {
    data = _toNumList(args[0]);
    final confidence = args[1];
    if (confidence is! num && confidence is! Complex) {
      throw ArgumentError("confidenceLevel must be num or Complex");
    }
  } else {
    throw ArgumentError(
        "Usage: confidenceInterval(List<num> data, double confidenceLevel)");
  }

  num sampleMean = _mean(data);
  num stdErr = _stdErrMean(data);
  num margin = (tValue.callback(data, <String, dynamic>{}) as Complex).real * stdErr;
  return [Complex(sampleMean - margin), Complex(sampleMean + margin)];
});

/// Returns slope and intercept of two datasets.
///
/// Example:
/// ```dart
/// print(regression([1,2,3], [2,4,6])); // [2, 0]
/// ```
dynamic regression = VarArgsFunction((args, kwargs) {
  if (args.length != 2 || args[0] is! List || args[1] is! List) {
    throw ArgumentError('regression requires two lists: x and y');
  }
  List<num> x = _toNumList(args[0]);
  List<num> y = _toNumList(args[1]);

  num meanX = _mean(x);
  num meanY = _mean(y);

  num m = _correlation(x, y) * (_stdDev(y) / _stdDev(x));
  num b = meanY - m * meanX;

  return [Complex(m), Complex(b)];
});

/// A collection of statistical functions.
class Statistics {
  /// Returns the mean of a list of numbers.
  static dynamic mean(List<dynamic> args) =>
      (_flattenArgs(args).isNotEmpty) ? _mean(_getArgsParams(args)) : 0;

  /// Returns the median of a list of numbers.
  static dynamic median(List<dynamic> args) => _flattenArgs(args).isNotEmpty
      ? (median as VarArgsFunction).callback(args, <String, dynamic>{})
      : 0;

  /// Returns the mode of a list of numbers.
  static dynamic mode(List<dynamic> args) =>
      (mode as VarArgsFunction).callback(args, <String, dynamic>{});

  /// Returns the variance of a list of numbers.
  static dynamic variance(List<dynamic> args) =>
      (variance as VarArgsFunction).callback(args, <String, dynamic>{});

  /// Returns the standard deviation of a list of numbers.
  static dynamic stdDev(List<dynamic> args) =>
      (stdDev as VarArgsFunction).callback(args, <String, dynamic>{});

  /// Returns the quartiles of a list of numbers.
  static List<num> quartiles(List<num> list) => _quartiles(list);

  static List<num> _quartiles(List<num> list) {
    if (list.isEmpty) return [0, 0, 0];
    var sorted = List<num>.from(list)..sort();
    num q1 = _median(sorted.sublist(0, sorted.length ~/ 2));
    num q2 = _median(sorted);
    num q3 = _median(sorted.sublist((sorted.length + 1) ~/ 2));
    return [q1, q2, q3];
  }

  /// Returns the covariance of two lists.
  static double covariance(List<double> x, List<double> y) {
    if (x.length != y.length || x.isEmpty) return 0.0;
    final mx = x.reduce((a, b) => a + b) / x.length;
    final my = y.reduce((a, b) => a + b) / y.length;
    return x
            .asMap()
            .entries
            .fold(0.0, (s, e) => s + (e.value - mx) * (y[e.key] - my)) /
        x.length;
  }
}
