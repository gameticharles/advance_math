part of maths;

/// Returns the sine of a number in radians.
///
/// Example:
/// ```dart
/// print(sin(math.pi / 2));  // Output: 1.0
/// ```
double sin(num x) => math.sin(x);

/// Returns the cosine of a number in radians.
///
/// Example:
/// ```dart
/// print(cos(math.pi));  // Output: -1.0
/// ```
double cos(num x) => math.cos(x);

/// Returns the tangent of a number in radians.
///
/// Example:
/// ```dart
/// print(tan(math.pi / 4));  // Output: 1.0
/// ```
double tan(num x) => math.tan(x);

/// Returns the secant of a number in radians.
///
/// Example:
/// ```dart
/// print(sec(1)); // Output: 1.8508157176809255
/// ```
double sec(num x) {
  return 1 / cos(x);
}

/// Returns the cosecant of a number in radians.
///
/// Example:
/// ```dart
/// print(csc(1)); // Output: 1.1883951057781212
/// ```
double csc(num x) {
  return 1 / sin(x);
}

/// Returns the cotangent of a number in radians.
///
/// Example:
/// ```dart
/// print(cot(1)); // Output: 0.6420926159343308
/// ```
double cot(num x) {
  return 1 / tan(x);
}

/// Returns the arcsine of a number in radians.
///
/// Example:
/// ```dart
/// print(asin(1));  // Output: 1.5707963267948966
/// ```
double asin(num x) => math.asin(x);

/// Returns the arccosine of a number in radians.
///
/// Example:
/// ```dart
/// print(acos(1));  // Output: 0.0
/// ```
double acos(num x) => math.acos(x);

/// Returns the arctangent of a number.
///
/// Example:
/// ```dart
/// print(atan(1));  // Output: 0.7853981633974483
/// ```
double atan(num x) => math.atan(x);

/// Returns the angle in radians between the positive x-axis and the vector.
///
/// The result is in the range -PI and PI.
///
/// If `b` is positive, this is the same as atan(a/b).
/// The result is negative when `a` is negative (including when `a` is the double -0.0).
///
/// If `a` is equal to zero, the vector (`b`,`a`) is considered parallel to the x-axis,
/// even if `b` is also equal to zero. The sign of `b` determines the direction
/// of the vector along the x-axis.
///
/// Returns NaN if either argument is NaN.
///
/// Example:
/// ```dart
/// print(atan2(3, 4));  // Output: 0.6435011087932843868028
/// // atan(3 / 4) = 0.6435011087932843868028
/// ```
double atan2(num a, num b) => math.atan2(a, b);

/// Returns the arcsecant (inverse of the secant) of `x`.
///
/// Example:
/// ```dart
/// print(asec(2)); // prints: 1.0471975511965979
/// ```
double asec(num x) {
  if (x.abs() < 1) {
    throw ArgumentError(
        'Invalid input for asec: absolute value of input must be >= 1');
  }
  return math.acos(1 / x);
}

/// Returns the arccosecant (inverse of the cosecant) of `x`.
///
/// Example:
/// ```dart
/// print(acsc(2)); // prints: 0.5235987755982989
/// ```
double acsc(num x) {
  if (x.abs() < 1) {
    throw ArgumentError(
        'Invalid input for acsc: absolute value of input must be >= 1');
  }
  return math.asin(1 / x);
}

/// Returns the arccotangent (inverse of the cotangent) of `x`.
///
/// Example:
/// ```dart
/// print(acot(1)); // prints: 0.7853981633974483
/// ```
double acot(num x) {
  return pi / 2 - math.atan(x);
}

/// Returns the hyperbolic sine of a number.
///
/// Example:
/// ```dart
/// print(sinh(1));  // Output: 1.1752011936438014
/// ```
double sinh(num x) => (exp(x) - exp(-x)) / 2;

/// Returns the hyperbolic cosine of a number.
///
/// Example:
/// ```dart
/// print(cosh(1));  // Output: 1.5430806348152437
/// ```
double cosh(num x) => (exp(x) + exp(-x)) / 2;

/// Returns the hyperbolic tangent of a number.
///
/// Example:
/// ```dart
/// print(tanh(1));  // Output: 0.7615941559557649
/// ```
double tanh(num x) => sinh(x) / cosh(x);

/// Returns the hyperbolic secant of a number.
///
/// Example:
/// ```dart
/// print(sech(1)); // Output: 0.6480542736638853
/// ```
double sech(num x) {
  return 1 / cosh(x);
}

/// Returns the hyperbolic cosecant of a number.
///
/// Example:
/// ```dart
/// print(csch(1)); // Output: 0.8509181282393215
/// ```
double csch(num x) {
  return 1 / sinh(x);
}

/// Returns the hyperbolic cotangent of a number.
///
/// Example:
/// ```dart
/// print(coth(1)); // Output: 1.3130352854993312
/// ```
double coth(num x) {
  return 1 / tanh(x);
}

/// Returns the inverse hyperbolic sine (asinh) of the number.
///
/// Example:
/// ```dart
/// print(asinh(1));  // Output: 0.881373587019543
/// ```
double asinh(num x) => log(x + sqrt(x * x + 1));

/// Returns the inverse hyperbolic cosine (acosh) of the number.
///
/// Throws an [ArgumentError] if the input is less than 1.
///
/// Example:
/// ```dart
/// print(acosh(1));  // Output: 0.0
/// ```
double acosh(num x) {
  if (x < 1) {
    throw ArgumentError('Invalid input for acosh: input must be >= 1');
  }
  return log(x + sqrt(x * x - 1));
}

/// Returns the inverse hyperbolic tangent (atanh) of the number.
///
/// Throws an [ArgumentError] if the input is less than or equal to -1 or greater than or equal to 1.
///
/// Example:
/// ```dart
/// print(atanh(0.5));  // Output: 0.5493061443340549
/// ```
double atanh(num x) {
  if (x <= -1 || x >= 1) {
    throw ArgumentError('Invalid input for atanh: input must be in (-1, 1)');
  }
  return 0.5 * log((1 + x) / (1 - x));
}

/// Returns the inverse hyperbolic secant (asech) of `x`.
///
/// Example:
/// ```dart
/// print(asech(0.5)); // prints: 1.3169578969248166
/// ```
double asech(num x) {
  if (x <= 0 || x > 1) {
    throw ArgumentError('Invalid input for asech: input must be in (0, 1]');
  }
  return math.log((1 + math.sqrt(1 - x * x)) / x);
}

/// Returns the inverse hyperbolic cosecant (acsch) of `x`.
///
/// Example:
/// ```dart
/// print(acsch(1)); // prints: 0.881373587019543
/// ```
double acsch(num x) {
  return math.log(1 / x + math.sqrt(1 / (x * x) + 1));
}

/// Returns the inverse hyperbolic cotangent (acoth) of `x`.
///
/// Example:
/// ```dart
/// print(acoth(2)); // prints: 0.5493061443340549
/// ```
double acoth(num x) {
  if (x.abs() <= 1) {
    throw ArgumentError(
        'Invalid input for acoth: absolute value of input must be > 1');
  }
  return 0.5 * log((x + 1) / (x - 1));
}

/// Versine function
///
/// The versine or versine or versed sine of an angle is 1 − cos(θ).
/// It's rarely used in modern mathematics but can be found in various historical contexts.
///
/// Example:
/// ```dart
/// print(vers(math.pi / 2));  // Output: 1.0
/// print(vers(math.pi / 4));  // Output: 0.2928932188134524
/// print(vers(math.pi / 6));  // Output: 0.1339745962155613
/// ```
///
/// The output is `1.0` because the versine of π/2 (or 90 degrees) is 1.
double vers(num x) {
  return 1 - math.cos(x);
}

/// Coversine function
///
/// The coversine or coversin of an angle is 1 − sin(θ).
/// It's also rarely used in modern mathematics but can be found in various historical contexts.
///
/// Example:
/// ```dart
/// print(covers(math.pi / 2));  // Output: 0.0
/// print(covers(math.pi / 4));  // Output: 0.29289321881345254
/// print(covers(math.pi / 6));  // Output: 0.5
/// ```
///
/// The output is `0.0` because the coversine of π/2 (or 90 degrees) is 0.
double covers(num x) {
  return 1 - math.sin(x);
}

/// Haversine function
///
/// The haversine or haversin of an angle is (1 - cos(θ)) / 2.
/// It's used in navigation providing a formula for the great-circle distance between two points on the surface of a sphere.
///
/// Example:
/// ```dart
/// print(havers(math.pi / 2));  // Output: 0.5
/// print(havers(math.pi / 4));  // Output: 0.14644660940672624
/// print(havers(math.pi / 6));  // Output: 0.06698729810778065
/// ```
///
/// The output is `0.0` because the haversine of π/2 (or 90 degrees) is 0.
double havers(num x) {
  return 0.5 * (1 - cos(x));
}

/// Exsecant function
///
/// The exsecant or exsec of an angle is sec(θ) - 1.
/// It's rarely used in modern mathematics.
///
/// Example:
/// ```dart
/// print(exsec(math.pi / 2));  // Output: Infinity
/// ```
///
/// The output is `Infinity` because the exsecant of π/2 (or 90 degrees) is infinity (as sec(π/2) is infinity).
double exsec(num x) {
  return 1 / cos(x) - 1;
}

/// Excosecant function
///
/// The excosecant or excsc of an angle is csc(θ) - 1.
/// It's rarely used in modern mathematics.
///
/// Example:
/// ```dart
/// print(excsc(math.pi / 2));  // Output: 0.0
/// ```
///
/// The output is `0.0` because the excosecant of π/2 (or 90 degrees) is 0 (as csc(π/2) is 1).
double excsc(num x) {
  return 1 / sin(x) - 1;
}

/// Sawtooth wave function
///
/// The sawtooth wave function generates a waveform which ramps upward and then sharply drops.
/// It is named based on its resemblance to the teeth on the edge of a saw blade.
///
/// Example:
/// ```dart
/// print(sawtooth(2.7));  // Output: 0.7
/// ```
///
/// The output is `0.7` because the fractional part of `2.7` is `0.7`.
double sawtooth(num x) {
  return (x - x.floor()).toDouble();
}

/// Square wave function
///
/// The square wave function generates a periodic waveform which alternates between two levels.
///
/// Example:
/// ```dart
/// print(squareWave(2.7));  // Output: -1.0
/// print(squareWave(3.2));  // Output: 1.0
/// ```
///
/// The output for `2.7` is `1.0` and for `3.2` is `-1.0` because the square wave function oscillates between `1.0` and `-1.0`.
int squareWave(double x) {
  return (x % 2 < 1) ? -1 : 1;
}

/// Triangle wave function
///
/// The triangle wave function generates a periodic waveform that oscillates in a triangle shape.
///
/// Example:
/// ```dart
/// print(triangleWave(2.7));  // Output: -0.8
/// print(triangleWave(3.2));  // Output: 0.8
/// ```
///
/// The output for `2.7` is `-0.8` and for `0.8` is `-0.6` because the triangle wave function oscillates in a triangle shape.
double triangleWave(double x) {
  x %= 1;
  if (x < 0.25) {
    return 4 * x;
  } else if (x < 0.75) {
    return -4 * x + 2;
  } else {
    return 4 * x - 4;
  }
}
