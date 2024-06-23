part of 'math.dart';

/// Returns the mean (average) of a list of numbers.
///
/// Example:
/// ```dart
/// print(mean([1, 2, 3, 4, 5])); // prints: 3.0
/// ```
num mean(List<num> list) {
  return list.reduce((a, b) => a + b) / list.length;
}

/// Returns the median of a list of numbers.
///
/// Example:
/// ```dart
/// print(median([1, 2, 3, 4, 5])); // prints: 3
/// ```
num median(List<num> list) {
  list.sort();
  if (list.length % 2 == 1) {
    return list[list.length ~/ 2];
  } else {
    return (list[list.length ~/ 2 - 1] + list[list.length ~/ 2]) / 2;
  }
}

/// Returns the mode (most common element(s)) of a list of numbers.
///
/// Example:
/// ```dart
/// print(mode([1, 2, 2, 3, 3, 4])); // prints: [2, 3]
/// ```
List<num> mode(List<num> list) {
  Map<num, int> freqMap = {};
  for (num item in list) {
    freqMap[item] = (freqMap[item] ?? 0) + 1;
  }

  var maxFreq = freqMap.values.reduce(math.max);
  return freqMap.entries
      .where((entry) => entry.value == maxFreq)
      .map((entry) => entry.key)
      .toList();
}

/// Returns the variance of a list of numbers.
///
/// Example:
/// ```dart
/// print(variance([1, 2, 3, 4, 5])); // prints: 2.5
/// ```
double variance(List<num> list) {
  num m = mean(list);
  return list.map((num x) => math.pow(x - m, 2)).reduce((a, b) => a + b) /
      (list.length - 1);
}

/// Returns the standard deviation of a list of numbers.
///
/// Example:
/// ```dart
/// print(stdDev([1, 2, 3, 4, 5])); // prints: 1.5811388300841898
/// ```
double stdDev(List<num> list) {
  return sqrt(variance(list));
}

/// Returns the standard deviation of a list of numbers.
///
/// Example:
/// ```dart
/// print(standardDeviation([1, 2, 3, 4, 5])); // prints: 1.5811388300841898
/// ```
double standardDeviation(List<num> list) => stdDev(list);

/// Returns the standard error of the sample mean
///
/// Example:
/// ```
/// print(stdErrMean([1, 2, 3, 4, 5])); // prints: 0.7071067811865476
/// ```
double stdErrMean(List<num> list) {
  // if the list is empty or has only one element
  if (list.isEmpty || list.length == 1) return 0;

  return stdDev(list) / sqrt(list.length);
}

/// Standard error of estimate
///
/// Example:
/// ```
/// print(stdErrEst([1, 2, 3, 4, 5])); // prints: 0.6324555320336759
/// ```
double stdErrEst(List<num> x, List<num> y) {
  num meanX = mean(x);
  num meanY = mean(y);
  double numerator = 0;
  for (int i = 0; i < x.length; i++) {
    numerator += pow(y[i] - meanY - (x[i] - meanX), 2);
  }
  return sqrt(numerator / (x.length - 2));
}

/// Returns the t-Value of the list
/// Example:
/// ```
/// print(tValue([1, 2, 3, 4, 5])); // prints: 4.242640687119285
/// ```
double tValue(List<num> list) {
  // if the list is empty or has only one element
  if (list.isEmpty || list.length == 1) return 0;

  // Calculate the t-Value
  return mean(list) / stdErrMean(list);
}

/// Returns the 1st, 2nd, and 3rd quartiles of a list of numbers.
///
/// Example:
/// ```dart
/// print(quartiles([1, 2, 3, 4, 5, 6, 7, 8, 9])); // prints: [2.5, 5, 7.5]
/// ```
List<num> quartiles(List<num> list) {
  list.sort();
  num q1 = median(list.sublist(0, list.length ~/ 2));
  num q2 = median(list);
  num q3 = median(list.sublist((list.length + 1) ~/ 2));
  return [q1, q2, q3];
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
///
/// 1. Get all permutations of 2 elements from [1, 2, 3]:
/// ```dart
/// var permutationsList = permutation(3, 2);
/// print(permutationsList);
/// // Output: [[1, 2], [2, 1], [1, 3], [3, 1], [2, 3], [3, 2]]
/// ```
///
/// 2. Calculate the product of each permutation:
/// ```dart
/// var productPermutations = permutation(3, 2,
///     func: (perm) => perm.reduce((a, b) => a * b));
/// print(productPermutations); // Output: [2, 2, 3, 3, 6, 6] (simplified)
/// ```
/// 3. Get the length of the permutations:
/// ```dart
/// print(permutations(5, 3).length); // Output: 60
/// ```
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
/// **Note:** When `simplify` is true, the structure of the result depends on the output of `func` for the first combination.
/// This might cause issues if `func` doesn't produce consistent output lengths.
///
/// Examples:
///
/// 1. Get all combinations of 3 elements from [1, 2, 3, 4]:
/// ```dart
/// var combinations = combinations(4, 3);
/// print(combinations); // Output: [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]
/// ```
///
/// 2. Calculate the sum of each combination:
/// ```dart
/// var sumCombinations = combinations(4, 3,
///     func: (comb) => comb.reduce((a, b) => a + b));
/// print(sumCombinations); // Output: [6, 7, 8, 9] (simplified)
/// ```
///
/// 3. Get combinations of letters and apply a function (not simplified):
/// ```dart
/// var alphaCombn = combinations(["A", "B", "C", "D"], 2, simplify: false);
/// print(alphaCombn);
/// // Output:
/// // [["A", "B"], ["A", "C"], ["A", "D"], ["B", "C"], ["B", "D"], ["C", "D"]]
/// ```
///
/// 4. Calculate the minimum of consecutive elements in each combination:
/// ```dart
/// var minCombo = combinations(4, 3, simplify: true, func: (comb) {
///   List<num> result = [];
///   for (int i = 0; i < comb.length - 1; i++) {
///     result.add(min(comb[i], comb[i + 1]));
///   }
///   return result;
/// });
/// print(minCombo); // Output: [[1, 2], [1, 2], [1, 3], [2, 3]]
/// ```
///
/// 5. Get the number of combinations
/// ```dart
/// print(combinations(5, 3).length); // Output: 10
/// ```
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

/// Returns the greatest common divisor of a list of numbers.
///
/// This function uses the Euclidean algorithm to compute the GCD.
///
/// Parameters:
///  - [numbers]: A list of numbers for which the GCD is computed.
///
/// Returns:
///  - An integer representing the GCD of the provided numbers.
///
/// Example:
/// ```dart
/// print(gcdList([48, 18, 24]));  // Output: 6
/// ```
num gcd(List<num> numbers) {
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
}

/// Returns the least common multiple of two numbers.
///
/// Example:
/// ```dart
/// print(lcm(15, 20));  // Output: 60
/// ```
int lcm(num a, num b) {
  if (a == 0 || b == 0) {
    return 0;
  } else {
    num hcf = gcd([a, b]);
    return ((a * b) ~/ hcf).abs();
  }
}

/// Returns the correlation of two lists
///
/// Example:
/// ```dart
/// print(correlation(x,y));
/// ```
double correlation(List<num> x, List<num> y) {
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
}

/// Returns the confidence Interval of a dataset when a confidence level is provided
///
/// Example:
/// ```dart
/// print(confidence([1, 2, 3, 4, 5])
/// ```
List<num> confidenceInterval(List<num> data, double confidenceLevel) {
  num sampleMean = mean(data);
  num stdErr = stdErrMean(data);
  num margin = tValue(data) * stdErr;
  return [sampleMean - margin, sampleMean + margin];
}

/// Returns slope and intercept of two datasets
List<num> regression(List<num> x, List<num> y) {
  num meanX = mean(x);
  num meanY = mean(y);

  num m = correlation(x, y) * (stdDev(y) / stdDev(x));
  num b = meanY - m * meanX;

  return [m, b]; // slope, intercept
}
