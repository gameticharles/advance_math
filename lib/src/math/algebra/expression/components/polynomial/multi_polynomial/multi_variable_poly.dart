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
  dynamic evaluate([dynamic x]) {
    dynamic total = Complex.zero();
    for (var term in terms) {
      total += Complex(term.evaluate(x));
    }
    return total.simplify();
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
            resultTerms[i] =
                Term(newCoefficient, Map.from(resultTerms[i].variables));
            found = true;
            break;
          }
        }

        if (!found) {
          resultTerms.add(Term(term.coefficient, Map.from(term.variables)));
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
            resultTerms[i] =
                Term(newCoefficient, Map.from(resultTerms[i].variables));
            found = true;
            break;
          }
        }
        if (!found) {
          resultTerms.add(Term(-term.coefficient, Map.from(term.variables)));
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

          resultTerms.add(Term(newCoefficient, Map.from(newVariables)));
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
    if (terms.every((term) => Complex(term.coefficient) == Complex.zero())) {
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
      if (absCoeff != 0 || term.variables.isEmpty) {
        buffer.write(absCoeff);
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
    return 1; // Flat sum of terms
  }

  @override
  Expression differentiate([Variable? v]) {
    // Determine the variable to differentiate with respect to
    Set<String> allVars = {};
    for (var term in terms) {
      allVars.addAll(term.variables.keys);
    }

    String targetVar;
    if (allVars.contains('x')) {
      targetVar = 'x';
    } else if (allVars.length == 1) {
      targetVar = allVars.first;
    } else {
      throw ArgumentError(
          "Ambiguous differentiation: Polynomial contains multiple variables ${allVars.toList()} and 'x' is not present. Please specify variable (not supported in this interface yet).");
    }

    List<Term> newTerms = [];
    for (var term in terms) {
      if (term.variables.containsKey(targetVar)) {
        int power = term.variables[targetVar]!;
        var newCoeff = term.coefficient * power;
        var newVars = Map<String, int>.from(term.variables);

        if (power == 1) {
          newVars.remove(targetVar);
        } else {
          newVars[targetVar] = power - 1;
        }

        newTerms.add(Term(newCoeff, newVars));
      }
      // Constants (w.r.t targetVar) differentiate to 0, so we don't add them.
    }

    if (newTerms.isEmpty) {
      return MultiVariablePolynomial([Term(0, {})]);
    }

    return MultiVariablePolynomial(newTerms);
  }

  @override
  Expression expand() {
    return this; // Already expanded
  }

  @override
  Set<Variable> getVariableTerms() {
    Set<Variable> variables = {};
    for (var term in terms) {
      for (var variableName in term.variables.keys) {
        variables.add(Variable(variableName));
      }
    }
    return variables;
  }

  @override
  Expression integrate() {
    // Determine the variable to integrate with respect to
    Set<String> allVars = {};
    for (var term in terms) {
      allVars.addAll(term.variables.keys);
    }

    String targetVar;
    if (allVars.contains('x')) {
      targetVar = 'x';
    } else if (allVars.length == 1) {
      targetVar = allVars.first;
    } else if (allVars.isEmpty) {
      targetVar = 'x'; // Default to x for constants
    } else {
      throw ArgumentError(
          "Ambiguous integration: Polynomial contains multiple variables ${allVars.toList()} and 'x' is not present. Please specify variable (not supported in this interface yet).");
    }

    List<Term> newTerms = [];
    for (var term in terms) {
      var newVars = Map<String, int>.from(term.variables);
      num newCoeff;

      if (newVars.containsKey(targetVar)) {
        int power = newVars[targetVar]!;
        newVars[targetVar] = power + 1;
        newCoeff = term.coefficient / (power + 1);
      } else {
        newVars[targetVar] = 1;
        newCoeff = term.coefficient; // * x^1 / 1
      }
      newTerms.add(Term(newCoeff, newVars));
    }

    return MultiVariablePolynomial(newTerms);
  }

  @override
  Expression simplify() {
    List<Term> simplifiedTerms = [];

    // Group terms by variables
    for (var term in terms) {
      bool found = false;
      for (int i = 0; i < simplifiedTerms.length; i++) {
        if (_mapEquals(simplifiedTerms[i].variables, term.variables)) {
          var newCoefficient =
              simplifiedTerms[i].coefficient + term.coefficient;
          simplifiedTerms[i] =
              Term(newCoefficient, Map.from(simplifiedTerms[i].variables));
          found = true;
          break;
        }
      }
      if (!found) {
        simplifiedTerms.add(Term(term.coefficient, Map.from(term.variables)));
      }
    }

    // Remove terms with zero coefficient (unless it's the only term, but even then 0 is fine)
    simplifiedTerms
        .removeWhere((term) => Complex(term.coefficient) == Complex.zero());

    if (simplifiedTerms.isEmpty) {
      return MultiVariablePolynomial([Term(0, {})]);
    }

    return MultiVariablePolynomial(simplifiedTerms);
  }

  @override
  int size() {
    return terms.length;
  }

  @override
  bool isIndeterminate(num x) {
    // Check if univariate to use x
    Set<String> allVars = {};
    for (var term in terms) {
      allVars.addAll(term.variables.keys);
    }

    if (allVars.length > 1) {
      throw ArgumentError(
          "isIndeterminate(num x) is only supported for univariate polynomials or constants. Found variables: $allVars");
    }

    String varName = allVars.isEmpty ? 'x' : allVars.first;
    try {
      var val = evaluate({varName: x});
      if (val is Complex) {
        return val.value.isNaN;
      }
      return (val as num).isNaN;
    } catch (e) {
      // If evaluation fails (e.g. division by zero), it is indeterminate.
      // However, if it's a missing variable error, we should probably rethrow, but we checked vars above.
      return true;
    }
  }

  @override
  bool isInfinity(num x) {
    // Check if univariate to use x
    Set<String> allVars = {};
    for (var term in terms) {
      allVars.addAll(term.variables.keys);
    }

    if (allVars.length > 1) {
      throw ArgumentError(
          "isInfinity(num x) is only supported for univariate polynomials or constants. Found variables: $allVars");
    }

    String varName = allVars.isEmpty ? 'x' : allVars.first;
    var val = evaluate({varName: x});
    if (val is Complex) {
      return val.value.isInfinite;
    }
    return (val as num).isInfinite;
  }

  @override
  bool isPoly([bool strict = false]) => true;

  // ... (Other methods from the Expression class, like differentiate, evaluate, etc.)
}
