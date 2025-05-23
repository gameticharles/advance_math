part of "math.dart";

/// Returns the sum of all numbers up to `n`.
///
/// Example:
/// ```dart
/// print(sumTo(5)); // prints: 15
/// ```
int sumTo(int n) {
  return n * (n + 1) ~/ 2;
}

/// Sums all values from [start] to [end] (inclusive), stepping by [step].
///
/// Throws an [ArgumentError] if [step] is zero or its sign doesn’t allow
/// reaching [end] from [start].
///
/// Example:
/// ```dart
/// print(sumUpTo(1, 5));                 // 15  (1+2+3+4+5)
/// print(sumUpTo(5, 1, step: -1));       // 15  (5+4+3+2+1)
/// print(sumUpTo(1, 5));                 // 15
/// print(sumUpTo(5, 1, step: -1));       // 15
/// print(sumUpTo(7, 7));                 // 7
/// print(sumUpTo(0, 10, step: 2));       // 30  (0+2+4+6+8+10)
/// sumUpTo(1, 5, step: -1);              // throws ArgumentError
/// sumUpTo(2, 8, step: 0);               // throws ArgumentError
/// ```
num sumUpTo(num start, num end, {num step = 1}) {
  if (step == 0) {
    throw ArgumentError('Step cannot be zero');
  }
  if ((step > 0 && start > end) || (step < 0 && start < end)) {
    throw ArgumentError(
      'Invalid range: step direction must match range direction',
    );
  }

  num total = 0.0;
  for (var current = start;
       step > 0 ? current <= end : current >= end;
       current += step) {
    total += current;
  }
  return total;
}


/// Returns the absolute value of a number.
///
/// Example:
/// ```dart
/// print(abs(-5));  // Output: 5
/// ```
dynamic abs(dynamic x) => x.abs();

/// Returns the square root of a number.
///
/// Example:
/// ```dart
/// print(sqrt(9));  // Output: 3.0
/// ```
dynamic sqrt(dynamic x) {
  if (x is num) {
    if (x >= 0) {
      return math.sqrt(x);
    } else {
      return Complex(0, math.sqrt(-x));
    }
  } else if (x is Complex) {
    return x.sqrt();
  } else {
    throw ArgumentError('Input should be either num or Number');
  }
}

/// Returns the cube root of a number.
///
/// Example:
/// ```dart
/// print(cbrt(8));  // Output: 2.0
/// ```
dynamic cbrt(dynamic x) {
  return nthRoot(x, 3);
}

/// Returns the nth root of a number.
///
/// Example:
/// ```dart
/// // The cube root of 8 will be:
/// print(nthRoot(8, 3));  // Output: 2.0
/// ```
dynamic nthRoot(dynamic x, int nth) {
  if (x is num) {
    if (x >= 0) {
      return math.pow(x, 1 / nth);
    } else {
      return Complex(0, math.pow(-x, 1 / nth));
    }
  } else if (x is Complex) {
    return x.nthRoot(nth);
  } else {
    throw ArgumentError('Input should be either num or Number');
  }
}

/// Returns the natural exponentiation of a number.
///
/// Example:
/// ```dart
/// print(exp(1));  // Output: 2.718281828459045
/// ```
dynamic exp(dynamic x) {
  if (x is num) {
    return math.exp(x);
  } else if (x is Complex) {
    return x.exp();
  } else {
    throw ArgumentError('Input should be either num or Number');
  }
}

/// Raises a number to the power of another number.
///
/// Example 1:
/// ```dart
/// print(pow(2, 3));  // Output: 8.0
/// ```
///
/// Example 2:
/// ```
/// var xxx = Complex(1, 2);
/// print(pow(2, xxx));  // Output: 0.36691394948660344 + 1.9660554808224875i
/// ```
dynamic pow(dynamic x, dynamic exponent) {
  if (x is num) {
    if (exponent is num) {
      return math.pow(x, exponent);
    } else {
      return Complex(x, 0).pow(exponent);
    }
  } else if (x is Complex) {
    if (exponent is Complex) {
      return x.pow(exponent);
      
    }
    return x.pow(exponent);
  } else {
    throw ArgumentError('Input should be either num or Number');
  }
}

/// Heaviside step function.
///
/// [x] is the input value.
///
/// Specification: [http://mathworld.wolfram.com/HeavisideStepFunction.html]
/// If x > 0, returns 1.
/// If x == 0, returns 1/2.
/// If x < 0, returns 0.
///
/// Example:
/// ```dart
/// print(step(0.5));  // Output: 1
/// ```
double step(double x) {
  if (x > 0) return 1;
  if (x < 0) return 0;
  return 0.5;
}

/// Rectangle function.
///
/// [x] is the input value.
///
/// Specification: [http://mathworld.wolfram.com/RectangleFunction.html]
/// If |x| > 1/2, returns 0.
/// If |x| == 1/2, returns 1/2.
/// If |x| < 1/2, returns 1.
///
/// Example:
/// ```dart
/// print(rect(0.5));  // Output: 0.5
/// ```
dynamic rect(double x) {
  x = x.abs();
  if (x == 0.5) return x;
  if (x > 0.5) return 0;
  return 1;
}

/// Sinc function also called the "sampling function"
///
/// [x] is the input value.
///
/// Specification: [http://mathworld.wolfram.com/SincFunction.html]
/// If x == 0, returns 1.
/// Otherwise, returns sin(x)/x.
///
/// Example:
/// ```dart
/// print(sinc(1));    // Output: 0.8414709848078965 (approximate value of sin(1)/1)
/// ```
dynamic sinc(double x) {
  if (x == 0) return 1;
  return sin(x) / x;
}

/// Splits the passed [x] into its integer and fractional parts.
///
/// The [modF] function is an implementation of the C++ modf() function which
/// splits a floating-point number into its integer and fractional parts.
///
/// Example:
/// ```dart
/// var result = modF(4.56);
/// print(result.integer);  // Outputs: 4
/// print(result.fraction); // Outputs: 0.56
/// ```
///
/// The function returns a map containing two keys:
/// - `fraction`: The fractional part of the number.
/// - `integer`: The integer part of the number.
///
/// - Parameter [x]: The double value to be split.
/// - Returns: A map with keys `fraction` and `integer`.
({double fraction, int integer}) modF(double x) {
  var intP = floor(x);
  x.floor();
  return (fraction: x - intP, integer: intP);
}

/// Returns the remainder of the division of [a] by [b].
///
/// The [mod] function is an implementation of the C++ mod() function which
/// returns the remainder of the division of [a] by [b].
///
/// Example:
/// ```dart
/// print(mod(10, 3));  // Output: 1
/// ```
dynamic mod(dynamic a, dynamic b) {
  if (a is int && b is int) {
    return a % b;
  } else {
    return a - (a / b).floor() * b;
  }
}

/// Returns the modular inverse of 'a' mod 'm' if it exists.
///
/// Make sure 'm' > 0 and 'a' & 'm' are relatively prime.
///
/// - Parameter
///  [a] the number for which to find the modular inverse
///  [m] the modulus (must be > 0)
///
/// - Returns: the modular inverse of 'a' mod 'm', or null if it does not exist
///
/// Example:
/// ```dart
///  // Prints 3 since 2*3 mod 5 = 1
///  print(modInv(2, 5));
///
///  // Prints null because there is no
///  // modular inverse such that 4*x mod 18 = 1
///  print(modInv(4, 18));
/// ```
dynamic modInv(num a, num m) {
  if (m <= 0) throw ArgumentError("mod must be > 0");

  // Avoid a being negative
  a = ((a % m) + m) % m;

  var v = egcd([a, m]).first;
  num gcd = v[0];
  num x = v[1];

  if (gcd != 1) return null;
  return ((x + m) % m) % m;
}

/// Computes the value of C(N, R) % P using Fermat's Little Theorem.
///
/// This method calculates the binomial coefficient (N choose R) modulo P,
/// which is the number of ways to choose R elements from a set of N elements,
/// modulo a prime number P. The calculation is efficient and works for large
/// values of N and R.
///
/// Parameters:
/// - [N]: The total number of elements.
/// - [R]: The number of elements to choose.
/// - [P]: The prime modulus.
///
/// Returns:
/// - The value of C(N, R) % P.
///
/// Example:
///```dart
/// int N = 500;
/// int R = 250;
/// int P = 1000000007;
///
/// num actual = nChooseRModPrime(N, R, P);
/// print(actual); // 515561345
///```
dynamic nChooseRModPrime(int N, int R, int P) {
  if (R == 0) return 1;

  List<num> factorial = List.filled(N + 1, 0);
  factorial[0] = 1;

  for (int i = 1; i <= N; i++) {
    factorial[i] = (factorial[i - 1] * i) % P;
  }

  return ((factorial[N] *
          modInv(factorial[R], P) %
          P *
          modInv(factorial[N - R], P) %
          P) %
      P);
}

/// Computes the value of C(N, R) % P using BigInt for large numbers.
///
/// This method calculates the binomial coefficient (N choose R) modulo P,
/// which is the number of ways to choose R elements from a set of N elements,
/// modulo a prime number P. This version uses BigInt to handle very large
/// numbers, ensuring accurate results for large N and R values.
///
/// Parameters:
/// - [N]: The total number of elements.
/// - [R]: The number of elements to choose.
/// - [P]: The prime modulus.
///
/// Returns:
/// - The value of C(N, R) % P as a BigInt.
///
/// Example:
///```dart
/// int N = 500;
/// int R = 250;
/// int P = 1000000007;
///
/// num actual = bigIntNChooseRModPrime(N, R, P);
/// print(actual); // 515561345
///```
BigInt bigIntNChooseRModPrime(int N, int R, int P) {
  if (R == 0) return BigInt.one;

  BigInt num = BigInt.one;
  BigInt den = BigInt.one;
  BigInt pBigInt = BigInt.from(P);

  while (R > 0) {
    num *= BigInt.from(N);
    den *= BigInt.from(R);

    BigInt gcd = num.gcd(den);
    num = num ~/ gcd;
    den = den ~/ gcd;

    N--;
    R--;
  }

  num = num ~/ den;
  num = num % pBigInt;

  return num;
}

/// Rounds a number down to the nearest integer.
///
/// Example:
/// ```dart
/// print(floor(2.3));  // Output: 2
/// ```
int floor(dynamic x) => x.floor();

/// Rounds a number up to the nearest integer.
///
/// Example:
/// ```dart
/// print(ceil(2.3));  // Output: 3
/// ```
int ceil(dynamic x) => x.ceil();

/// Rounds the number [x] to the specified number of [decimalPlaces].
///
/// If [decimalPlaces] is not provided or is 0, the function rounds [x]
/// to the nearest whole number. Otherwise, it rounds [x] to the desired
/// number of decimal places.
///
/// Example:
/// ```dart
/// print(round(123.4567, 2)); // Output: 123.46
/// print(round(123.4567));    // Output: 123
/// print(round(Complex(3.7, 2.9))); // Output: Complex(4, 3)
/// ```
///
/// [x] is the number to be rounded.
/// [decimalPlaces] specifies the number of decimal places to round to.
dynamic round(dynamic x, [int decimalPlaces = 0]) {
  if (x is num) {
    if (decimalPlaces == 0) {
      return x.round();
    } else {
      return (x * math.pow(10, decimalPlaces)).round() / math.pow(10, decimalPlaces);
    }
  } else if (x is Complex) {
    return x.roundTo(decimals: decimalPlaces).simplify();
  } else {
    throw ArgumentError('Input should be either num or Complex');
  }
}

/// Returns the maximum of two or more numbers.
///
/// Example:
/// ```dart
/// print(max(2, 3));  // Output: 3
/// ```
//num max(num x, num y) => math.max(x, y);
T max<T extends dynamic>(T a, T b) => (a > b) ? a : b;

/// Returns the minimum of two or more numbers.
///
/// Example:
/// ```dart
/// print(min(2, 3));  // Output: 2
/// ```
T min<T extends dynamic>(T a, T b) => (a < b) ? a : b;

/// Returns the hypotenuse or Euclidean norm, sqrt(xx + yy).
///
/// Example:
/// ```dart
/// print(hypot(3, 4));  // Output: 5.0
/// print(hypot(Complex(3, 0), Complex(0, 4))); // Output: 5.0
/// ```
dynamic hypot(dynamic x, dynamic y) {
  if (x is num && y is num) {
    return math.sqrt(x * x + y * y);
  } else {
    // Convert to Complex if needed
    Complex cx = x is Complex ? x : Complex(x, 0);
    Complex cy = y is Complex ? y : Complex(y, 0);
    
    // Calculate x² + y²
    Complex sumOfSquares = (cx * cx) + (cy * cy);
    
    // Take the square root and simplify
    return sqrt(sumOfSquares).simplify();
  }
}

/// Returns the sign of a number.
///
/// For complex numbers, returns the sign of the real part.
/// If the real part is zero, returns the sign of the imaginary part.
/// 
/// Example:
/// ```dart
/// print(sign(-15));  // Output: -1
/// print(sign(Complex(-3, 4))); // Output: -1
/// print(sign(Complex(0, -5))); // Output: -1
/// ```
dynamic sign(dynamic x) {
  if (x is num) {
    return x < 0 ? -1 : (x > 0 ? 1 : 0);
  } else if (x is Complex) {
    return x.sign;
  } else {
    throw ArgumentError('Input should be either num or Complex');
  }
}

/// Clamps x between min and max.
///
/// For complex numbers, clamps both real and imaginary parts separately.
///
/// Example:
/// ```dart
/// print(clamp(10, 1, 5));  // Output: 5
/// print(clamp(Complex(10, 7), 1, 5)); // Output: Complex(5, 5)
/// ```
dynamic clamp(dynamic x, num min, num max) {
  if (x is num) {
    return x < min ? min : (x > max ? max : x);
  } else if (x is Complex) {
    return x.clamp(min, max).simplify();
  } else {
    throw ArgumentError('Input should be either num or Complex');
  }
}

/// Linear interpolation between a and b by t.
///
/// Example:
/// ```dart
/// print(lerp(0, 10, 0.5));  // Output: 5.0
/// print(lerp(Complex(0, 0), Complex(10, 20), 0.5)); // Output: Complex(5, 10)
/// ```
dynamic lerp(dynamic a, dynamic b, num t) {
  if (a is num && b is num) {
    return a + (b - a) * t;
  } else {
    // Convert to Complex if needed
    Complex ca = a is Complex ? a : Complex(a, 0);
    Complex cb = b is Complex ? b : Complex(b, 0);
    
    // Calculate a + (b - a) * t
    Complex result = ca + ((cb - ca) * Complex(t, 0));
    return result.simplify();
  }
}

/// Converts polar coordinates (r, theta) to rectangular coordinates (x, y).
///
/// Parameters:
/// - `r`: The magnitude (radius) of the polar coordinates (as a `double`).
/// - `theta`: The angle of the polar coordinates (as a `double`).
/// - `isDegrees`: A boolean indicating if the angle `theta` is in degrees. Defaults to `false`.
///
/// Returns:
/// A Tuple containing the rectangular coordinates (x, y) as `double`.
///
/// Examples:
/// ```dart
/// print(rec(56, degToRad(27))); // {'x': 49.8963653545486, 'y': 25.42346798541462}
/// print(rec(56, 27, isDegrees: true)); // {'x': 49.8963653545486, 'y': 25.42346798541462}
/// ```
({double x, double y}) rec(num r, num theta, {bool isDegrees = false}) {
  if (isDegrees) {
    theta = toRadians(theta);
  }
  double x = r.toDouble() * cos(theta);
  double y = r.toDouble() * sin(theta);
  return (x: x, y: y);
}

/// Converts rectangular coordinates (x, y) to polar coordinates (r, theta).
///
/// Parameters:
/// - `x`: The x-coordinate of the rectangular coordinates (as a `num`).
/// - `y`: The y-coordinate of the rectangular coordinates (as a `num`).
/// - `isDegrees`: A boolean indicating if the angle `theta` should be returned in degrees. Defaults to `false`.
///
/// Returns:
/// A Tuple containing the polar coordinates (r, theta) as `double`.
///
/// Examples:
/// ```dart
/// print(pol(49.8963653545486, 25.42346798541462)); // {'r': 56.0, 'theta': 0.471238898038469}
/// print(pol(49.8963653545486, 25.42346798541462, isDegrees: true)); // {'r': 56.0, 'theta': 27.000000000000004}
/// ```
({double r, double theta}) pol(num x, num y, {bool isDegrees = false}) {
  double r = sqrt(x * x + y * y);
  double theta = atan2(y, x);
  if (isDegrees) {
    theta = toDegrees(theta);
  }
  return (r: r, theta: theta);
}

/// Determines whether two floating-point numbers are approximately equal.
///
/// This function checks if the absolute difference between two numbers is less than
/// or equal to the maximum of:
/// - An absolute tolerance value [absTol]
/// - A relative tolerance value [relTol] multiplied by the maximum absolute value of the inputs
///
/// This approach handles both small and large numbers appropriately.
///
/// Parameters:
///  - [a]: First floating-point number to compare
///  - [b]: Second floating-point number to compare
///  - [relTol]: Relative tolerance (default: 1e-9)
///  - [absTol]: Absolute tolerance (default: 1e-15)
///
/// Returns:
///  - `true` if the numbers are approximately equal, `false` otherwise
///
/// Example:
/// ```dart
/// print(isClose(0.1 + 0.2, 0.3)); // true
/// print(isClose(1e10, 1.00001e10)); // true
/// print(isClose(1.0, 1.1)); // false
/// ```
bool isClose(double a, double b, {double relTol = 1e-9, double absTol = 1e-15}) {
  return (a - b).abs() <= max(absTol, relTol * max(a.abs(), b.abs()));
}

/// Checks if the provided string characters [input] are a digit(s) (0-9).
///
/// ```dart
/// print(isDigit('5')); // true
/// print(isDigit('a')); // false
/// print(isDigit('12345')); // true
/// print(isDigit('123a45'));   // false
/// ```
bool isDigit(String input) {
  if (input.length == 1) {
    return input.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        input.codeUnitAt(0) <= '9'.codeUnitAt(0);
  } else {
    return input.split('').every((c) => isDigit(c));
  }
}

/// Checks if the provided string characters [input] are alphabetic letter(s) (A-Z, a-z).
///
/// ```dart
/// print(isAlpha('a')); // true
/// print(isAlpha('5')); // false
/// print(isAlpha('Hello')); // true
/// print(isAlpha('Hello1')); // false
/// ```
bool isAlpha(String input) {
  if (input.length == 1) {
    return (input.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
            input.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
        (input.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
            input.codeUnitAt(0) <= 'z'.codeUnitAt(0));
  } else {
    return input.split('').every((c) => isAlpha(c));
  }
}

/// Checks if the provided character [input] is alphanumeric (A-Z, a-z, 0-9).
///
/// ```dart
/// print(isAlphaNumeric('a')); // true
/// print(isAlphaNumeric('5')); // true
/// print(isAlphaNumeric('@')); // false
/// print(isAlphaNumeric('Hello123')); // true
/// print(isAlphaNumeric('Hello@123'));  // false
/// ```
bool isAlphaNumeric(String input) {
  if (input.length == 1) {
    return isDigit(input) || isAlpha(input);
  } else {
    return input.split('').every((c) => isAlphaNumeric(c));
  }
}

/// Checks if a number [n] is divisible by a another number [divisor].
///
/// Example:
/// ```dart
/// print(isDivisible(8, 4)); // prints: true
/// ```
bool isDivisible(num n, num divisor) {
  return n % divisor == 0;
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

/// Checks if a number is prime using trial division for small numbers and Rabin-Miller for large numbers.
///
/// The method performs the Rabin-Miller probabilistic test for primality.
/// It is efficient and has a very low failure rate, making it suitable for
/// testing large numbers for primality with high confidence.
///
/// Parameters:
/// - [number]: The number (int, BigInt, or String) to be tested for primality.
/// - [certainty]: The number of iterations to run the Rabin-Miller test. Higher values increase
///   the confidence that the number is prime. Default is 12.
///
/// Returns:
/// - `true` if the number is probably prime, `false` otherwise.
///
/// Throws:
/// - [ArgumentError] if the number is less than 2 or cannot be converted to a BigInt.
///
/// Example:
/// ```dart
/// print(isPrime(5));               // Output: true (int)
/// print(isPrime(BigInt.from(1433))); // Output: true (BigInt)
/// print(isPrime('567887653'));     // Output: true (String)
/// print(isPrime('75611592179197710042')); // Output: false (String)
/// print(isPrime(BigInt.parse('205561530235962095930138512256047424384916810786171737181163'))); // Output: true (BigInt)
/// ```
bool isPrime(dynamic number, [int certainty = 12]) {
  // Ensure valid input data type
  if (number is! int && number is! BigInt && number is! String) {
    throw ArgumentError(
        'Invalid input type. Number must be an int, BigInt, or String.');
  }

  BigInt n;
  try {
    n = BigInt.parse(number.toString());
  } on FormatException catch (_) {
    throw ArgumentError(
        'Invalid number format. String input must be a valid integer.');
  }

  // Handle base cases (less than 2 or even numbers)
  if (n < BigInt.from(2)) {
    return false;
  }

  if (n != BigInt.from(2) && n.isEven) {
    return false;
  }

  // Quick check for small numbers using trial division (efficient)
  if (n <= BigInt.from(3)) {
    return true;
  }
  if (n % BigInt.from(2) == BigInt.zero || n % BigInt.from(3) == BigInt.zero) {
    return false;
  }

  // handle if the last digit is even
  if (int.parse(number.toString()[number.toString().length - 1]) % 2 == 0) {
    return false;
  }

  // If the number is small, use trial division
  if (n.bitLength <= 31) {
    int num = n.toInt();
    int limit = sqrt(num).toInt();
    for (int i = 5; i <= limit; i += 6) {
      if (num % i == 0 || num % (i + 2) == 0) return false;
    }
    return true;
  }

  // For large numbers, use Rabin-Miller primality test
  BigInt s = n - BigInt.one;
  while (s.isEven) {
    s >>= 1;
  }

  for (int i = 0; i < certainty; i++) {
    BigInt r;
    do {
      r = Random.secure().nextBigInt(n);
    } while (r <= BigInt.zero);

    BigInt tmp = s;
    BigInt mod = r.modPow(tmp, n);

    while (
        tmp != n - BigInt.one && mod != BigInt.one && mod != n - BigInt.one) {
      mod = (mod * mod) % n;
      tmp <<= 1;
    }

    if (mod != n - BigInt.one && tmp.isEven) {
      return false;
    }
  }

  return true;
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
  if (n == 1) return 2; // Handle the 1st prime separately

  List<int> primes = [];
  for (int i = 2; primes.length < n; i++) {
    if (isPrime(i)) {
      primes.add(i);
    }
  }
  return primes.last;
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

/// Returns the integer part of a number by removing any fractional digits.
///
/// [x] is the input value.
///
/// If [x] is NaN, returns NaN.
/// If [x] is positive, returns the floor value of [x].
/// Otherwise, returns the ceil value of [x].
///
/// Example:
/// ``dart
/// print(trunc(4.7));  // Output: 4
/// print(trunc(-4.7)); // Output: -4
/// ```
double trunc(double x) {
  if (x.isNaN) return double.nan;
  if (x > 0) return x.floorToDouble();
  return x.ceilToDouble();
}

/// Returns the prime factors of the given integer [n].
///
/// The function computes the prime factorization of [n]
/// and returns a list of prime numbers that multiply together
/// to give the original number [n].
///
/// Example:
/// ```dart
/// List<int> factors = primeFactors(56);
/// print(factors); // Outputs: [2, 2, 2, 7]
/// ```
///
/// If [n] is less than 2, the returned list will be empty.
///
/// - Parameter n: The integer to factor.
/// - Returns: A list of prime factors of [n].
List<int> primeFactors(int n) {
  List<int> factors = [];

  // Divide n by 2 until it's odd
  while (n % 2 == 0) {
    factors.add(2);
    n ~/= 2;
  }

  // n must be odd at this point. So, we can skip one element (i.e., increment by 2)
  for (int i = 3; i * i <= n; i += 2) {
    // While i divides n, append i and divide n
    while (n % i == 0) {
      factors.add(i);
      n ~/= i;
    }
  }

  // This condition is to handle the case when n is a prime number greater than 2
  if (n > 2) {
    factors.add(n);
  }
  // Sort the factors
  factors.sort();

  return factors;
}

/// Returns the factors of the given integer [n].
///
/// The function computes and returns a list of positive integers
/// that are factors of [n].
///
/// Example:
/// ```dart
/// List<int> _factors = factors(12);
/// print(_factors); // Outputs: [1, 2, 3, 4, 6, 12]
/// ```
///
/// If [n] is less than 1, the returned list will be empty.
///
/// - Parameter n: The integer for which to find the factors.
/// - Returns: A list of factors of [n].
List<int> factors(int n) {
  List<int> factors = [];

  for (int i = 1; i <= n; i++) {
    if (n % i == 0) {
      factors.add(i);
    }
  }

  return factors;
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

/// Computes the numerical derivative of the function [f].
///
/// This function uses the central difference method to approximate the derivative.
///
/// Parameters:
///  - [f]: A function for which the derivative is computed.
///  - [h]: An optional small value used for the central difference approximation. Defaults to 0.001.
///
/// Returns:
///  - A function representing the derivative of [f].
///
/// Example:
/// ```dart
/// var myFunc = (double x) => x * x;
/// var myFuncPrime = diff(myFunc);
/// print(myFuncPrime(2));  // Output: Approximate derivative of myFunc at x=2
/// ```
Function diff(Function f, [double h = 0.001]) {
  num derivative(num x) {
    return (f(x + h) - f(x - h)) / (2 * h);
  }

  return derivative;
}

/// Approximates the definite integral of a function using Simpson's Rule.
///
/// The [f] parameter represents the function to be integrated.
/// The [a] and [b] parameters define the interval of integration.
/// The [step] parameter defines the step size and defaults to `0.0001` if not provided.
///
/// Example:
/// ```dart
/// // Example function: f(x) = x^2
/// double functionToEvaluate(double x) => x * x;
///
/// double result = simpson(functionToEvaluate, 0, 2);
/// print(result); // Output: 2.6666666666666665 (approximate value of the integral of x^2 from 0 to 2).
/// ```
double simpson(Function f, double a, double b, [double step = 0.0001]) {
  /// Returns the value of the function [f] evaluated at [x].
  /// If the value is NaN, tries to evaluate [f] slightly to the left or right based on [side].
  double getValue(Function f, double x, int side) {
    double v = f(x);
    double d = 0.000000000001;
    if (v.isNaN) {
      v = f(side == 1 ? x + d : x - d);
    }
    return v;
  }

  // Calculate the number of intervals
  int n = (b - a) ~/ step;
  // Simpson's rule requires an even number of intervals. If it's not, then add 1
  if (n % 2 != 0) n++;
  // Get the interval size
  double dx = (b - a) / n;
  // Get x0
  double retVal = getValue(f, a, 1);

  // Get the middle part 4x1+2x2+4x3 ...
  bool even = false;
  double xi = a + dx;
  double c, k;
  for (int i = 1; i < n; i++) {
    c = even ? 2 : 4;
    k = c * getValue(f, xi, 1);
    retVal += k;
    // Flip the even flag
    even = !even;
    // Increment xi
    xi += dx;
  }

  // Add xn
  return (retVal + getValue(f, xi, 2)) * (dx / 3);
}

/// Returns the integer part of the number [x].
///
/// The function calculates the integer part of [x] based on its sign.
/// It is similar to the `floor` function for positive numbers and the
/// `ceil` function for negative numbers.
///
/// Reference: [http://mathworld.wolfram.com/IntegerPart.html]
///
/// Example:
/// ```dart
/// print(integerPart(4.7));  // Output: 4
/// print(integerPart(-4.7)); // Output: -5
/// ```
int integerPart(double x) {
  int sign = x.sign.toInt();
  return sign * x.abs().floor();
}

/// Approximates the definite integral of a function using adaptive Simpson's method.
///
/// [f] is the function being integrated.
/// [a] is the lower bound.
/// [b] is the upper bound.
/// [tol] is the tolerance (default is 1e-9).
/// [maxDepth] is the maximum depth for recursion (default is 45).
///
/// Reference: [https://github.com/scijs/integrate-adaptive-simpson]
///
/// Returns the approximate value of the integral of [f] from [a] to [b].
///
/// Example:
/// ```dart
/// double functionToEvaluate(double x) {
///     return x * x;  // Example function: f(x) = x^2
///  }
///
/// double result = numIntegrate(functionToEvaluate, 0, 2);
/// print(result);  // Output: 2.666666666667 value of the integral of x^2 from 0 to 2
/// ```
double numIntegrate(Function f, double a, double b,
    [double tol = 1e-9, int maxDepth = 45]) {
  var state = {'maxDepthCount': 0, 'nanEncountered': false};

  double adsimp(Function f, double a, double b, double fa, double fm, double fb,
      double v0, double tol, int maxDepth, int depth) {
    double h = b - a;
    double f1 = f(a + h * 0.25);
    double f2 = f(b - h * 0.25);

    if (f1.isNaN || f2.isNaN) {
      state['nanEncountered'] = true;
      return double.nan;
    }

    double sl = h * (fa + 4 * f1 + fm) / 12;
    double sr = h * (fm + 4 * f2 + fb) / 12;
    double s2 = sl + sr;
    double err = (s2 - v0) / 15;

    if (depth > maxDepth) {
      state['maxDepthCount'] = (state['maxDepthCount'] as int) + 1;
      return s2 + err;
    } else if (err.abs() < tol) {
      return s2 + err;
    } else {
      double m = a + h * 0.5;
      double v1 =
          adsimp(f, a, m, fa, f1, fm, sl, tol * 0.5, maxDepth, depth + 1);
      double v2 =
          adsimp(f, m, b, fm, f2, fb, sr, tol * 0.5, maxDepth, depth + 1);
      return v1 + v2;
    }
  }

  double integrate(Function f, double a, double b, double tol, int maxdepth) {
    double fa = f(a);
    double fm = f(0.5 * (a + b));
    double fb = f(b);
    double v0 = (fa + 4 * fm + fb) * (b - a) / 6;

    return adsimp(f, a, b, fa, fm, fb, v0, tol, maxdepth, 1);
  }

  try {
    return double.parse(
        (integrate(f, a, b, tol, maxDepth)).toStringAsFixed(12));
  } catch (e) {
    // Fallback to non-adaptive (the function isn't provided in the original code, so it's commented out)
    // return simpson(f, a, b);
    return double.nan; // Return NaN for now as a placeholder
  }
}

/// Computes the gamma function of [z].
///
/// The gamma function is an extension of the factorial function to complex numbers,
/// with a pole at every non-positive integer.
///
/// For a given input [z], the function computes:
///
/// \[
/// \Gamma(z) = \int_0^\infty t^{z-1} e^{-t} dt
/// \]
///
/// Parameters:
///  - [z]: A double value for which the gamma function is computed.
///
/// Returns:
///  - A double value representing the gamma function of [z].
///
/// Example:
/// ```dart
/// var result = gamma(0.5);
/// print(result);  // Expected output: ~1.77245385091 (which is the square root of Pi)
/// ```
double gamma(num z) {
  const int g = 7;
  const List<double> C = [
    0.99999999999980993,
    676.5203681218851,
    -1259.1392167224028,
    771.32342877765313,
    -176.61502916214059,
    12.507343278686905,
    -0.13857109526572012,
    9.9843695780195716e-6,
    1.5056327351493116e-7
  ];

  if (z < 0.5) {
    return pi / (sin(pi * z) * gamma(1 - z));
  } else {
    z -= 1;

    var x = C[0];
    for (var i = 1; i < g + 2; i++) {
      x += C[i] / (z + i);
    }

    var t = z + g + 0.5;
    return sqrt(2 * pi) * pow(t, (z + 0.5)) * exp(-t) * x;
  }
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

/// Computes the factorial of a given number [x].
///
/// This function handles:
/// - Small integers using the standard factorial computation.
/// - Large integers by switching to `BigInt` to avoid overflow.
/// - Non-integers using the gamma function.
/// - Negative integers by returning NaN, as factorial is undefined for them.
///
/// Parameters:
///  - [x]: A value (either `int` or `double`) for which the factorial is computed.
///
/// Returns:
///  - For integers:
///     - If `x` is a small positive integer, it returns an `int` representing the factorial of [x].
///     - If `x` is a large positive integer, it returns a `BigInt` representing the factorial of [x].
///     - If `x` is a negative integer, it returns `double.nan`.
///  - For non-integers (doubles), it returns a `double` representing the factorial of [x].
///
/// Throws:
///  - ArgumentError if [x] is neither an `int` nor a `double`.
///
/// Example:
/// ```dart
/// print(factorial2(5));       // Output: 120
/// print(factorial2(50));      // Output: 30414093201713378043612608166064768844377641568960512000000000000
/// print(factorial2(0.5));     // Will be computed using the gamma function
/// print(factorial2(-5));      // Output: NaN
/// ```
dynamic factorial2(dynamic x) {
  if (x is! int && x is! double) {
    throw ArgumentError('Input should be either int or double.');
  }

  bool isInt = x % 1 == 0;

  // Factorial for negative integers is undefined
  if (isInt && x < 0) {
    return double.nan;
  }

  // For small integers, use the regular factorial method
  if (isInt && x <= 20) {
    int retVal = 1;
    for (int i = 2; i <= x; i++) {
      retVal *= i;
    }
    return retVal;
  }
  // Use gamma function for non-integers
  if (!isInt || (x > 20 && x < 141.2)) {
    return gamma(x + 1);
  }

  // For large integers, switch to BigInt
  // 20! is the last factorial that fits in a 64-bit integer
  BigInt retVal = BigInt.one;
  for (int i = 2; i <= x; i++) {
    retVal *= BigInt.from(i);
  }
  return retVal;
}

/// Computes the double factorial of a given number [x].
///
/// For more details: http://mathworld.wolfram.com/DoubleFactorial.html
///
/// Parameters:
///  - [x]: A double value for which the double factorial is computed.
///
/// Returns:
///  - A double value representing the double factorial of [x].
///
/// Example:
/// ```dart
/// print(doubleFactorial(5));   // Output: 15.0
/// ```
double doubleFactorial(double x) {
  bool isInt = x % 1 == 0;

  if (isInt) {
    bool even = x % 2 == 0;
    int n = even ? x ~/ 2 : (x + 1) ~/ 2;
    double r = 1;

    if (even) {
      for (int i = 1; i <= n; i++) {
        r *= 2 * i;
      }
    } else {
      for (int i = 1; i <= n; i++) {
        r *= 2 * i - 1;
      }
    }
    return r;
  } else {
    return pow(2, (1 + 2 * x - cos(pi * x)) / 4) *
        pow(pi, (cos(pi * x) - 1) / 4) *
        gamma(1 + x / 2);
  }
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

/// Returns the nth Fibonacci number considering the sign of [n].
///
/// If [n] is negative and even, the result will also be negative.
/// If [n] is negative and odd, the result will be positive.
///
/// Returns an `int` if the result fits in 64 bits, otherwise a `BigInt`.
///
/// Example:
/// ```dart
/// print(fib(7));  // Output: 13
/// print(fib(-7)); // Output: 13
/// print(fib(-8)); // Output: -21
/// print(fib(50)); // Output: 12586269025
/// ```
dynamic fib(int n) {
  if (n == 0) return 0; // Special case for n = 0
  if (n == 1 || n == -1) return 1; // Special cases for n = ±1

  // Determine the sign based on evenness of n
  int sign = (n.isNegative && n.isEven) ? -1 : 1;
  n = n.abs();

  // Use BigInt for calculation
  BigInt a = BigInt.zero, b = BigInt.one, f = BigInt.one;
  for (int i = 2; i <= n; i++) {
    f = a + b;
    a = b;
    b = f;
  }

  // Adjust sign
  f *= BigInt.from(sign);

  // Return as int if it fits, otherwise as BigInt
  if (f.bitLength <= 63) {
    return f.toInt();
  } else {
    return f;
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
/// print(isPerfectNumber(137438691328));  // Output: true
/// print(isPerfectNumber(137438691329));  // Output: false
/// print(isPerfectNumber('2305843008139952128'));  // Output: true
/// ```

bool isPerfectNumber(dynamic n) {
  BigInt parseInput(dynamic n) {
    if (n is BigInt) return n;
    if (n is int) return BigInt.from(n);
    return BigInt.parse(n.toString());
  }

  ({BigInt powerOfTwo, BigInt remaining}) factorOutPowersOfTwo(BigInt n) {
    BigInt power = BigInt.zero;
    while (n.isEven) {
      n = n ~/ BigInt.two;
      power += BigInt.one;
    }
    return (powerOfTwo: power, remaining: n);
  }

  bool checkEvenPerfectStructure(BigInt n) {
    try {
      final factorization = factorOutPowersOfTwo(n);
      final possibleP = factorization.remaining + BigInt.one;

      if (!possibleP.isPowerOfTwo) return false;

      final p = possibleP.bitLength - 1;
      final expectedPower = p - 1;

      // Verify the structure: 2^(p-1) * (2^p - 1)
      return factorization.powerOfTwo == BigInt.from(expectedPower) &&
          isMersennePrime(p);
    } catch (_) {
      return false;
    }
  }

  bool checkOddPerfectCandidate(BigInt n) {
    // Known constraints for hypothetical odd perfect numbers:
    // 1. Must be > 10^1500
    // 2. Must have at least 101 prime factors
    // 3. Must be of form N = q^k m^2 where q ≡ k ≡ 1 (mod 4)
    if (n.toString().length < 1501) return false;

    // Optimized divisor sum with early exit
    BigInt sum = BigInt.one;
    final sqrtN = n.sqrt();
    var i = BigInt.two;

    while (i <= sqrtN && sum <= n) {
      if (n % i == BigInt.zero) {
        final pair = n ~/ i;
        sum += i == pair ? i : i + pair;
      }
      i += i.isEven
          ? BigInt.one
          : BigInt.two; // Skip even divisors for odd numbers
    }

    return sum == n;
  }

  final number = parseInput(n);
  if (number <= BigInt.one) return false;

  // First check for even perfect number structure
  if (number.isEven && checkEvenPerfectStructure(number)) {
    return true;
  }

  // Then check for odd number properties (unknown but possible)
  return checkOddPerfectCandidate(number);
}

/// Enhanced Lucas-Lehmer test with timing
/// Checks if the given exponent `p` represents a Mersenne prime number.
///
/// The Mersenne prime number is calculated as `2^p - 1`, and the Lucas-Lehmer
/// test is used to determine if the number is prime. The function also measures
/// the time taken to perform the prime check and stores it in the `_timingStats`
/// map.
///
/// Args:
///   p (int): The exponent to check for a Mersenne prime.
///
/// Returns:
///   bool: `true` if the number `2^p - 1` is a Mersenne prime, `false` otherwise.
bool isMersennePrime(int p) {
  // Lucas-Lehmer primality test for Mersenne primes
  if (p < 2) return false;
  if (p == 2) return true;

  final mp = (BigInt.one << p) - BigInt.one;
  BigInt s = BigInt.from(4);

  for (int i = 0; i < p - 2; i++) {
    s = (s * s - BigInt.two) % mp;
  }

  return s == BigInt.zero;
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


/// Computes the Collatz sequence for a given positive integer.
///
/// The Collatz Conjecture states that for any positive integer, if you repeatedly apply
/// the following rules, you'll eventually reach 1:
/// - If the number is even, divide it by 2
/// - If the number is odd, multiply it by 3 and add 1
///
/// Parameters:
///  - [n]: A positive integer to start the sequence.
///  - [returnSequence]: If true, returns the entire sequence. If false, returns only the number of steps. Default is false.
///
/// Returns:
///  - If [returnSequence] is true, returns a list containing the entire Collatz sequence.
///  - If [returnSequence] is false, returns the number of steps it takes to reach 1.
///
/// Throws:
///  - ArgumentError if [n] is not a positive integer.
///
/// Example:
/// ```dart
/// print(collatz(6));  // Output: 8 (steps to reach 1)
/// print(collatz(6, true));  // Output: [6, 3, 10, 5, 16, 8, 4, 2, 1]
/// ```
dynamic collatz(int n, [bool returnSequence = true]) {
  if (n <= 0) {
    throw ArgumentError('Input must be a positive integer');
  }
  
  List<int> sequence = [n];
  int steps = 0;
  
  while (n != 1) {
    if (n.isEven) {
      n ~/= 2;
    } else {
      n = 3 * n + 1;
    }
    
    sequence.add(n);
    steps++;
  }
  
  return returnSequence ? sequence : steps;
}

/// Computes the maximum value reached in the Collatz sequence for a given positive integer.
///
/// Parameters:
///  - [n]: A positive integer to start the sequence.
///
/// Returns:
///  - The maximum value reached in the Collatz sequence starting from [n].
///
/// Throws:
///  - ArgumentError if [n] is not a positive integer.
///
/// Example:
/// ```dart
/// print(collatzPeak(6));  // Output: 16
/// print(collatzPeak(27)); // Output: 9232
/// ```
int collatzPeak(int n) {
  if (n <= 0) {
    throw ArgumentError('Input must be a positive integer');
  }
  
  int maxValue = n;
  
  while (n != 1) {
    if (n.isEven) {
      n ~/= 2;
    } else {
      n = 3 * n + 1;
    }
    
    if (n > maxValue) {
      maxValue = n;
    }
  }
  
  return maxValue;
}

/// Finds the number with the longest Collatz sequence in a given range.
///
/// Parameters:
///  - [start]: The start of the range (inclusive).
///  - [end]: The end of the range (inclusive).
///
/// Returns:
///  - A map containing the number with the longest sequence and its length.
///
/// Throws:
///  - ArgumentError if [start] or [end] is not a positive integer, or if [start] > [end].
///
/// Example:
/// ```dart
/// var result = longestCollatzInRange(1, 10);
/// print(result); // Output: {number: 9, length: 20}
/// ```
Map<String, int> longestCollatzInRange(int start, int end) {
  if (start <= 0 || end <= 0) {
    throw ArgumentError('Inputs must be positive integers');
  }
  if (start > end) {
    throw ArgumentError('Start must be less than or equal to end');
  }
  
  int maxLength = 0;
  int maxNumber = start;
  
  for (int i = start; i <= end; i++) {
    int length = collatz(i, false) as int;
    if (length > maxLength) {
      maxLength = length;
      maxNumber = i;
    }
  }
  
  return {'number': maxNumber, 'length': maxLength};
}

/// Checks if a number is a Kaprekar number.
///
/// A Kaprekar number is a number whose square can be split into two parts 
/// that add up to the original number.
///
/// Parameters:
///  - [n]: The number to check.
///
/// Returns:
///  - `true` if [n] is a Kaprekar number, `false` otherwise.
///
/// Example:
/// ```dart
/// print(isKaprekarNumber(9));   // Output: true (9² = 81, 8+1 = 9)
/// print(isKaprekarNumber(45));  // Output: true (45² = 2025, 20+25 = 45)
/// print(isKaprekarNumber(10));  // Output: false
/// ```
bool isKaprekarNumber(int n) {
  if (n < 1) return false;
  
  BigInt square = BigInt.from(n) * BigInt.from(n);
  String squareStr = square.toString();
  int squareDigits = squareStr.length;
  
  // Special case for 1
  if (n == 1) return true;
  
  // Try all possible splits of the square
  for (int i = 1; i < squareDigits; i++) {
    String leftPart = squareStr.substring(0, i);
    String rightPart = squareStr.substring(i);
    
    // Skip if right part is just zeros
    if (rightPart == '0' * rightPart.length) continue;
    
    int leftNum = int.parse(leftPart);
    int rightNum = int.parse(rightPart);
    
    if (leftNum + rightNum == n) {
      return true;
    }
  }
  
  return false;
}

/// Checks if a number is a narcissistic number (also known as an Armstrong number).
///
/// A narcissistic number is a number that is the sum of its own digits each raised to the 
/// power of the number of digits.
///
/// Parameters:
///  - [n]: The number to check.
///
/// Returns:
///  - `true` if [n] is a narcissistic number, `false` otherwise.
///
/// Example:
/// ```dart
/// print(isNarcissisticNumber(153)); // Output: true (1³ + 5³ + 3³ = 153)
/// print(isNarcissisticNumber(370)); // Output: true (3³ + 7³ + 0³ = 370)
/// print(isNarcissisticNumber(100)); // Output: false
/// ```
bool isNarcissisticNumber(int n) {
  if (n < 0) return false;
  
  List<int> digits = getDigits(n);
  int power = digits.length;
  num sum = 0;
  
  for (int digit in digits) {
    sum += pow(digit, power).toInt();
  }
  
  return sum == n;
}

/// Checks if a number is a happy number.
///
/// A happy number is a number which eventually reaches 1 when replaced by the sum
/// of the square of each digit.
///
/// Parameters:
///  - [n]: The number to check.
///
/// Returns:
///  - `true` if [n] is a happy number, `false` otherwise.
///
/// Example:
/// ```dart
/// print(isHappyNumber(19)); // Output: true (1² + 9² = 82, 8² + 2² = 68, 6² + 8² = 100, 1² + 0² + 0² = 1)
/// print(isHappyNumber(4));  // Output: false
/// ```
bool isHappyNumber(int n) {
  Set<int> seen = {};
  
  while (n != 1 && !seen.contains(n)) {
    seen.add(n);
    n = getDigits(n).fold(0, (sum, digit) => sum + digit * digit);
  }
  
  return n == 1;
}