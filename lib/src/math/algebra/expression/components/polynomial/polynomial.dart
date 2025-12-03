part of '../../expression.dart';

/// A class representing a Polynomial of arbitrary degree.
class Polynomial extends Expression {
  final List<Expression> coefficients;
  final Variable variable;

  Polynomial(List<dynamic> coefficients, {Variable? variable})
      : coefficients = coefficients.map((e) {
          if (e is Expression) return e;
          if (e is Complex) return Literal(e);
          if (e is num) return Literal(Complex(e));
          try {
            return Literal(Complex.parse(e.toString()));
          } catch (_) {
            return Expression.parse(e.toString());
          }
        }).toList(),
        variable = variable ?? Variable('x');

  late Polynomial polynomial;

  /// Constructs a Polynomial from a list of coefficients.
  ///
  /// The coefficients should be provided in decreasing order of degree,
  /// i.e., from the coefficient of the highest-degree term to the constant term.
  static Polynomial fromList(List<dynamic> coefficientList,
      {Variable? variable}) {
    {
      List<Expression> coefficients = coefficientList.map((e) {
        if (e is Expression) return e;
        if (e is Complex) return Literal(e);
        if (e is num) return Literal(Complex(e));
        try {
          return Literal(Complex.parse(e.toString()));
        } catch (_) {
          return Expression.parse(e.toString());
        }
      }).toList();
      // side effects if 'coefficients' is altered
      switch (coefficients.length) {
        case 1:
          return Constant(
            a: coefficients.first,
            variable: variable,
          );
        case 2:
          return Linear(
            a: coefficients.first,
            b: coefficients[1],
            variable: variable,
          );
        case 3:
          return Quadratic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
            variable: variable,
          );
        case 4:
          return Cubic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
            d: coefficients[3],
            variable: variable,
          );
        case 5:
          return Quartic(
            a: coefficients.first,
            b: coefficients[1],
            c: coefficients[2],
            d: coefficients[3],
            e: coefficients[4],
            variable: variable,
          );
        default:
          return DurandKerner(coefficients, variable: variable);
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
  factory Polynomial.fromString(String source, {Variable? variable}) {
    // print('DEBUG: Polynomial.fromString source: $source variable: $variable');
    try {
      // Use provided variable or default to 'x'
      final varName = variable?.identifier.name ?? 'x';

      // If the variable is not 'x', replace it with 'x' for parsing
      // if (varName != 'x') {
      //   source = source.replaceAll(varName, 'x');
      // }

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

      // Regex to match terms:
      // Group 1: Term with variable (e.g., 3x^2, -x, 0.5x, a*x, -a*c*x)
      // Group 2: Constant term
      // We need to be more permissive with coefficients to allow variables
      // But we must ensure we don't consume the variable itself if it's part of the coefficient?
      // No, the coefficient is everything BEFORE the variable.
      // So we match `(.*?)` before `varName`.
      // But we need to be careful about splitting terms.
      // Terms are split by + or - (unless inside parentheses, but Polynomials are usually expanded).
      // A safer approach might be to split by `+` and `-` first, then parse each term?
      // But `+` and `-` can be unary.

      // Let's try to broaden the existing regex to allow identifiers in coefficient.
      // Old: `([+-]?(?:\d+(?:\.\d+)?|\.\d+)?\*?`
      // New: `([+-]?(?:[a-zA-Z0-9_.]+(?:\*[a-zA-Z0-9_.]+)*)?\*?`
      // This is getting complicated.
      // Maybe we can match the variable part `x^n` and capture everything before it?

      final RegExp expPattern = RegExp(
          r"([+-]?(?:(?:[a-zA-Z0-9_.]+(?:\*[a-zA-Z0-9_.]+)*)?\*?)?" +
              RegExp.escape(varName) +
              r"(?:\^\d+)?)|([+-]?(?:[a-zA-Z0-9_.]+(?:\*[a-zA-Z0-9_.]+)*))");

      var matches = expPattern.allMatches(source).toList();

      if (matches.isEmpty) {
        throw FormatException(
            "Input does not contain any valid Polynomial terms");
      }

      // Strict check: Ensure all characters are consumed by matches
      // Check if all content was matched
      String matchedStr = matches.map((m) => m.group(0)).join('');
      if (matchedStr.length != source.length) {
        // print('DEBUG: Polynomial.fromString mismatch. Source: $source, Matched: $matchedStr');
        throw FormatException('Invalid polynomial format: $source');
      }

      var terms = <int, Expression>{};
      int maxDegree = 0;

      for (var match in matches) {
        String term = match.group(0)!;

        // Check if it's a variable term or constant
        if (match.group(1) != null) {
          // Term with variable
          String varTerm = match.group(1)!;

          // Extract coefficient and exponent
          String coeffStr;
          String expStr;

          if (varTerm.contains('^')) {
            var parts = varTerm.split('^');
            expStr = parts[1];
            coeffStr = parts[0].substring(
                0, parts[0].length - varName.length); // Remove variable
          } else {
            expStr = '1';
            coeffStr = varTerm.substring(
                0, varTerm.length - varName.length); // Remove variable
          }

          // Strip trailing * if present
          if (coeffStr.endsWith('*')) {
            coeffStr = coeffStr.substring(0, coeffStr.length - 1);
          }

          // Handle implicit 1 or -1
          if (coeffStr.isEmpty || coeffStr == '+') {
            coeffStr = '1';
          } else if (coeffStr == '-') {
            coeffStr = '-1';
          }

          // Parse coefficient as Expression
          Expression coeff;
          try {
            coeff = Literal(Complex.parse(coeffStr));
          } catch (_) {
            // If not a number, parse as Expression
            coeff = Expression.parse(coeffStr);
          }

          int degree = int.parse(expStr);

          // Add to existing coefficient
          if (terms.containsKey(degree)) {
            terms[degree] = Add(terms[degree]!, coeff).simplifyBasic();
          } else {
            terms[degree] = coeff;
          }

          if (degree > maxDegree) maxDegree = degree;
        } else {
          // Constant term
          Expression coeff;
          try {
            coeff = Literal(Complex.parse(term));
          } catch (_) {
            coeff = Expression.parse(term);
          }

          if (terms.containsKey(0)) {
            terms[0] = Add(terms[0]!, coeff).simplifyBasic();
          } else {
            terms[0] = coeff;
          }
        }
      }

      var coefficients = List<dynamic>.filled(maxDegree + 1, Literal(0));
      for (var i = 0; i <= maxDegree; i++) {
        coefficients[maxDegree - i] = terms[i] ?? Literal(0);
      }

      return Polynomial(coefficients, variable: variable);
    } catch (e) {
      // Handle exceptions and rethrow a formatted exception message
      // print('DEBUG: Polynomial.fromString throwing exception: $e');
      throw FormatException("Failed to parse Polynomial: $e");
    }
  }

  /// Get the degree of the Polynomial
  ///
  /// Returns an integer representing the degree
  int get degree => coefficients.length - 1;

  // Addition of Polynomials
  @override
  Expression operator +(dynamic other) {
    if (other is Polynomial) {
      int maxDegree = max(coefficients.length, other.coefficients.length);
      List<Expression> result =
          List<Expression>.generate(maxDegree, (index) => Literal(0));

      for (var i = 0; i < maxDegree; i++) {
        Expression a = i < coefficients.length ? coefficients[i] : Literal(0);
        Expression b =
            i < other.coefficients.length ? other.coefficients[i] : Literal(0);
        // Use simplifyBasic to combine literals if possible
        result[i] = Add(a, b).simplifyBasic();
      }
      return Polynomial(result, variable: variable);
    }
    return Add(this, other);
  }

  // Subtraction of Polynomials
  @override
  Expression operator -(dynamic other) {
    if (other is Polynomial) {
      int maxDegree = max(coefficients.length, other.coefficients.length);
      List<Expression> result =
          List<Expression>.generate(maxDegree, (index) => Literal(0));

      for (var i = 0; i < maxDegree; i++) {
        Expression a = i < coefficients.length ? coefficients[i] : Literal(0);
        Expression b =
            i < other.coefficients.length ? other.coefficients[i] : Literal(0);
        result[i] = Subtract(a, b).simplifyBasic();
      }
      return Polynomial(result, variable: variable);
    }
    return Subtract(this, other);
  }

  // Multiplication of Polynomials
  @override
  Expression operator *(dynamic other) {
    if (other is Polynomial) {
      int resultDegree = coefficients.length + other.coefficients.length - 2;
      List<Expression> result =
          List<Expression>.generate(resultDegree + 1, (index) => Literal(0));

      for (var i = 0; i < coefficients.length; i++) {
        for (var j = 0; j < other.coefficients.length; j++) {
          // result[i+j] += coeff[i] * other[j]
          result[i + j] = Add(result[i + j],
                  Multiply(coefficients[i], other.coefficients[j]))
              .simplifyBasic();
        }
      }
      return Polynomial(result, variable: variable);
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
          equalsCount == coefficients.length &&
          variable == other.variable;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(coefficients), variable);

  @override
  Expression operator /(dynamic other) {
    if (other is Polynomial) {
      // Check for zero polynomial
      if (other.coefficients.isEmpty ||
          (other.coefficients.first is Literal &&
              (other.coefficients.first as Literal).value == Complex.zero())) {
        throw Exception('Division by zero polynomial.');
      }

      List<Expression> dividendCoeffs = _trimLeadingZeros(coefficients);
      List<Expression> divisorCoeffs = _trimLeadingZeros(other.coefficients);

      int dividendDegree = dividendCoeffs.length - 1;
      int divisorDegree = divisorCoeffs.length - 1;

      if (divisorDegree > dividendDegree) {
        return Add(Polynomial([Literal(0)]), RationalFunction(this, other));
      }

      List<Expression> quotientCoeffs =
          List.filled(dividendDegree - divisorDegree + 1, Literal(0));

      for (int k = 0; k <= dividendDegree - divisorDegree; k++) {
        // quotient[k] = dividend[k] / divisor[0]
        quotientCoeffs[k] =
            Divide(dividendCoeffs[k], divisorCoeffs[0]).simplifyBasic();
        for (int j = 0; j <= divisorDegree; j++) {
          // dividend[k+j] -= quotient[k] * divisor[j]
          dividendCoeffs[k + j] = Subtract(dividendCoeffs[k + j],
                  Multiply(quotientCoeffs[k], divisorCoeffs[j]))
              .simplifyBasic();
        }
      }

      // Correcting the range of indices for the remainder coefficients
      List<Expression> remainderCoeffs =
          dividendCoeffs.sublist(dividendDegree - divisorDegree + 1);

      return Add(
        Polynomial(_trimLeadingZeros(quotientCoeffs), variable: variable),
        RationalFunction(
            Polynomial(_trimLeadingZeros(remainderCoeffs), variable: variable),
            other),
      );
    }
    return Divide(this, other);
  }

  @override
  Expression operator %(dynamic other) {
    if (other is Polynomial) {
      if (other.coefficients.isEmpty ||
          (other.coefficients.first is Literal &&
              (other.coefficients.first as Literal).value == Complex.zero())) {
        throw Exception('Division by zero polynomial.');
      }

      List<Expression> dividendCoeffs = _trimLeadingZeros(coefficients);
      List<Expression> divisorCoeffs = _trimLeadingZeros(other.coefficients);

      int dividendDegree = dividendCoeffs.length - 1;
      int divisorDegree = divisorCoeffs.length - 1;

      if (divisorDegree > dividendDegree) {
        return this;
      }

      List<Expression> quotientCoeffs =
          List.filled(dividendDegree - divisorDegree + 1, Literal(0));

      for (int k = 0; k <= dividendDegree - divisorDegree; k++) {
        quotientCoeffs[k] =
            Divide(dividendCoeffs[k], divisorCoeffs[0]).simplifyBasic();
        for (int j = 0; j <= divisorDegree; j++) {
          dividendCoeffs[k + j] = Subtract(dividendCoeffs[k + j],
                  Multiply(quotientCoeffs[k], divisorCoeffs[j]))
              .simplifyBasic();
        }
      }

      // The remainder is what's left in dividendCoeffs (after the subtraction loops)
      // We need to trim it again to be sure
      return Polynomial(
          _trimLeadingZeros(
              dividendCoeffs.sublist(dividendDegree - divisorDegree + 1)),
          variable: variable);
    }
    return Modulo(this, other);
  }

  /// Calculates the Greatest Common Divisor of two polynomials.
  Polynomial gcd(Polynomial other) {
    Polynomial a = this;
    Polynomial b = other;

    while (b.coefficients.length > 1 ||
        (b.coefficients.isNotEmpty &&
            b.coefficients[0] is Literal &&
            (b.coefficients[0] as Literal).value != Complex.zero())) {
      Polynomial temp = b;
      Expression remainder = a % b;
      if (remainder is! Polynomial) {
        // Should not happen if both are polynomials
        throw Exception('Remainder is not a polynomial');
      }
      b = remainder;
      a = temp;
    }

    // Normalize result (make leading coefficient 1)
    if (a.coefficients.isNotEmpty &&
        a.coefficients[0] is Literal &&
        (a.coefficients[0] as Literal).value != Complex.zero()) {
      var leading = a.coefficients[0];
      var newCoeffs = a.coefficients
          .map((c) => Divide(c, leading).simplifyBasic())
          .toList();
      return Polynomial(newCoeffs, variable: variable);
    }
    return a;
  }

  /// Calculates the Least Common Multiple of two polynomials.
  Polynomial lcm(Polynomial other) {
    if ((coefficients.length == 1 &&
            coefficients[0] is Literal &&
            (coefficients[0] as Literal).value == Complex.zero()) ||
        (other.coefficients.length == 1 &&
            other.coefficients[0] is Literal &&
            (other.coefficients[0] as Literal).value == Complex.zero())) {
      return Polynomial([Literal(0)], variable: variable);
    }

    Polynomial product = (this * other) as Polynomial;
    Polynomial divisor = gcd(other);

    // We use the division logic but we know it should be exact
    Expression result = product / divisor;
    if (result is Polynomial) return result;
    // If division returns Add(Poly, Rational), extract Poly
    if (result is Add && result.left is Polynomial) {
      return result.left as Polynomial;
    }

    return product; // Fallback
  }

  /// Helper function to clean up the zeroes
  List<Expression> _trimLeadingZeros(List<Expression> coeffs) {
    int i = 0;
    while (i < coeffs.length &&
        coeffs[i] is Literal &&
        (coeffs[i] as Literal).value == Complex.zero()) {
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
  dynamic operator [](int index) => coefficients[index];

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
  dynamic coefficient(int degree) {
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
  /// print(quad.differentiate(v)); // Output: 4x - 3
  /// ```
  @override
  Expression differentiate([Variable? v]) {
    if (coefficients.length <= 1) {
      return Polynomial([Literal(0)], variable: variable);
    }
    var newCoefficients = <Expression>[];
    for (var i = 0; i < coefficients.length - 1; i++) {
      // newCoefficients.add(coefficients[i] * (coefficients.length - i - 1));
      newCoefficients.add(
          Multiply(coefficients[i], Literal(coefficients.length - i - 1))
              .simplifyBasic());
    }

    return Polynomial(newCoefficients, variable: variable);
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
    var newCoefficients = <Expression>[Literal(0)];
    for (var i = 0; i < coefficients.length; i++) {
      // newCoefficients.add(coefficients[i] / (coefficients.length - i));
      newCoefficients.add(
          Divide(coefficients[i], Literal(coefficients.length - i))
              .simplifyBasic());
    }
    newCoefficients.add(Literal(0)); // Adding the constant of integration

    return Polynomial(newCoefficients, variable: variable);
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

  @override
  bool isPoly([bool strict = false]) => true;

  /// Check if an expression is a polynomial
  static bool isPolynomial(String expression, {String varName = 'x'}) {
    try {
      // Basic check for unsupported functions
      // Check for any non-polynomial functions (sin, cos, exp, etc.)
      final RegExp nonPolyPattern =
          RegExp(r"\b(sin|cos|tan|asin|acos|atan|exp|ln|log|sqrt)\b");
      if (nonPolyPattern.hasMatch(expression)) {
        return false;
      }

      // Try to parse it using fromString
      // This reuses the strict logic in fromString
      Polynomial.fromString(expression, variable: Variable(varName));
      return true;
    } catch (e) {
      return false;
    }
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

    // Polynomial to convert an integer to its superscript representation
    String toSuperscript(dynamic number) {
      return number
          .toString()
          .split('')
          .map((digit) => superscripts[digit]!)
          .join();
    }

    var buffer = StringBuffer();
    for (var i = 0; i < coefficients.length; i++) {
      final coeff = coefficients[i];
      if (coeff is Literal && coeff.value == Complex.zero()) {
        continue;
      }

      final termDegree = degree - i;

      // Determine sign and absolute value
      bool isNegative = false;
      Expression absCoeff = coeff;

      if (coeff is Literal && coeff.value is Complex) {
        Complex c = coeff.value as Complex;
        if (c.imaginary == 0) {
          if (c.real < 0) {
            isNegative = true;
            absCoeff = Literal(Complex(-c.real, 0));
          }
        }
      } else if (coeff is UnaryExpression && coeff.operator == '-') {
        isNegative = true;
        absCoeff = coeff.operand;
      }

      if (i != 0 && buffer.isNotEmpty) {
        // Not the first term
        if (isNegative) {
          buffer.write(' - ');
        } else {
          buffer.write(' + ');
        }
      } else if (isNegative) {
        // For the first term
        buffer.write('-');
      }

      // Print coefficient
      if (absCoeff is Literal &&
          absCoeff.value == Complex.one() &&
          termDegree != 0) {
        // Don't print 1 if variable follows
      } else {
        buffer.write(absCoeff);
      }

      if (termDegree > 0) buffer.write(variable.identifier.name);
      if (termDegree > 1) {
        if (useUnicode) {
          buffer.write(toSuperscript(termDegree));
        } else {
          buffer.write('^$termDegree');
        }
      }
    }

    if (buffer.isEmpty) return '0';

    return buffer.toString();
  }

  /// Evaluates the Polynomial for a given x value.
  @override
  dynamic evaluate([dynamic x]) {
    dynamic result = Complex.zero();
    for (var i = 0; i < coefficients.length; i++) {
      // result += coefficients[i] * pow(x, coefficients.length - 1 - i);
      var term = Multiply(coefficients[i],
          Pow(Literal(x), Literal(coefficients.length - 1 - i)));
      result = Add(Literal(result), term).evaluate();
    }
    return result;
  }

  /// Simplify the Polynomial using factoring by grouping and difference of squares.
  /// This is a placeholder and should be replaced with actual implementation.
  /// Return a new simplified Polynomial
  @override
  Polynomial simplify() {
    // Check if all coefficients are literals
    bool allLiterals = coefficients.every((c) => c is Literal);

    if (!allLiterals) {
      // If any coefficient is symbolic, return as-is (or try to simplify expressions)
      List<Expression> simplifiedCoeffs =
          coefficients.map((c) => c.simplifyBasic()).toList();
      return Polynomial(simplifiedCoeffs, variable: variable);
    }

    // Extract real parts for GCD calculation
    List<num> realParts = coefficients.map((c) {
      Complex val = (c as Literal).value as Complex;
      return val.real;
    }).toList();

    // Compute GCD of real parts (convert to int if possible)
    num gcdValue = realParts.map((r) {
      // If the real part is an integer, use it; otherwise, skip GCD simplification
      if (r != r.truncateToDouble()) {
        return 1.0; // Non-integer, can't simplify
      }
      return r.abs().toInt();
    }).reduce((a, b) => math.gcd([a, b]));

    // If GCD is 1 or 0, no simplification needed
    if (gcdValue == 1 || gcdValue == 0) {
      return this;
    }

    // Divide all coefficients by the GCD
    List<Expression> newCoefficients = coefficients.map((c) {
      Complex val = (c as Literal).value as Complex;
      return Literal(Complex(val.real / gcdValue, val.imaginary / gcdValue));
    }).toList();

    return Polynomial(newCoefficients, variable: variable);
  }

  List<dynamic> roots() {
    // 1. Simplify the Polynomial
    //Polynomial simplified = ((expand() as Polynomial).simplify()) as Polynomial;
    Polynomial simplified = simplify();

    if (simplified.coefficients.length == 1) {
      // Constant values - no roots unless 0 (infinite)
      // For now return empty list
      return [];
    } else if (simplified.coefficients.length == 2) {
      // linear
      return Linear.fromList(simplified.coefficients, variable: variable)
          .roots();
    } else if (simplified.coefficients.length == 3) {
      // quadratic
      return Quadratic.fromList(simplified.coefficients, variable: variable)
          .roots();
    } else if (simplified.coefficients.length == 4) {
      // cubic
      return Cubic.fromList(simplified.coefficients, variable: variable)
          .roots();
    } else if (simplified.coefficients.length == 5) {
      return Quartic.fromList(simplified.coefficients, variable: variable)
          .roots();
    } else {
      // 3. For higher degree Polynomials, use a numerical method like Durand-Kerner or NewtonsMethod
      return DurandKerner(simplified.coefficients, variable: variable).roots();
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
    if (coefficients.isNotEmpty &&
        (coefficients.first is! Literal ||
            (coefficients.first as Literal).value != Complex.one())) {
      factors.add('${coefficients.first}');
    }

    for (var root in roots()) {
      if (root is Complex) {
        String realPart =
            '(${variable.identifier.name} ${root.real > 0 ? '-' : '+'} ${root.real.abs()}';
        String imaginaryPart = '';

        if (root.imaginary != 0) {
          imaginaryPart =
              ' ${root.imaginary > 0 ? '-' : '+'} ${root.imaginary.abs()}i';
        }

        factors.add('$realPart$imaginaryPart)');
      } else if (root is num) {
        factors.add(
            '(${variable.identifier.name} ${root > 0 ? '-' : '+'} ${root.abs()})');
      } else {
        // Symbolic root
        factors.add('(${variable.identifier.name} - ($root))');
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
      factors.add(Polynomial([1, -root], variable: variable));
    }

    // Add the leading coefficient if it's not 1
    if (coefficients.first != Complex.one()) {
      factors[0] = Polynomial(
          factors[0].coefficients.map((e) => e * coefficients.first).toList(),
          variable: variable);
    }

    return factors;
  }

  // @override
  // int compareTo(dynamic other) {
  //   return Comparable.compare(this, other);
  // }

  dynamic discriminant() => Complex.zero();

  @override
  Set<Variable> getVariableTerms() {
    return {variable};
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
    return coefficients.where((coeff) => coeff != Complex.zero()).length;
  }

  @override
  Expression expand() {
    print(Expression.parse(toString(false)));
    return Polynomial.fromString(
      Expression.parse(toString(false)).expand().toString(),
    );
  }
}
