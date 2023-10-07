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

/// Returns the correlation of two lists
///
/// Example:
/// ```dart
/// print(correlation());
/// ```
double correlation(List<double> x, List<double> y) {
  double meanX = mean(x);
  double meanY = mean(y);

  double numerator = 0;
  double denominator1 = 0;
  double denominator2 = 0;

  for (int i = 0; i < x.length; i++) {
    numerator += (x[i] - meanX) * (y[i] - meanY);
    denominator1 += pow(x[i] - meanX, 2);
    denominator2 += pow(y[i] - meanY, 2);
  }

  return numerator / sqrt(denominator1 * denominator2);
}

///
List<num> confidenceInterval(List<double> data, double confidenceLevel) {
  double sampleMean = mean(data);
  double stdErr = stdErrMean(data);
  double margin = tValue(data) * stdErr;
  return [sampleMean - margin, sampleMean + margin];
}

List regression(List<double> x, List<double> y) {
  double meanX = mean(x);
  double meanY = mean(y);

  double m = correlation(x, y) * (stdDev(y) / stdDev(x));
  double b = meanY - m * meanX;

  return [m, b]; // slope, intercept
}
