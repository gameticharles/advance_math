part of maths;

/// Returns the sum of all numbers up to `n`.
///
/// Example:
/// ```dart
/// print(sum(5)); // prints: 15
/// ```
int sum(int n) {
  return n * (n + 1) ~/ 2;
}

/// Returns the absolute value of a number.
///
/// Example:
/// ```dart
/// print(abs(-5));  // Output: 5
/// ```
num abs(num x) => x.abs();

/// Returns the square root of a number.
///
/// Example:
/// ```dart
/// print(sqrt(9));  // Output: 3.0
/// ```
double sqrt(num x) => math.sqrt(x);

/// Returns the cube root of a number.
///
/// Example:
/// ```dart
/// print(cbrt(8));  // Output: 2.0
/// ```
num cbrt(num x) {
  return math.pow(x, 1 / 3);
}

/// Returns the natural exponentiation of a number.
///
/// Example:
/// ```dart
/// print(exp(1));  // Output: 2.718281828459045
/// ```
double exp(num x) => math.exp(x);

/// Raises a number to the power of another number.
///
/// Example:
/// ```dart
/// print(pow(2, 3));  // Output: 8.0
/// ```
num pow(num x, num y) => math.pow(x, y);

/// Rounds a number down to the nearest integer.
///
/// Example:
/// ```dart
/// print(floor(2.3));  // Output: 2
/// ```
int floor(num x) => x.floor();

/// Rounds a number up to the nearest integer.
///
/// Example:
/// ```dart
/// print(ceil(2.3));  // Output: 3
/// ```
int ceil(num x) => x.ceil();

/// Rounds a number to the nearest integer.
///
/// Example:
/// ```dart
/// print(round(2.5));  // Output: 3
/// ```
int round(num x) => x.round();

/// Returns the maximum of two or more numbers.
///
/// Example:
/// ```dart
/// print(max(2, 3));  // Output: 3
/// ```
//num max(num x, num y) => math.max(x, y);
T max<T extends num>(T a, T b) => math.max(a, b);

/// Returns the minimum of two or more numbers.
///
/// Example:
/// ```dart
/// print(min(2, 3));  // Output: 2
/// ```
T min<T extends num>(T a, T b) => math.min(a, b);

/// Returns the hypotenuse or Euclidean norm, sqrt(xx + yy).
///
/// Example:
/// ```dart
/// print(hypot(3, 4));  // Output: 5.0
/// ```
num hypot(num x, num y) {
  return math.sqrt(x * x + y * y);
}

/// Returns the sign of a number.
///
/// Example:
/// ```dart
/// print(sign(-15));  // Output: -1
/// ```
int sign(num x) {
  return x < 0 ? -1 : (x > 0 ? 1 : 0);
}

/// Clamps x between min and max.
///
/// Example:
/// ```dart
/// print(clamp(10, 1, 5));  // Output: 5
/// ```
num clamp(num x, num min, num max) {
  return x < min ? min : (x > max ? max : x);
}

/// Linear interpolation between a and b by t.
///
/// Example:
/// ```dart
/// print(lerp(0, 10, 0.5));  // Output: 5.0
/// ```
num lerp(num a, num b, num t) {
  return a + (b - a) * t;
}

/// Checks if a number is even.
///
/// Example:
/// ```dart
/// print(isEven(6)); // prints: true
/// ```
bool isEven(int n) {
  return n % 2 == 0;
}

/// Checks if a number is odd.
///
/// Example:
/// ```dart
/// print(isOdd(5)); // prints: true
/// ```
bool isOdd(int n) {
  return n % 2 != 0;
}

/// Checks if a number is prime.
///
/// Example:
/// ```dart
/// print(isPrime(11));  // Output: true
/// ```
bool isPrime(int n) {
  if (n <= 1) {
    return false;
  }
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) {
      return false;
    }
  }
  return true;
}

/// Checks if a number is a perfect square.
///
/// Example:
/// ```dart
/// print(isPerfectSquare(9)); // prints: true
/// ```
bool isPerfectSquare(int n) {
  int x = sqrt(n).toInt();
  return x * x == n;
}

/// Checks if a number is a perfect cube.
///
/// Example:
/// ```dart
/// print(isPerfectCube(8)); // prints: true
/// ```
bool isPerfectCube(int n) {
  int x = pow(n, 1 / 3).round();
  return x * x * x == n;
}

/// Checks if a number is in the Fibonacci sequence.
///
/// Example:
/// ```dart
/// print(isFibonacci(8)); // prints: true
/// ```
bool isFibonacci(int n) {
  int x = 5 * n * n;
  return isPerfectSquare(x + 4) || isPerfectSquare(x - 4);
}

/// Checks if a number [n] is a palindrome.
///
/// Example:
/// ```dart
/// final result = isPalindrome(545);
/// print(result); // prints: true
/// ```
bool isPalindrome(int n) {
  int r, sum = 0, temp;
  temp = n;
  while (n > 0) {
    r = n % 10;
    sum = (sum * 10) + r;
    n = n ~/ 10;
  }
  if (temp == sum) return true;
  return false;
}

/// Checks if a number is an Armstrong number.
///
/// An Armstrong number is a number that is the sum of its own digits
/// each raised to the power of the number of digits.
///
/// Example:
/// ```dart
/// print(isArmstrongNumber(153));  // Output: true
/// print(isArmstrongNumber(123));  // Output: false
/// ```
///
/// The function takes an integer `n` as an argument and returns a boolean value indicating whether `n` is an Armstrong number.
bool isArmstrongNumber(int n) {
  String digits = n.toString();
  int numDigits = digits.length;
  int sum = 0;

  for (int i = 0; i < numDigits; i++) {
    int digit = int.parse(digits[i]);
    sum += math.pow(digit, numDigits).toInt();
  }

  return sum == n;
}

/// Returns the nth triangle number.
///
/// Example:
/// ```dart
/// print(nthTriangleNumber(5)); // prints: 15
/// ```
int nthTriangleNumber(int n) {
  return n * (n + 1) ~/ 2;
}

/// Returns the nth pentagonal number.
///
/// Example:
/// ```dart
/// print(nthPentagonalNumber(5)); // prints: 35
/// ```
int nthPentagonalNumber(int n) {
  return n * (3 * n - 1) ~/ 2;
}

/// Returns the nth hexagonal number.
///
/// Example:
/// ```dart
/// print(nthHexagonalNumber(5)); // prints: 45
/// ```
int nthHexagonalNumber(int n) {
  return n * (2 * n - 1);
}

/// Returns the nth tetrahedral number.
///
/// Example:
/// ```dart
/// print(nthTetrahedralNumber(5)); // prints: 35
/// ```
int nthTetrahedralNumber(int n) {
  return n * (n + 1) * (n + 2) ~/ 6;
}

/// Returns the nth harmonic number [n].
///
/// The nth harmonic number is the sum of the reciprocals of the first n
/// natural numbers.
///
/// Example:
/// ```dart
/// final result = nthHarmonicNumber(5);
/// print(result); // prints: 2.283333333333333
/// ```
double nthHarmonicNumber(int n) {
  double harmonic = 0.0;
  for (int i = 1; i <= n; i++) {
    harmonic += 1 / i.toDouble();
  }
  return harmonic;
}

/// Returns the factorial of a number.
///
/// Example:
/// ```dart
/// print(factorial(5));  // Output: 120
/// ```
int factorial(int n) {
  if (n < 0) throw ArgumentError('Negative numbers are not allowed.');
  return n <= 1 ? 1 : n * factorial(n - 1);
}

/// Generates all primes up to n.
///
/// Example:
/// ```dart
/// print(sieve(30));  // Output: [2, 3, 5, 7, 11, 13, 17, 19, 23, 29]
/// ```
List<num> sieve(int n) {
  List<bool> prime = List<bool>.filled(n + 1, true, growable: false);
  prime[0] = prime[1] = false;
  for (int p = 2; p * p <= n; p++) {
    if (prime[p]) {
      for (int i = p * p; i <= n; i += p) {
        prime[i] = false;
      }
    }
  }
  List<num> primes = [];
  for (int i = 2; i <= n; i++) {
    if (prime[i]) {
      primes.add(i);
    }
  }
  return primes;
}

/// Returns the nth Fibonacci number.
///
/// Example:
/// ```dart
/// print(fib(7));  // Output: 13
/// ```
num fib(int n) {
  if (n <= 0) {
    return 0;
  } else if (n == 1) {
    return 1;
  } else {
    return fib(n - 1) + fib(n - 2);
  }
}

/// Returns a list of Fibonacci numbers from the start to the end.
///
/// Example:
/// ```dart
/// print(fibRange(5, 7));  // Output: [5, 8, 13]
/// ```
List<num> fibRange(int start, int end) {
  if (end <= 0) {
    return [];
  }

  List<num> fibNumbers = [0, 1];

  // Generate Fibonacci numbers up to the end index.
  for (int i = 2; i <= end; i++) {
    fibNumbers.add(fibNumbers[i - 1] + fibNumbers[i - 2]);
  }

  // Return the sublist from the start index to the end index (inclusive).
  return fibNumbers.sublist(start, end + 1);
}

/// Returns a list of all divisors of a number.
///
/// Example:
/// ```dart
/// print(getDivisors(28));  // Output: [1, 2, 4, 7, 14, 28]
/// ```
List<int> getDivisors(int n) {
  List<int> divisors = [];
  for (int i = 1; i <= n; i++) {
    if (n % i == 0) {
      divisors.add(i);
    }
  }
  return divisors;
}

/// Checks if a number is pandigital.
///
/// A pandigital number is an integer that in a given
/// base has among its significant digits each digit used in the base at least once.
///
/// Example:
/// ```dart
/// print(isPandigital(1234567890));  // Output: true
/// print(isPandigital(123456789));  // Output: false
/// ```
bool isPandigital(int n) {
  List<int> digits = getDigits(n);
  digits.sort();
  for (int i = 0; i < digits.length; i++) {
    if (digits[i] != i + 1) {
      return false;
    }
  }
  return true;
}

/// Returns a list of digits of a number.
///
/// Example:
/// ```dart
/// print(getDigits(1234));  // Output: [1, 2, 3, 4]
/// ```
List<int> getDigits(int n) {
  return n.toString().split('').map(int.parse).toList();
}

/// Checks if a number is a perfect number.
/// A perfect number is a positive integer that is equal to the sum of its positive divisors,
/// excluding the number itself.
///
/// Example:
/// ```dart
/// print(isPerfectNumber(6));  // Output: true
/// print(isPerfectNumber(28));  // Output: true
/// print(isPerfectNumber(12));  // Output: false
/// ```
bool isPerfectNumber(int n) {
  int sum = 1;
  for (int i = 2; i * i <= n; i++) {
    if (n % i == 0) {
      if (i * i != n) {
        sum = sum + i + n ~/ i;
      } else {
        sum = sum + i;
      }
    }
  }
  // If sum of divisors is equal to n and n is not 1
  return sum == n && n != 1;
}

/// Returns the nth prime number.
/// The nth prime number is the number that holds the nth position in the list of prime numbers.
///
/// Example:
/// ```dart
/// print(nthPrime(3));  // Output: 5
/// print(nthPrime(5));  // Output: 11
/// print(nthPrime(10));  // Output: 29
/// ```
int nthPrime(int n) {
  if (n < 1) throw ArgumentError('n must be greater than 0');
  List<int> primes = [];
  for (int i = 2; primes.length < n; i++) {
    if (isPrime(i)) {
      primes.add(i);
    }
  }
  return primes.last;
}

/// Returns the binomial coefficient, often referred to as "n choose k".
/// The binomial coefficient is the number of ways to choose k items from n items without repetition and without order.
///
/// Example:
/// ```dart
/// print(binomialCoefficient(5, 2));  // Output: 10
/// print(binomialCoefficient(6, 3));  // Output: 20
/// print(binomialCoefficient(7, 4));  // Output: 35
/// ```
int binomialCoefficient(int n, int k) {
  if (k < 0 || k > n) throw ArgumentError('k must be between 0 and n');
  if (k > n - k) k = n - k;
  int result = 1;
  for (int i = 0; i < k; i++) {
    result *= n - i;
    result ~/= i + 1;
  }
  return result;
}
