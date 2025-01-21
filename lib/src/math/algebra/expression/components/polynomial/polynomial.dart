part of '../../expression.dart';

/// A class representing a Polynomial of arbitrary degree.
class Polynomial extends Expression {
  final List<Number> coefficients;

  Polynomial(this.coefficients);

  late Polynomial polynomial;

  /// Constructs a Polynomial from a list of coefficients.
  ///
  /// The coefficients should be provided in decreasing order of degree,
  /// i.e., from the coefficient of the highest-degree term to the constant term.
  static Polynomial fromList(List<dynamic> coefficientList) {
    {
      List<Number> coefficients = coefficientList
          .map((e) => e is num ? numToNumber(e) : e as Number)
          .toList();
      // side effects if 'coefficients' is altered
      switch (coefficients.length) {
        case 1:
          return Constant(
            a: coefficients.first,
          );
        case 2:
          return Linear(
            a: coefficients.first,
            b: coefficients[1],
          );
        case 3:
          return Quadratic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
          );
        case 4:
          return Cubic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
            d: coefficients[3],
          );
        case 5:
          return Quartic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
            d: coefficients[3],
            e: coefficients[4],
          );
        default:
          return DurandKerner(coefficients);
      }
    }
  }

  /// Creates a [Polynomial] instance from a string representation of a Polynomial.
  ///
  /// The input string should represent a Polynomial with terms in the format `ax^b`, where `a` is
  /// the coefficient and `b` is the exponent. Superscripts are also supported for exponents.
  /// Example: "x² + 2x + 1" can be represented as "x^2 + 2x + 1".
  ///
  /// [source]: A string representation of a Polynomial.
  ///
  /// Returns a [Polynomial] instance representing the input string.
  ///
  /// Throws [FormatException] if the input string is invalid or cannot be parsed into a Polynomial.
  ///
  /// Example 1:
  /// ```dart
  /// var polynomial1 = Polynomial.fromString("x^2 + 2x + 1");
  /// print(polynomial1); // Expected output: x² + 2x + 1
  /// ```
  ///
  /// Example 2:
  /// ```dart
  /// var polynomial2 = Polynomial.fromString("- 20x⁴ + 163x³ - 676x² + 1424x - 1209");
  /// print(polynomial2); // Expected output: - 20x⁴ + 163x³ - 676x² + 1424x - 1209
  /// ```
  ///
  /// Example 3:
  /// ```dart
  /// var polynomial3 = Polynomial.fromString("-1 + 2x + x^4");
  /// print(polynomial3); // Expected output: x⁴ + 2x - 1
  /// ```
  factory Polynomial.fromString(String source) {
    try {
      // Convert superscripts to normal digits
      final superscripts = {
        '¹': '1',
        '²': '2',
        '³': '3',
        '⁴': '4',
        '⁵': '5',
        '⁶': '6',
        '⁷': '7',
        '⁸': '8',
        '⁹': '9',
        '⁰': '0',
      };

      source = source.replaceAllMapped(
        RegExp(
            r'x([\u2070-\u2079\u00B9\u00B2\u00B3]+)|([\u2070-\u2079\u00B9\u00B2\u00B3]+)'),
        (match) {
          if (match.group(1) != null) {
            // This is the case when 'x' is followed by superscripts
            return 'x^${match.group(1)!.split('').map((digit) => superscripts[digit]!).join()}';
          } else {
            // This is the case when only superscripts are matched
            return match
                .group(2)!
                .split('')
                .map((digit) => superscripts[digit]!)
                .join();
          }
        },
      );

      final RegExp expPattern =
          RegExp(r"([+-]?\s*\d*x(\^\d+)?)|([+-]?\s*\d+)|(\s*x(\^\d+)?)");
      var matches = expPattern.allMatches(source).toList();

      if (matches.isEmpty) {
        throw FormatException(
            "Input does not contain any valid Polynomial terms");
      }

      var degree = matches
          .map((m) => m.group(2) != null
              ? int.parse(m.group(2)!.substring(1))
              : m.group(1)?.contains('x') ?? false
                  ? 1
                  : m.group(4)?.contains('x') ?? false
                      ? m.group(5) != null
                          ? int.parse(m.group(5)!.substring(1))
                          : 1
                      : 0)
          .reduce(max);

      var coefficients = List<Number>.filled(degree + 1, Integer.zero);

      for (var match in matches) {
        double coefficient;
        int exponent;
        if (match.group(1) != null) {
          // term with 'x'
          var group = match.group(1)!;
          var value = group.split('x')[0].trim();
          value = value.isEmpty ? '1' : value.replaceAll(RegExp(r'[+\s]'), '');
          if ((value.contains('+') || value.contains('-')) &&
              (value.length == 1)) {
            value = value.contains('+') ? '1' : '-1';
          }
          coefficient = group.contains('x')
              ? (value.isEmpty ? 1 : double.parse(value))
              : double.parse(group.replaceAll(RegExp(r'[+\s]'), ''));
          exponent = match.group(2) != null
              ? int.parse(match.group(2)!.substring(1))
              : (group.contains('x') ? 1 : 0);
        } else if (match.group(4) != null) {
          // term with 'x' but no coefficient
          coefficient = 1;
          exponent = match.group(5) != null
              ? int.parse(match.group(5)!.substring(1))
              : 1;
        } else {
          // constant term
          coefficient = double.parse(match.group(3)!.replaceAll(' ', ''));
          exponent = 0;
        }

        coefficients[degree - exponent] = Double(coefficient);
      }

      return Polynomial(coefficients);
    } catch (e) {
      // Handle exceptions and rethrow a formatted exception message
      throw FormatException("Failed to parse Polynomial: $e");
    }
  }

  /// Get the degree of the Polynomial
  ///
  /// Returns an integer representing the degree
  Integer get degree => Integer(coefficients.length - 1);

  // Addition of Polynomials
  @override
  Expression operator +(dynamic other) {
    if (other is Polynomial) {
      int maxDegree = max(coefficients.length, other.coefficients.length);
      List<Number> result =
          List<Number>.generate(maxDegree, (index) => Double(0.0));

      for (var i = 0; i < maxDegree; i++) {
        Number a = i < coefficients.length ? coefficients[i] : Double(0.0);
        Number b =
            i < other.coefficients.length ? other.coefficients[i] : Double(0.0);
        result[i] = a + b;
      }
      return Polynomial(result);
    }
    return Add(this, other);
  }

  // Subtraction of Polynomials
  @override
  Expression operator -(dynamic other) {
    if (other is Polynomial) {
      int maxDegree = max(coefficients.length, other.coefficients.length);
      List<Number> result =
          List<Number>.generate(maxDegree, (index) => Double(0.0));

      for (var i = 0; i < maxDegree; i++) {
        Number a = i < coefficients.length ? coefficients[i] : Double(0.0);
        Number b =
            i < other.coefficients.length ? other.coefficients[i] : Double(0.0);
        result[i] = a - b;
      }
      return Polynomial(result);
    }
    return Subtract(this, other);
  }

  // Multiplication of Polynomials
  @override
  Expression operator *(dynamic other) {
    if (other is Polynomial) {
      int resultDegree = coefficients.length + other.coefficients.length - 2;
      List<Number> result =
          List<Number>.generate(resultDegree + 1, (index) => Double(0.0));

      for (var i = 0; i < coefficients.length; i++) {
        for (var j = 0; j < other.coefficients.length; j++) {
          result[i + j] += coefficients[i] * other.coefficients[j];
        }
      }
      return Polynomial(result);
    }
    return Multiply(this, other);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    if (other is Polynomial) {
      // The lengths of the coefficients must match.
      if (coefficients.length != other.coefficients.length) {
        return false;
      }

      // Each successful comparison increases a counter by 1. If all elements
      // are equal, then the counter will match the actual length of the
      // coefficients list.
      var equalsCount = 0;

      for (var i = 0; i < coefficients.length; ++i) {
        if (coefficients[i] == other.coefficients[i]) {
          ++equalsCount;
        }
      }

      // They must have the same runtime type AND all items must be equal.
      return runtimeType == other.runtimeType &&
          equalsCount == coefficients.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hashAll(coefficients);

  @override
  Expression operator /(dynamic other) {
    if (other is Polynomial) {
      if (other.coefficients.first == Integer.zero) {
        throw Exception('Division by zero polynomial.');
      }

      List<Number> dividendCoeffs = _trimLeadingZeros(coefficients);
      List<Number> divisorCoeffs = _trimLeadingZeros(other.coefficients);

      int dividendDegree = dividendCoeffs.length - 1;
      int divisorDegree = divisorCoeffs.length - 1;

      if (divisorDegree > dividendDegree) {
        return Add(Polynomial([Integer.zero]), RationalFunction(this, other));
      }

      List<Number> quotientCoeffs =
          List.filled(dividendDegree - divisorDegree + 1, Integer.zero);

      for (int k = 0; k <= dividendDegree - divisorDegree; k++) {
        quotientCoeffs[k] = dividendCoeffs[k] / divisorCoeffs[0];
        for (int j = 0; j <= divisorDegree; j++) {
          dividendCoeffs[k + j] -= quotientCoeffs[k] * divisorCoeffs[j];
        }
      }

      // Correcting the range of indices for the remainder coefficients
      List<Number> remainderCoeffs =
          dividendCoeffs.sublist(dividendDegree - divisorDegree + 1);

      return Add(
        Polynomial(_trimLeadingZeros(quotientCoeffs)),
        RationalFunction(Polynomial(_trimLeadingZeros(remainderCoeffs)), other),
      );
    }
    return Divide(this, other);
  }

  /// Helper function to clean up the zeroes
  List<Number> _trimLeadingZeros(List<Number> coeffs) {
    int i = 0;
    while (i < coeffs.length && coeffs[i] == Integer.zero) {
      i++;
    }
    return coeffs.sublist(i);
  }

  /// Returns the coefficient of the Polynomial at the given [index] position.
  /// For example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final a = quadratic[0] // a = Complex(2, 0)
  /// final b = quadratic[1] // b = Complex(-6, 0)
  /// final c = quadratic[2] // c = Complex(5, 0)
  /// ```
  ///
  /// An exception is thrown if the [index] is negative or if it doesn't
  /// correspond to a valid position.
  Number operator [](int index) => coefficients[index];

  /// Returns the coefficient of the Polynomial whose degree is [degree].
  ///
  /// Example:
  ///
  /// ```dart
  /// final quadratic = Quadratic(
  ///   a: Complex.fromReal(2),
  ///   b: Complex.fromReal(-6),
  ///   c: Complex.fromReal(5),
  /// );
  ///
  /// final degreeZero = quadratic.coefficient(0) // Complex(5, 0)
  /// final degreeOne = quadratic.coefficient(1) // Complex(-6, 0)
  /// final degreeTwo = quadratic.coefficient(2) // Complex(2, 0)
  /// ```
  ///
  /// This method returns `null` if no coefficient of the given [degree] is
  /// found.
  Number? coefficient(int degree) {
    // The coefficient of the given degree doesn't exist
    if ((degree < 0) || (degree > coefficients.length - 1)) {
      return null;
    }

    // Return the coefficient of degree 'degree'
    return coefficients[coefficients.length - degree - 1];
  }

  /// Returns the derivative of the quadratic equation.
  ///
  /// Example:
  /// ```dart
  /// var quad = Polynomial([2, -3, -2]);
  /// print(quad.differentiate()); // Output: 4x - 3
  /// ```
  @override
  Polynomial differentiate() {
    if (coefficients.length <= 1) {
      return Polynomial([Integer.zero]);
    }
    var newCoefficients = <Number>[];
    for (var i = 0; i < coefficients.length - 1; i++) {
      newCoefficients.add(coefficients[i] * (coefficients.length - i - 1));
    }

    return Polynomial(newCoefficients);
  }

  /// Returns the integral of the Polynomial equation from 0 to x.
  ///
  /// This implementation assumes the integral from 0 to x, you might want to modify it according to your needs.
  ///
  /// Example:
  /// ```dart
  /// var quad = Polynomial([2, -3, -2]);
  /// print(quad.integrate()); // Output: 2/3x³ - 3/2x² - 2x
  /// ```
  /// Assuming indefinite integral, the constant of integration (C) is 0
  @override
  Expression integrate([dynamic start, dynamic end]) {
    var newCoefficients = <Number>[Integer.zero];
    for (var i = 0; i < coefficients.length; i++) {
      newCoefficients.add(coefficients[i] / (coefficients.length - i));
    }
    newCoefficients.add(Integer.zero); // Adding the constant of integration

    return Polynomial(newCoefficients);

    // if (start == null && end == null) {
    //   // If no start and end provided, return the indefinite integral.
    //   return integral;
    // } else if (start != null && end == null) {
    //   return integral.evaluate(start);
    // } else if (start == null && end != null) {
    //   return integral.evaluate(end);
    // } else {
    //   // Else, calculate the definite integral between start and end.
    //   return integral.evaluate(end!) - integral.evaluate(start!);
    // }
  }

  @override
  bool isIndeterminate(num x) {
    // For a single polynomial, it's never indeterminate.
    return false;
  }

  /// Simplified. Check if the evaluation at x is infinite.
  @override
  bool isInfinity(num x) {
    return evaluate(x).isInfinite;
  }

  /// Check if an expression is a polynomial
  static bool isPolynomial(String expression) {
    final superscripts = {
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
      '0': '⁰',
    };
    expression = expression.replaceAllMapped(
      RegExp(
          r'x([\u2070-\u2079\u00B9\u00B2\u00B3]+)|([\u2070-\u2079\u00B9\u00B2\u00B3]+)'),
      (match) {
        if (match.group(1) != null) {
          // This is the case when 'x' is followed by superscripts
          return 'x^${match.group(1)!.split('').map((digit) => superscripts[digit]!).join()}';
        } else {
          // This is the case when only superscripts are matched
          return match
              .group(2)!
              .split('')
              .map((digit) => superscripts[digit]!)
              .join();
        }
      },
    );

    // Check if any term has a negative or fractional exponent
    final RegExp expPattern = RegExp(r"x\^-?\d+|x\^\d+/\d+");
    if (expPattern.hasMatch(expression)) {
      return false;
    }

    // Check for any non-polynomial functions
    final RegExp nonPolyPattern = RegExp(r"\w+\(x\)");
    if (nonPolyPattern.hasMatch(expression)) {
      return false;
    }

    // If the expression passed the above checks, it's a polynomial
    return true;
  }

  @override
  String toString([bool useUnicode = true]) {
    final superscripts = {
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
      '0': '⁰',
    };
    // if (coefficients.every((coeff) => coeff == Integer.zero)) {
    //   return "0";
    // }

    // Polynomial to convert an integer to its superscript representation
    String toSuperscript(Number number) {
      return number
          .toString()
          .split('')
          .map((digit) => superscripts[digit]!)
          .join();
    }

    var buffer = StringBuffer();
    for (var i = 0; i < coefficients.length; i++) {
      final coeff = coefficients[i];
      if (coeff != Integer.zero) {
        final termDegree = degree - i;
        if (i != 0 && buffer.isNotEmpty) {
          // Not the first term
          if (coeff > 0) buffer.write(' + ');
          if (coeff < 0) buffer.write(' - ');
        } else if (coeff < 0) {
          // For the first term
          buffer.write('-');
        }
        final absCoeff = coeff.abs();
        if (absCoeff != Integer.one || termDegree == Integer.zero) {
          buffer.write(Number.simplifyType(absCoeff));
        }
        if (termDegree > 0) buffer.write('x');
        if (termDegree > 1) {
          if (useUnicode) {
            buffer.write(toSuperscript(termDegree));
          } else {
            buffer.write('^$termDegree');
          }
        }
      }
    }

    return buffer.toString();
  }

  /// Evaluates the Polynomial for a given x value.
  @override
  Number evaluate([dynamic x]) {
    Number result = Double.zero;
    for (var i = 0; i < coefficients.length; i++) {
      result += coefficients[i] *
          pow(x is Number ? numberToNum(x) : x, coefficients.length - 1 - i);
    }
    return result;
  }

  /// Simplify the Polynomial using factoring by grouping and difference of squares.
  /// This is a placeholder and should be replaced with actual implementation.
  /// Return a new simplified Polynomial
  @override
  Polynomial simplify() {
    Number gcdR = coefficients.reduce((value, element) =>
        numToNumber(gcd([value.toDouble(), element.toDouble()])));

    List<Number> newCoefficients = coefficients.map((c) => c ~/ gcdR).toList();

    return Polynomial(newCoefficients);
  }

  List<dynamic> roots() {
    // 1. Simplify the Polynomial
    //Polynomial simplified = ((expand() as Polynomial).simplify()) as Polynomial;
    Polynomial simplified = simplify();

    if (simplified.coefficients.length == 1) {
      // Constant values
      return [simplified.coefficients[0]];
    } else if (simplified.coefficients.length == 2) {
      // linear
      return Linear.fromList(simplified.coefficients).roots();
    } else if (simplified.coefficients.length == 3) {
      // quadratic
      return Quadratic.fromList(simplified.coefficients).roots();
    } else if (simplified.coefficients.length == 4) {
      // cubic
      return Cubic.fromList(simplified.coefficients).roots();
    } else if (simplified.coefficients.length == 5) {
      return Quartic.fromList(simplified.coefficients).roots();
    } else {
      // 3. For higher degree Polynomials, use a numerical method like Durand-Kerner or NewtonsMethod
      return DurandKerner(
        simplified.coefficients,
      ).roots();
    }
  }

  /// Returns a list of string polynomial factors derived from the complex roots of a polynomial.
  ///
  /// This function determines the factors of a polynomial based on its complex roots.
  /// Each root corresponds to a factor of the form `(x - root)` or `(x + root)`. If the root
  /// is complex, the factor will also represent the imaginary part.
  ///
  /// Example:
  ///   If the roots are `2`, `-3`, and `1 + 4i`, the returned factors would be
  ///   `[(x - 2), (x + 3), (x - 1 - 4i)]`.
  ///
  /// Returns:
  ///   A list of strings where each string is a polynomial factor.
  String factorizeString() {
    List<String> factors = [];

    // Add the leading coefficient if it's not 1
    if (coefficients.first != Integer.one) {
      factors.add('${coefficients.first}');
    }

    for (var root in roots()) {
      if (root is Imaginary) {
        String imaginaryPart = '0';

        if (root != Imaginary(0)) {
          imaginaryPart = 'x ${root > Imaginary(0) ? '-' : '+'} ${root.abs()}i';
        }
        factors.add(imaginaryPart);
      } else if (root is Complex) {
        String realPart =
            '(x ${root.real > Integer(0) ? '-' : '+'} ${root.real.abs()}';
        String imaginaryPart = '';

        if (root.imag != Imaginary(0)) {
          imaginaryPart =
              ' ${root.imag > Imaginary(0) ? '-' : '+'} ${root.imag.abs()}i';
        }

        factors.add('$realPart$imaginaryPart)');
      } else {
        factors.add('(x ${root > Integer(0) ? '-' : '+'} ${root.abs()})');
      }
    }

    return factors.join(' * ');
  }

  /// Returns a list of polynomial factors derived from the complex roots of a polynomial.
  ///
  /// This function determines the factors of a polynomial based on its complex roots.
  /// Each root corresponds to a factor of the form `(x - root)` or `(x + root)`. If the root
  /// is complex, the factor will also represent the imaginary part.
  ///
  /// Example:
  ///   If the roots are `2`, `-3`, and `1 + 4i`, the returned factors would be
  ///   `[(x - 2), (x + 3), (x - 1 - 4i)]`.
  ///
  /// Returns:
  ///   A list of strings where each string is a polynomial factor.
  List<Polynomial> factorize() {
    List<Polynomial> factors = [];

    for (dynamic root in roots()) {
      factors.add(Polynomial([Integer(1), -root]));
    }

    // Add the leading coefficient if it's not 1
    if (coefficients.first != Integer.one) {
      factors[0] = Polynomial(
          factors[0].coefficients.map((e) => e * coefficients.first).toList());
    }

    return factors;
  }

  // @override
  // int compareTo(dynamic other) {
  //   return Comparable.compare(this, other);
  // }

  Number discriminant() => Complex.zero();

  @override
  Set<Variable> getVariableTerms() {
    return {Variable('x')};
  }

  @override
  Expression substitute(Expression oldExpr, Expression newExpr) {
    if (this == oldExpr) {
      return newExpr;
    }
    // For a more robust implementation, you'd want to substitute 'x' in the polynomial.
    return this; // Placeholder, actual implementation can be more complex.
  }

  // Calculating the depth
  @override
  int depth() {
    return 1;
  }

  // Calculating the size
  @override
  int size() {
    // The size can be the number of non-zero coefficients.
    return coefficients.where((coeff) => coeff != Integer.zero).length;
  }

  @override
  Expression expand() {
    print(Expression.parse(toString(false)));
    return Polynomial.fromString(
      Expression.parse(toString(false)).expand().toString(),
    );
  }
}
