part of 'math.dart';

// Helper to flatten args
List<dynamic> _flattenArgs(List<dynamic> args) {
  if (args.isEmpty) return [];
  if (args.length == 1 && args.first is List) {
    return args.first as List;
  }
  return args;
}

List<num> _getArgsParams(List<dynamic> args) {
  return _flattenArgs(args).map((e) {
    if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
    return e as num;
  }).toList();
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
dynamic sum = VarArgsFunction((args, kwargs) {
  var list = _flattenArgs(args);
  if (list.isEmpty) return 0;

  var nums = list.map((e) {
    if (e is Complex && e.isReal && e.imaginary == 0) return e.real;
    return e;
  }).toList();

  if (nums.any((e) => e is Complex)) {
    return nums
        .map((e) => e is Complex ? e : Complex(e, 0))
        .reduce((a, b) => a + b);
  }
  return nums.cast<num>().reduce((a, b) => a + b);
});

/// Returns the mean (average) of a list of numbers.
///
/// Example:
/// ```dart
/// print(mean([1, 2, 3, 4, 5])); // prints: 3.0
/// print(mean(1, 2, 3, 4, 5));   // prints: 3.0
/// ```
dynamic mean = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty) return 0;
  return list.reduce((a, b) => a + b) / list.length;
});

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
  if (list.isEmpty) return 0; // Or throw?
  list.sort();
  if (list.length % 2 == 1) {
    return list[list.length ~/ 2];
  } else {
    return (list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2;
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
      .map((entry) => entry.key)
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
dynamic variance = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.length < 2) return 0.0;

  num m = mean(list);
  return list.map((num x) => math.pow(x - m, 2)).reduce((a, b) => a + b) /
      (list.length - 1);
});

/// Returns the standard deviation of a list of numbers.
///
/// Calculates the sample standard deviation.
///
/// Example:
/// ```dart
/// print(stdDev(1, 2, 3, 4, 5)); // ~1.58
/// ```
dynamic stdDev = VarArgsFunction((args, kwargs) {
  return sqrt(variance(args, kwargs: kwargs));
});

/// Returns the standard deviation of a list of numbers.
dynamic standardDeviation = stdDev;

/// Returns the standard error of the sample mean.
///
/// Example:
/// ```dart
/// print(stdErrMean(1, 2, 3, 4, 5)); // ~0.707
/// ```
dynamic stdErrMean = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty || list.length == 1) return 0;
  return stdDev(list) / sqrt(list.length);
});

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
  List<num> x = (args[0] as List).cast<num>();
  List<num> y = (args[1] as List).cast<num>();

  num meanX = mean(x);
  num meanY = mean(y);
  double numerator = 0;
  for (int i = 0; i < x.length; i++) {
    numerator += pow(y[i] - meanY - (x[i] - meanX), 2);
  }
  return sqrt(numerator / (x.length - 2));
});

/// Returns the t-Value of the list.
///
/// Example:
/// ```dart
/// print(tValue(1, 2, 3, 4, 5));
/// ```
dynamic tValue = VarArgsFunction((args, kwargs) {
  List<num> list = _getArgsParams(args);
  if (list.isEmpty || list.length == 1) return 0;
  return mean(list) / stdErrMean(list);
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
  num q1 = median(list.sublist(0, list.length ~/ 2));
  num q2 = median(list);
  num q3 = median(list.sublist((list.length + 1) ~/ 2));
  return [q1, q2, q3];
});

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
dynamic permutations(dynamic n, int r,
    {Function? func, bool simplify = true, Random? random, int? seed}) {
  // Initialize random number generator with seed (if provided)
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
      result.add(List.from(current)); // Add a copy of the permutation
      return;
    }

    for (int i = 0; i < n.length; i++) {
      if (!current.contains(n[i])) {
        // Avoid duplicates
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
dynamic combinations(dynamic n, int r,
    {Function? func, bool simplify = true, bool generateCombinations = true}) {
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
    return factorial(x) ~/
        (factorial(r) * factorial(x - r)); // Return count as a List
  }

  List<List> result = [];

  void getCombinations(int start, List<dynamic> current) {
    if (current.length == r) {
      result.add(List.from(current)); // Add a copy of the combination
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

/// Calculates the greatest common factor (GCF) of all numbers in the input.
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
  return result;
});

/// Returns the greatest common divisor of a list of numbers.
///
/// Example:
/// ```dart
/// print(gcd(48, 18, 24));  // Output: 6
/// ```
dynamic gcd = VarArgsFunction((args, kwargs) {
  List<num> numbers = _getArgsParams(args);
  if (numbers.isEmpty) {
    throw ArgumentError('List of numbers cannot be empty.');
  }

  // Sort and ensure all numbers are positive
  numbers = numbers.map((x) => x.abs()).toList()..sort();

  num a = numbers.removeAt(0);

  for (var b in numbers) {
    while (true) {
      a %= b;
      if (a == 0) {
        a = b;
        break;
      }
      b %= a;
      if (b == 0) break;
    }
  }

  return a;
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

  List<List<num>> results = [];

  // Helper function to compute egcd for a pair of numbers
  List<num> egcdPair(num a, num b) {
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
    return [a, x, y];
  }

  // Iterate through pairs of numbers and compute egcd using the iterative function
  for (int i = 0; i < numbers.length - 1; i++) {
    results.add(egcdPair(numbers[i], numbers[i + 1]));
  }

  return results;
});

/// Returns the least common multiple of numbers.
///
/// Example:
/// ```dart
/// print(lcm(15, 20));  // Output: 60
/// ```
dynamic lcm = VarArgsFunction((args, kwargs) {
  List<num> numbers = _getArgsParams(args);
  if (numbers.isEmpty) {
    throw ArgumentError('List of numbers cannot be empty.');
  }

  num llcm(num a, num b) {
    if (a == 0 || b == 0) {
      return 0;
    } else {
      return (a * b) / gcd(a, b);
    }
  }

  num result = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    result = llcm(result, numbers[i]);
  }
  return result;
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
  List<num> x = (args[0] as List).cast<num>();
  List<num> y = (args[1] as List).cast<num>();

  num meanX = mean(x);
  num meanY = mean(y);

  num numerator = 0;
  num denominator1 = 0;
  num denominator2 = 0;

  for (int i = 0; i < x.length; i++) {
    numerator += (x[i] - meanX) * (y[i] - meanY);
    denominator1 += pow(x[i] - meanX, 2);
    denominator2 += pow(y[i] - meanY, 2);
  }

  return numerator / sqrt(denominator1 * denominator2);
});

/// Returns the confidence Interval of a dataset when a confidence level is provided.
///
/// Example:
/// ```dart
/// print(confidenceInterval([1, 2, 3, 4, 5], 0.95));
/// ```
dynamic confidenceInterval = VarArgsFunction((args, kwargs) {
  // args[0] might be list, args[1] confidence level
  List<num> data;

  if (args.length >= 2 && args[0] is List && args[1] is num) {
    data = (args[0] as List).cast<num>();
    (args[1] as num).toDouble(); // Validate type
  } else {
    // If flattened? confidenceInterval(0.95, 1, 2, 3)? Ambiguous.
    // Let's assume strict (List, level) or (level, data).
    // Given the ambiguity, let's stick to (List, level).
    throw ArgumentError(
        "Usage: confidenceInterval(List<num> data, double confidenceLevel)");
  }

  num sampleMean = mean(data);
  num stdErr = stdErrMean(data);
  num margin = tValue(data) * stdErr;
  return [sampleMean - margin, sampleMean + margin];
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
  List<num> x = (args[0] as List).cast<num>();
  List<num> y = (args[1] as List).cast<num>();

  num meanX = mean(x);
  num meanY = mean(y);

  num m = correlation(x, y) * (stdDev(y) / stdDev(x));
  num b = meanY - m * meanX;

  return [m, b]; // slope, intercept
});
