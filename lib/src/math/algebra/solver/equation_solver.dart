import '../../basic/math.dart';
import '../expression/expression.dart';

/// Represents an equation with left and right sides
class Equation {
  final Expression left;
  final Expression right;

  Equation(this.left, this.right);

  /// Convert to standard form: left - right = 0
  Expression toZeroForm() => Subtract(left, right);

  @override
  String toString() => '${left.toString()} = ${right.toString()}';
}

/// Main equation solver using variable isolation
class ExpressionSolver {
  /// Solve equation for variable v
  /// Returns list of solutions (equations may have multiple solutions)
  static List<Expression> solve(Expression equation, Variable v) {
    // First, try polynomial solver if applicable
    if (_isPolynomialEquation(equation, v)) {
      return _solvePolynomial(equation, v);
    }

    // Otherwise, use variable isolation
    return _solveByIsolation(equation, v);
  }

  /// Check if equation can be solved as polynomial
  static bool _isPolynomialEquation(Expression expr, Variable v) {
    try {
      // Try to convert to polynomial
      final terms = expr.getVariableTerms();
      if (terms.isEmpty) return false;

      // Check if all variable terms are polynomial powers
      return _allPolynomialTerms(expr, v);
    } catch (e) {
      return false;
    }
  }

  static bool _allPolynomialTerms(Expression expr, Variable v) {
    // Simplified check: expression should be polynomial-like
    // This is a heuristic - full implementation would be more sophisticated
    final str = expr.toString();

    // No trig, exp, or log functions
    if (str.contains('sin') ||
        str.contains('cos') ||
        str.contains('exp') ||
        str.contains('ln')) {
      return false;
    }

    return true;
  }

  /// Solve polynomial equations using existing polynomial solver
  static List<Expression> _solvePolynomial(Expression expr, Variable v) {
    try {
      // Simplify and evaluate coefficients
      final simplified = expr.simplify();

      // Handle x² = c form
      if (_isSquareEqualsConstant(simplified, v)) {
        return _solveSquareEqualsConstant(simplified, v);
      }

      // General Quadratic: ax^2 + bx + c = 0
      // We need to extract coefficients.
      // This is a basic implementation assuming standard form.
      // A robust implementation would use a Polynomial class to collect terms.

      num a = 0;
      num b = 0;
      num c = 0;

      // Helper to add term
      void addTerm(Expression term, num sign) {
        if (term is Literal) {
          c += (term.value as num) * sign;
        } else if (term is Variable &&
            term.identifier.name == v.identifier.name) {
          b += 1 * sign;
        } else if (term is Multiply) {
          // Check for coeff * x or x * coeff
          if (term.left is Literal &&
              term.right is Variable &&
              (term.right as Variable).identifier.name == v.identifier.name) {
            b += ((term.left as Literal).value as num) * sign;
          } else if (term.right is Literal &&
              term.left is Variable &&
              (term.left as Variable).identifier.name == v.identifier.name) {
            b += ((term.right as Literal).value as num) * sign;
          }
          // Check for coeff * x^2
          else if (term.left is Literal && term.right is Pow) {
            final pow = term.right as Pow;
            if (pow.base is Variable &&
                (pow.base as Variable).identifier.name == v.identifier.name &&
                pow.exponent is Literal &&
                (pow.exponent as Literal).value == 2) {
              a += ((term.left as Literal).value as num) * sign;
            }
          }
        } else if (term is Pow) {
          if (term.base is Variable &&
              (term.base as Variable).identifier.name == v.identifier.name &&
              term.exponent is Literal &&
              (term.exponent as Literal).value == 2) {
            a += 1 * sign;
          }
        }
        // Recurse for Add/Subtract
        else if (term is Add) {
          addTerm(term.left, sign);
          addTerm(term.right, sign);
        } else if (term is Subtract) {
          addTerm(term.left, sign);
          addTerm(term.right, -sign);
        }
      }

      addTerm(simplified, 1);

      if (a != 0) {
        // Quadratic formula: (-b ± sqrt(b^2 - 4ac)) / 2a
        final discriminant = b * b - 4 * a * c;
        if (discriminant < 0) return []; // No real solutions

        final sqrtD = sqrt(discriminant.toDouble());
        final x1 = (-b + sqrtD) / (2 * a);
        final x2 = (-b - sqrtD) / (2 * a);

        if (x1 == x2) return [Literal(x1)];
        return [Literal(x1), Literal(x2)];
      }

      // For more complex polynomials, would need coefficient extraction
      // This is simplified - full implementation would parse coefficients
      // throw UnimplementedError('Complex polynomial solving pending');
      // Fall back to isolation if not quadratic (or linear handled by isolation)
      return _solveByIsolation(simplified, v);
    } catch (e) {
      // Fall back to isolation
      return _solveByIsolation(expr, v);
    }
  }

  static bool _isSquareEqualsConstant(Expression expr, Variable v) {
    // Check for x² - c = 0 or similar forms
    if (expr is Subtract) {
      final left = expr.left;
      final right = expr.right;

      // Check if left is x²
      if (left is Pow) {
        if (left.base is Variable && left.exponent is Literal) {
          final baseVar = left.base as Variable;
          final exp = (left.exponent as Literal).value;
          if (baseVar.identifier.name == v.identifier.name && exp == 2) {
            // Right should be a literal (constant)
            return right is Literal;
          }
        }
      }
    }
    // Also handle x^2 + (-c) = 0 which is Add(Pow, Literal(-c))
    if (expr is Add) {
      final left = expr.left;
      final right = expr.right;
      if (left is Pow && right is Literal) {
        if (left.base is Variable && left.exponent is Literal) {
          if ((left.base as Variable).identifier.name == v.identifier.name &&
              (left.exponent as Literal).value == 2) {
            return true;
          }
        }
      }
    }
    return false;
  }

  static List<Expression> _solveSquareEqualsConstant(
      Expression expr, Variable v) {
    // Solve x² - c = 0 → x² = c → x = ±√c
    num c;
    if (expr is Subtract) {
      c = (expr.right as Literal).value as num;
    } else if (expr is Add) {
      // x^2 + k = 0 -> x^2 = -k
      c = -((expr.right as Literal).value as num);
    } else {
      return [];
    }

    if (c < 0) return []; // No real solutions for x² = negative number
    if (c == 0) return [Literal(0)]; // x² = 0 → x = 0

    // x² = c → x = ±√c
    final sqrtVal = sqrt(c.abs().toDouble());
    return [Literal(sqrtVal), Literal(-sqrtVal)];
  }

  /// Solve by variable isolation
  static List<Expression> _solveByIsolation(Expression equation, Variable v) {
    // Handle factors: A * B = 0 => A = 0 OR B = 0
    if (equation is Multiply) {
      List<Expression> solutions = [];
      solutions.addAll(_solveByIsolation(equation.left, v));
      solutions.addAll(_solveByIsolation(equation.right, v));
      return solutions;
    }

    // Handle powers: A^n = 0 => A = 0 (if n > 0)
    if (equation is Pow) {
      if (equation.exponent is Literal &&
          (equation.exponent as Literal).value > 0) {
        return _solveByIsolation(equation.base, v);
      }
    }

    final isolated = _isolateVariable(equation, v);
    return [isolated.simplify()]; // Simplify result
  }

  /// Isolate variable using algebraic manipulation
  /// Solves: equation = 0 for v
  static Expression _isolateVariable(Expression equation, Variable v) {
    // Strategy: Move all v terms to one side, constants to other

    // For linear equations like: ax + b = c
    // Rearrange to: ax = c - b
    // Then: x = (c - b) / a

    final result = _isolateLinear(equation, v);
    if (result != null) return result;

    throw UnimplementedError(
        'Cannot isolate variable in: ${equation.toString()}');
  }

  /// Isolate variable in linear equations
  static Expression? _isolateLinear(Expression expr, Variable v) {
    return _solveFor(expr, v, Literal(0));
  }

  /// Helper to solve expr = target for v
  static Expression? _solveFor(Expression expr, Variable v, Expression target) {
    // Base case: expr is x
    if (expr is Variable && expr.identifier.name == v.identifier.name) {
      return target;
    }

    // Handle identity: 0 = 0 (or constant = constant)
    if (expr is Literal && target is Literal) {
      if (expr.value == target.value) {
        // Identity, return 0 as representative solution
        return Literal(0);
      }
    }

    // Handle Add: A + B = target
    if (expr is Add) {
      if (_containsVariable(expr.left, v) &&
          !_containsVariable(expr.right, v)) {
        // A = target - B
        return _solveFor(expr.left, v, Subtract(target, expr.right));
      } else if (_containsVariable(expr.right, v) &&
          !_containsVariable(expr.left, v)) {
        // B = target - A
        return _solveFor(expr.right, v, Subtract(target, expr.left));
      }
    }

    // Handle Subtract: A - B = target
    if (expr is Subtract) {
      // Check for cancellation: x - x = 0
      if (expr.left.toString() == expr.right.toString()) {
        // 0 = target
        return _solveFor(Literal(0), v, target);
      }

      if (_containsVariable(expr.left, v) &&
          !_containsVariable(expr.right, v)) {
        // A = target + B
        return _solveFor(expr.left, v, Add(target, expr.right));
      } else if (_containsVariable(expr.right, v) &&
          !_containsVariable(expr.left, v)) {
        // -B = target - A => B = A - target
        return _solveFor(expr.right, v, Subtract(expr.left, target));
      }
    }

    // Handle Multiply: A * B = target
    if (expr is Multiply) {
      if (_containsVariable(expr.left, v) &&
          !_containsVariable(expr.right, v)) {
        // A = target / B
        return _solveFor(expr.left, v, Divide(target, expr.right));
      } else if (_containsVariable(expr.right, v) &&
          !_containsVariable(expr.left, v)) {
        // B = target / A
        return _solveFor(expr.right, v, Divide(target, expr.left));
      }
    }

    // Handle Divide: A / B = target
    if (expr is Divide) {
      if (_containsVariable(expr.left, v) &&
          !_containsVariable(expr.right, v)) {
        // A = target * B
        return _solveFor(expr.left, v, Multiply(target, expr.right));
      } else if (_containsVariable(expr.right, v) &&
          !_containsVariable(expr.left, v)) {
        // B = A / target
        return _solveFor(expr.right, v, Divide(expr.left, target));
      }
    }

    // Handle Unary Minus: -A = target
    if (expr is UnaryExpression && expr.operator == '-') {
      // A = -target
      return _solveFor(expr.operand, v, Multiply(Literal(-1), target));
    }

    return null;
  }

  static bool _containsVariable(Expression expr, Variable v) {
    if (expr is Variable) {
      return expr.identifier.name == v.identifier.name;
    }
    // Recursive check for other types
    if (expr is BinaryOperationsExpression) {
      return _containsVariable(expr.left, v) ||
          _containsVariable(expr.right, v);
    }
    if (expr is UnaryExpression) {
      return _containsVariable(expr.operand, v);
    }
    if (expr is CallExpression) {
      return expr.arguments.any((arg) => _containsVariable(arg, v));
    }
    return false;
  }
}
