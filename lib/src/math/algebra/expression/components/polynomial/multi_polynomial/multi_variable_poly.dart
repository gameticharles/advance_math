part of '../../../expression.dart';

class MultiVariablePolynomial extends Expression {
  final List<Term> terms;

  MultiVariablePolynomial(this.terms);

  /// Constructs a MultivariatePolynomial from a string representation.
  ///
  /// The input string should represent a Polynomial with terms in the format `ax^by^c`,
  /// where `a` is the coefficient and `b` & `c` are the exponents for variables `x` & `y` respectively.
  ///
  /// [source]: A string representation of a Multivariate Polynomial.
  ///
  /// Returns a [MultivariatePolynomial] instance representing the input string.
  ///
  /// Throws [FormatException] if the input string is invalid or cannot be parsed into a Polynomial.
  factory MultiVariablePolynomial.fromString(String source) {
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
            r'([\u2070-\u2079\u00B9\u00B2\u00B3]+)|x([\u2070-\u2079\u00B9\u00B2\u00B3]+)'),
        (match) {
          if (match.group(2) != null) {
            // This is the case when 'x' is followed by superscripts
            return 'x^${match.group(2)!.split('').map((digit) => superscripts[digit]!).join()}';
          } else {
            // This is the case when only superscripts are matched
            return match
                .group(1)!
                .split('')
                .map((digit) => superscripts[digit]!)
                .join();
          }
        },
      );

      List<Term> termsList = [];

      // Split the input by + or - signs, while keeping the signs
      var rawTerms = source
          .split(RegExp(r'(?=[+-])|(?<=[+-])'))
          .map((term) => term.trim())
          .toList();

      for (var rawTerm in rawTerms) {
        // Skip if it's just a sign
        if (rawTerm == '+' || rawTerm == '-') continue;

        // Handle the case of standalone numbers
        if (RegExp(r'^[+-]?\d+$').hasMatch(rawTerm)) {
          termsList.add(Term(num.parse(rawTerm), {}));
          continue;
        }

        // Extract coefficient
        final coeffPattern = RegExp(r"([+-]?\d+)?");
        var coeffMatch = coeffPattern.firstMatch(rawTerm);
        num coefficient;
        if (coeffMatch!.group(1) == null || coeffMatch.group(1)!.isEmpty) {
          if (rawTerm.startsWith('-')) {
            coefficient = -1;
          } else {
            coefficient = 1;
          }
        } else {
          coefficient = num.parse(coeffMatch.group(1)!);
        }

        // Extract variables and their powers
        final varPattern = RegExp(r"([a-z])\^(\d+)");
        var varMatches = varPattern.allMatches(rawTerm);
        Map<String, int> variables = {};
        for (var varMatch in varMatches) {
          variables[varMatch.group(1)!] = int.parse(varMatch.group(2)!);
        }

        // For variables without explicit powers (e.g., 'x' in "2x")
        final varWithoutPowerPattern = RegExp(r"([a-z])(?![\^])");
        var varWithoutPowerMatches = varWithoutPowerPattern.allMatches(rawTerm);
        for (var varMatch in varWithoutPowerMatches) {
          variables[varMatch.group(1)!] = 1;
        }

        termsList.add(Term(coefficient, variables));
      }

      return MultiVariablePolynomial(termsList);
    } catch (e) {
      // Handle exceptions and rethrow a formatted exception message
      throw FormatException("Failed to parse MultiVariablePolynomial: $e");
    }
  }

  /// Evaluates the MultiPolynomial for a given x value.
  @override
  Number evaluate([dynamic x]) {
    Number total = Integer.zero;
    for (var term in terms) {
      total += term.evaluate(x);
    }
    return total;
  }

  @override
  Expression operator +(dynamic other) {
    if (other is MultiVariablePolynomial) {
      var resultTerms = [...terms];

      for (var term in other.terms) {
        bool found = false;

        for (int i = 0; i < resultTerms.length; i++) {
          if (_mapEquals(resultTerms[i].variables, term.variables)) {
            var newCoefficient = resultTerms[i].coefficient + term.coefficient;
            resultTerms[i] = Term(numberToNum(newCoefficient),
                Map.from(resultTerms[i].variables));
            found = true;
            break;
          }
        }

        if (!found) {
          resultTerms.add(
              Term(numberToNum(term.coefficient), Map.from(term.variables)));
        }
      }

      return MultiVariablePolynomial(resultTerms);
    }
    return Add(this, other);
  }

  @override
  Expression operator -(dynamic other) {
    if (other is MultiVariablePolynomial) {
      var resultTerms = [...terms];

      for (var term in other.terms) {
        bool found = false;

        for (int i = 0; i < resultTerms.length; i++) {
          if (_mapEquals(resultTerms[i].variables, term.variables)) {
            var newCoefficient = resultTerms[i].coefficient - term.coefficient;
            resultTerms[i] = Term(numberToNum(newCoefficient),
                Map.from(resultTerms[i].variables));
            found = true;
            break;
          }
        }
        if (!found) {
          resultTerms.add(
              Term(numberToNum(-term.coefficient), Map.from(term.variables)));
        }
      }

      return MultiVariablePolynomial(resultTerms);
    }
    return Subtract(this, other);
  }

  @override
  Expression operator *(dynamic other) {
    if (other is MultiVariablePolynomial) {
      List<Term> resultTerms = [];

      for (var a in terms) {
        for (var b in other.terms) {
          var newCoefficient = a.coefficient * b.coefficient;
          var newVariables = Map.from(a.variables);

          for (var key in b.variables.keys) {
            if (newVariables.containsKey(key)) {
              newVariables[key] += b.variables[key];
            } else {
              newVariables[key] = b.variables[key];
            }
          }

          resultTerms
              .add(Term(numberToNum(newCoefficient), Map.from(newVariables)));
        }
      }

      return MultiVariablePolynomial(resultTerms);
    }

    return Multiply(this, other);
  }

  // // For division, we'll implement a placeholder as it's a complex operation for multivariate polynomials.
  // @override
  // MultiVariablePolynomial operator /(MultiVariablePolynomial other) {
  //   // Placeholder: Implement a method for synthetic division or polynomial long division.
  //   throw UnimplementedError(
  //       "Division for multivariate polynomials is not implemented yet.");
  // }

  @override
  String toString() {
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

    // Function to convert an integer to its superscript representation
    String toSuperscript(int number) {
      return number
          .toString()
          .split('')
          .map((digit) => superscripts[digit]!)
          .join();
    }

    // If all coefficients are zero, return "0"
    if (terms.every((term) => term.coefficient == Integer.zero)) {
      return "0";
    }

    var buffer = StringBuffer();
    for (var term in terms) {
      final coeff = term.coefficient;

      // Handle sign and coefficient
      if (buffer.isNotEmpty) {
        if (coeff > 0) buffer.write(' + ');
        if (coeff < 0) buffer.write(' - ');
      } else if (coeff < 0) {
        buffer.write('-');
      }
      final absCoeff = coeff.abs();
      if (absCoeff != Integer.one || term.variables.isEmpty) {
        buffer.write(Number.simplifyType(absCoeff));
      }

      // Handle variables and their powers
      term.variables.forEach((variable, power) {
        buffer.write(variable);
        if (power > 1) {
          buffer.write(toSuperscript(power));
        }
      });
    }

    return buffer.toString();
  }

  @override
  int depth() {
    // TODO: implement depth
    throw UnimplementedError();
  }

  @override
  Expression differentiate() {
    // TODO: implement differentiate
    throw UnimplementedError("Differentiation has not been implemented yet");
  }

  @override
  Expression expand() {
    // TODO: implement expand
    throw UnimplementedError();
  }

  @override
  Set<Variable> getVariableTerms() {
    // TODO: implement getVariableTerms
    throw UnimplementedError();
  }

  @override
  Expression integrate() {
    // TODO: implement integrate
    throw UnimplementedError();
  }

  @override
  Expression simplify() {
    // TODO: implement simplify
    throw UnimplementedError();
  }

  @override
  int size() {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  bool isIndeterminate(num x) {
    throw UnimplementedError();
  }

  @override
  bool isInfinity(num x) {
    throw UnimplementedError();
  }

  // ... (Other methods from the Expression class, like differentiate, evaluate, etc.)
}
