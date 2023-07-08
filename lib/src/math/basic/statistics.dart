part of maths;

/// Returns the mean (average) of a list of numbers.
///
/// Example:
/// ```dart
/// print(mean([1, 2, 3, 4, 5])); // prints: 3.0
/// ```
double mean(List<num> list) {
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
num variance(List<num> list) {
  double m = mean(list);
  return list.map((num x) => math.pow(x - m, 2)).reduce((a, b) => a + b) /
      list.length;
}

/// Returns the standard deviation of a list of numbers.
///
/// Example:
/// ```dart
/// print(standardDeviation([1, 2, 3, 4, 5])); // prints: 1.5811388300841898
/// ```
num standardDeviation(List<num> list) {
  return math.sqrt(variance(list));
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

/// Returns the number of ways to choose r items from n items without repetition and with order.
///
/// Example:
/// ```dart
/// print(permutations(5, 3));  // Output: 60
/// ```
int permutations(int n, int r) {
  return factorial(n) ~/ factorial(n - r);
}

/// Returns the number of ways to choose r items from n items without repetition and without order.
///
/// Example:
/// ```dart
/// print(combinations(5, 3));  // Output: 10
/// ```
int combinations(int n, int r) {
  return factorial(n) ~/ (factorial(r) * factorial(n - r));
}

/// Returns the greatest common divisor of two numbers.
///
/// Example:
/// ```dart
/// print(gcd(48, 18));  // Output: 6
/// ```
int gcd(num a, num b) {
  while (b != 0) {
    num t = b;
    b = a % b;
    a = t;
  }
  return a.toInt();
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
    int hcf = gcd(a, b);
    return ((a * b) ~/ hcf).abs();
  }
}
