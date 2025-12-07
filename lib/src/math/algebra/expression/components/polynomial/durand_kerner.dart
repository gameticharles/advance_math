part of '../../expression.dart';

/// The Durand–Kerner method, also known as Weierstrass method, is a root
/// finding algorithm for solving polynomial equations. With this class, you
/// can find all roots of a polynomial of any degree.
///
/// This is the preferred approach:
///
///  - when the polynomial degree is 5 or higher, use [DurandKerner];
///  - when the polynomial degree is 4, use [Quartic];
///  - when the polynomial degree is 3, use [Cubic];
///  - when the polynomial degree is 2, use [Quadratic];
///  - when the polynomial degree is 1, use [Linear].
///
/// The algorithm requires an initial set of values to find the roots. This
/// implementation generates some random values if the user doesn't provide
/// initial points to the algorithm.
///
/// Note that this algorithm does **NOT** always converge. To be more clear, it
/// is **NOT** true that for every polynomial, the set of initial vectors that
/// eventually converges to roots is open and dense.
final class DurandKerner extends Polynomial {
  /// The initial guess from which the algorithm has to start finding the roots.
  ///
  /// By default, this is an empty list because this class can provide some
  /// pre-built values that are good in **most of** the cases (but not always).
  ///
  /// You can provide specific initial guesses with this param.
  ///
  /// The length of the [initialGuess] must equals the coefficients length minus
  /// one. For example, this is ok...
  ///
  /// ```dart
  /// final durandKerner = DurandKerner(
  ///   coefficients: [
  ///     Complex.fromReal(-5),
  ///     Complex.fromReal(3),
  ///     Complex.i(),
  ///   ],
  ///   initialGuess: [
  ///     Complex(1, -2),
  ///     Complex.fromReal(3),
  ///   ],
  /// );
  /// ```
  ///
  /// ... but this is **not** ok:
  ///
  ///```dart
  /// final durandKerner = DurandKerner(
  ///   coefficients: [
  ///     Complex.fromReal(-5),
  ///     Complex.fromReal(3),
  ///     Complex.i(),
  ///   ],
  ///   initialGuess: [
  ///     Complex(1, -2),
  ///     // missing a value here!
  ///   ],
  /// );
  /// ```
  final List<dynamic> initialGuess;

  /// The accuracy of the algorithm.
  final double precision;

  /// The maximum steps to be made by the algorithm.
  final int maxSteps;

  /// Creates a new object that finds all the roots of a polynomial equation
  /// using the Durand-Kerner algorithm. The polynomial can have both complex
  /// ([Complex]) and real ([double]) values.
  ///
  ///   - [coefficients]: the coefficients of the polynomial;
  ///   - [initialGuess]: the initial guess from which the algorithm has to
  ///   start finding the roots;
  ///   - [precision]: the accuracy of the algorithm;
  ///   - [maxSteps]: the maximum steps to be made by the algorithm.
  ///
  /// Note that the coefficient with the highest degree goes first. For example,
  /// the coefficients of the `-5x^2 + 3x + i = 0` have to be inserted in the
  /// following way:
  ///
  /// ```dart
  /// final durandKerner = DurandKerner(
  ///   coefficients: [
  ///     Complex.fromReal(-5),
  ///     Complex.fromReal(3),
  ///     Complex.i(),
  ///   ],
  /// );
  /// ```
  ///
  /// Since `-5` is the coefficient with the highest degree (2), it goes first.
  /// If the coefficients of your polynomial are only real numbers, consider
  /// using the `[DurandKerner.realEquation]` constructor instead.
  DurandKerner(
    super.coefficients, {
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    super.variable,
  });

  /// Creates a new object that finds all the roots of a polynomial equation
  /// using the Durand-Kerner algorithm. The polynomial can only have real
  /// ([double]) values.
  ///
  ///   - [coefficients]: the coefficients of the polynomial;
  ///   - [initialGuess]: the initial guess from which the algorithm has to
  ///   start finding the roots;
  ///   - [precision]: the accuracy of the algorithm;
  ///   - [maxSteps]: the maximum steps to be made by the algorithm.
  ///
  /// Note that the coefficient with the highest degree goes first. For example,
  /// the coefficients of the `-5x^2 + 3x + 1 = 0` has to be inserted in the
  /// following way:
  ///
  /// ```dart
  /// final durandKerner = DurandKerner.num(
  ///   coefficients [-5, 3, 1],
  /// );
  /// ```
  ///
  /// Since `-5` is the coefficient with the highest degree (2), it goes first.
  /// If the coefficients of your polynomial contain complex numbers, consider
  /// using the [DurandKerner.new] constructor instead.
  DurandKerner.num(
    List<dynamic> coefficients, {
    this.initialGuess = const [],
    this.precision = 1.0e-10,
    this.maxSteps = 2000,
    Variable? variable,
  }) : super(coefficients.map((e) => Literal(Complex(e))).toList(),
            variable: variable);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is DurandKerner) {
      // The lengths of the data lists must match
      if (initialGuess.length != other.initialGuess.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the data
      // list.
      var equalsCount = 0;

      for (var i = 0; i < initialGuess.length; ++i) {
        if (initialGuess[i] == other.initialGuess[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return super == other &&
          equalsCount == initialGuess.length &&
          precision == other.precision &&
          maxSteps == other.maxSteps;
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    var result = super.hashCode;

    // Like we did in operator== iterating over all elements ensures that the
    // hashCode is properly calculated.
    for (var i = 0; i < initialGuess.length; ++i) {
      result = result * 37 + initialGuess[i].hashCode;
    }

    result = result * 37 + precision.hashCode;
    result = result * 37 + maxSteps.hashCode;

    return result;
  }

  @override
  dynamic discriminant() {
    // // Say that P(x) is the polynomial represented by this instance and
    // // P'(x) is the derivative of P. In order to calculate the discriminant of
    // // a polynomial, we need to first compute the resultant Res(A, A') which
    // // is equivalent to the determinant of the Sylvester matrix.
    // final sylvester = SylvesterMatrix(
    //   polynomial: this,
    // );

    // // Computes Res(A, A') and then determines the sign according with the
    // // degree of the polynomial.
    // return sylvester.polynomialDiscriminant();
    return 0; // Remove and uncomment the above
  }

  @override
  List<dynamic> roots() {
    // In case the polynomial was a constant, just return an empty array because
    // there are no solutions.
    if (coefficients.length <= 1) {
      return [];
    }

    // Proceeding with the setup since the polynomial degree is >= 1.
    final coefficientsLength = coefficients.length;
    final reversedCoeffs = coefficients.reversed.toList(growable: false);

    // Buffers for numerators and denominators or real and complex parts.
    // Buffers for numerators and denominators or real and complex parts.
    final realBuffer = reversedCoeffs.map((e) {
      if (e is Literal && e.value is Complex) {
        return (e.value as Complex).real;
      } else if (e is Literal && e.value is num) {
        return (e.value as num).toDouble();
      }
      throw Exception('DurandKerner requires numeric coefficients. Found: $e');
    }).toList(growable: false);

    final imaginaryBuffer = reversedCoeffs.map((e) {
      if (e is Literal && e.value is Complex) {
        return (e.value as Complex).imaginary;
      } else if (e is Literal && e.value is num) {
        return 0.0;
      }
      throw Exception('DurandKerner requires numeric coefficients. Found: $e');
    }).toList(growable: false);

    // Scaling the various coefficients.
    var upperReal = realBuffer[coefficientsLength - 1];
    var upperComplex = imaginaryBuffer[coefficientsLength - 1];
    final squareSum = upperReal * upperReal + upperComplex * upperComplex;

    upperReal /= squareSum;
    upperComplex /= -squareSum;

    num k1 = 0.0;
    num k2 = 0.0;
    num k3 = 0.0;
    final s = upperComplex - upperReal;
    final t = upperReal + upperComplex;

    for (var i = 0; i < coefficientsLength - 1; ++i) {
      k1 = upperReal * (realBuffer[i] + imaginaryBuffer[i]);
      k2 = realBuffer[i] * s;
      k3 = imaginaryBuffer[i] * t;
      realBuffer[i] = k1 - k3;
      imaginaryBuffer[i] = k1 + k2;
    }

    realBuffer[coefficientsLength - 1] = 1.0;
    imaginaryBuffer[coefficientsLength - 1] = 0.0;

    // Using default values to compute the solutions. If they aren't provided,
    // we will generate default ones.
    if (initialGuess.isNotEmpty) {
      final real = initialGuess.map((e) {
        if (e is Complex) return e.real;
        if (e is num) return e.toDouble();
        return 0.0;
      }).toList(growable: false);

      final complex = initialGuess.map((e) {
        if (e is Complex) return e.imaginary;
        return 0.0;
      }).toList(growable: false);

      return _solve(
        realValues: real,
        imaginaryValues: complex,
        realBuffer: realBuffer,
        imaginaryBuffer: imaginaryBuffer,
      );
    } else {
      // If we're here, it means that no initial guesses were provided and so we
      // need to generate some good ones.
      final real = List<double>.generate(
        coefficientsLength - 1,
        (_) => 0.0,
        growable: false,
      );
      final complex = List<double>.generate(
        coefficientsLength - 1,
        (_) => 0.0,
        growable: false,
      );

      final bound = _bound(
        value: coefficientsLength,
        realBuffer: realBuffer,
        imaginaryBuffer: imaginaryBuffer,
      );
      final factor = bound * 0.65;
      final multiplier = cos(0.25 * 2 * pi);

      for (var i = 0; i < coefficientsLength - 1; ++i) {
        real[i] = factor * multiplier;
        complex[i] = factor * sqrt(1.0 - multiplier * multiplier);
      }

      return _solve(
        realValues: real,
        imaginaryValues: complex,
        realBuffer: realBuffer,
        imaginaryBuffer: imaginaryBuffer,
      );
    }
  }

  DurandKerner copyWith({
    List<Expression>? coefficients,
    List<Complex>? initialGuess,
    double? precision,
    int? maxSteps,
    Variable? variable,
  }) =>
      DurandKerner(
        coefficients ?? List<Expression>.from(this.coefficients),
        initialGuess: initialGuess ?? List<Complex>.from(this.initialGuess),
        precision: precision ?? this.precision,
        maxSteps: maxSteps ?? this.maxSteps,
        variable: variable ?? this.variable,
      );

  /// Determines whether subsequent points are close enough (where "enough" is
  /// defined by [precision].
  bool _near(num a, num b, num c, num d) {
    final qa = a - c;
    final qb = b - d;

    return (qa * qa + qb * qb) < precision;
  }

  /// Returns the maximum magnitude of the complex number, increased by 1.
  double _bound({
    required int value,
    required List<dynamic> realBuffer,
    required List<dynamic> imaginaryBuffer,
  }) {
    num bound = 0.0;

    for (var i = 0; i < value; ++i) {
      final realSquare = realBuffer[i] * realBuffer[i];
      final imagSquare = imaginaryBuffer[i] * imaginaryBuffer[i];

      bound = max(bound, realSquare + imagSquare);
    }

    return 1.0 + sqrt(bound);
  }

  /// The Durand-Kerner algorithm that finds the roots of the polynomial.
  List<dynamic> _solve({
    required List<dynamic> realValues,
    required List<dynamic> imaginaryValues,
    required List<dynamic> realBuffer,
    required List<dynamic> imaginaryBuffer,
  }) {
    final coefficientsLength = coefficients.length;
    final realValuesLen = realValues.length;

    // Variables setup.
    num pa = 0.0;
    num pb = 0.0;
    num qa = 0.0;
    num qb = 0.0;
    num k1 = 0.0;
    num k2 = 0.0;
    num k3 = 0.0;
    num na = 0.0;
    num nb = 0.0;
    num s1 = 0.0;
    num s2 = 0.0;

    // Main iteration loop of the Durand-Kerner algorithm.
    for (var i = 0; i < maxSteps; ++i) {
      num d = 0.0;

      for (var j = 0; j < realValuesLen; ++j) {
        pa = realValues[j];
        pb = imaginaryValues[j];

        // Computing the denominator of type (zj - z0) * ... * (zj - z_{n-1}).
        num a = 1.0;
        num b = 1.0;
        for (var k = 0; k < realValuesLen; ++k) {
          if (k == j) {
            continue;
          }

          qa = pa - realValues[k];
          qb = pb - imaginaryValues[k];

          // Tolerance test.
          if (qa * qa + qb * qb < precision) {
            continue;
          }

          k1 = qa * (a + b);
          k2 = a * (qb - qa);
          k3 = b * (qa + qb);
          a = k1 - k3;
          b = k1 + k2;
        }

        // Computing the numerator.
        na = realBuffer[coefficientsLength - 1];
        nb = imaginaryBuffer[coefficientsLength - 1];
        s1 = pb - pa;
        s2 = pa + pb;

        for (var k = coefficientsLength - 2; k >= 0; --k) {
          k1 = pa * (na + nb);
          k2 = na * s1;
          k3 = nb * s2;
          na = k1 - k3 + realBuffer[k];
          nb = k1 + k2 + imaginaryBuffer[k];
        }

        // Computing the reciprocal.
        k1 = a * a + b * b;
        if (k1.abs() > precision) {
          a /= k1;
          b /= -k1;
        } else {
          a = 1.0;
          b = 0.0;
        }

        // Multiplying and accumulating.
        k1 = na * (a + b);
        k2 = a * (nb - na);
        k3 = b * (na + nb);

        qa = k1 - k3;
        qb = k1 + k2;

        realValues[j] = pa - qa;
        imaginaryValues[j] = pb - qb;

        d = max(d, max(qa.abs(), qb.abs()));
      }

      // Exiting early if convergence is reached.
      if (d < precision) {
        break;
      }
    }

    // Done! Now we need to combine together repeated roots.
    var count = 0.0;

    for (var i = 0; i < realValuesLen; ++i) {
      count = 1;
      var a = realValues[i];
      var b = imaginaryValues[i];
      for (var j = 0; j < realValuesLen; ++j) {
        if (i == j) {
          continue;
        }
        if (_near(
          realValues[i],
          imaginaryValues[i],
          realValues[j],
          imaginaryValues[j],
        )) {
          ++count;
          a += realValues[j];
          b += imaginaryValues[j];
        }
      }
      if (count > 1) {
        a /= count;
        b /= count;
        for (var j = 0; j < realValuesLen; ++j) {
          if (i == j) {
            continue;
          }
          if (_near(
            realValues[i],
            imaginaryValues[i],
            realValues[j],
            imaginaryValues[j],
          )) {
            realValues[j] = a;
            imaginaryValues[j] = b;
          }
        }
        realValues[i] = a;
        imaginaryValues[i] = b;
      }
    }

    // Merging the two real and complex helper arrays into a single list.
    return List<Complex>.generate(
      coefficientsLength - 1,
      (index) => Complex(realValues[index], imaginaryValues[index]),
      growable: false,
    );
  }

  @override
  Expression expand() {
    return this;
  }
}
