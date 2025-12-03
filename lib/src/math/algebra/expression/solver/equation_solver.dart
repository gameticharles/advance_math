part of '../expression.dart';

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
  static List<dynamic> solve(Expression equation, Variable v) {
    List<dynamic> solutions;

    // 0. Handle factored forms: A * B = 0 => A = 0 OR B = 0
    // We check this BEFORE polynomial expansion to avoid unnecessary complexity
    if (equation is Multiply) {
      // print('DEBUG solve: Found factored form, solving factors recursively');
      var leftSols = solve(equation.left, v);
      var rightSols = solve(equation.right, v);
      solutions = [...leftSols, ...rightSols];
    } else {
      // 1. Check if it's a polynomial equation
      bool isPoly = _isPolynomialEquation(equation, v);
      // print('DEBUG solve: _isPolynomialEquation returned $isPoly for ${equation.toString()}');
      if (isPoly) {
        try {
          String exprStr = equation.expand().simplify().toString();
          // print('DEBUG solve: calling Polynomial.fromString with: $exprStr');
          Polynomial poly = Polynomial.fromString(exprStr, variable: v);
          if (poly.degree == 0 && _containsVariable(equation, v)) {
            // If polynomial thinks it's constant but equation has variable,
            // something went wrong (e.g. bad simplification or parsing).
            // Fallback to isolation.
            throw Exception('Polynomial degree 0 but variable present');
          }
          solutions =
              poly.roots().map((c) => (c is Complex) ? c.real : c).toList();
          // print('DEBUG solve: polynomial roots = $solutions');
        } catch (e) {
          // print('DEBUG solve: polynomial path failed with $e, using isolation');
          solutions = _solveByIsolation(equation, v);
        }
      } else {
        solutions = _solveByIsolation(equation, v);
      }
    }

    // Convert integer doubles to ints and unwrap Literals/Expressions
    return solutions.map((s) {
      var val = s;
      if (s is Expression) {
        try {
          val = s.evaluate();
        } catch (e) {
          // keep as expression
        }
      }
      if (val is double && val == val.toInt()) return val.toInt();
      return val;
    }).toList();
  }

  /// Check if equation can be solved as polynomial
  static bool _isPolynomialEquation(Expression expr, Variable v) {
    try {
      // Expand first to handle factored forms like (x-1)*(x-2)
      // And simplify to combine terms
      Expression expanded = expr.expand().simplify();

      String exprStr = expanded.toString();
      // Clean up string for check
      exprStr = exprStr.replaceAll(RegExp(r'\.0(?!\d)'), '');

      return Polynomial.isPolynomial(exprStr, varName: v.identifier.name);
    } catch (e) {
      // print('DEBUG _isPolynomialEquation: caught exception $e');
      return false;
    }
  }

  /// Solve by variable isolation
  static List<Expression> _solveByIsolation(Expression equation, Variable v) {
    // Unwrap GroupExpression
    while (equation is GroupExpression) {
      equation = equation.expression;
    }
    // Simplify first? No, full simplify might evaluate variables if context is weird.
    // equation = equation.simplify();

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

  /// Solve a system of equations
  static List<String> solveEquations(List<Expression> equations,
      [List<Variable>? variables]) {
    // Extract variables if not provided
    final vars = variables ?? _extractVariables(equations);
    if (vars.isEmpty) {
      // print('DEBUG: solveEquations vars is empty');
      return [];
    }
    // print('DEBUG: solveEquations vars: $vars (type: ${vars.runtimeType})');
    // print('DEBUG: solveEquations calling _solveSystemRecursive');
    // print('DEBUG: solveEquations equations: $equations');

    // Use substitution method
    final solution = _solveSystemRecursive(equations, vars);
    if (solution == null) {
      // print('DEBUG: solveEquations failed to find solution');
      return [];
    }

    // Format output as flat list: var, val, var, val
    List<String> result = [];

    // Sort variables alphabetically for consistent output
    final sortedVars = solution.keys.toList()
      ..sort((a, b) => a.identifier.name.compareTo(b.identifier.name));

    for (var v in sortedVars) {
      result.add(v.identifier.name);
      var expr = solution[v]!;
      // Handle -0.0
      if (expr is Literal && expr.value == 0) {
        result.add('0');
      } else {
        // Try to evaluate to number
        try {
          var val = expr.evaluate();
          if (val is double && val == val.toInt()) {
            result.add(val.toInt().toString());
          } else {
            result.add(val.toString());
          }
        } catch (e) {
          result.add(expr.toString());
        }
      }
    }
    return result;
  }

  static List<Variable> _extractVariables(List<Expression> equations) {
    final vars = <Variable>{};
    for (var eq in equations) {
      vars.addAll(eq.getVariableTerms());
    }
    return vars.toList();
  }

  static Map<Variable, Expression>? _solveSystemRecursive(
      List<Expression> equations, List<Variable> variables) {
    // print('DEBUG: _solveSystemRecursive eqs: $equations vars: $variables');
    if (equations.isEmpty) {
      return {};
    }

    // Try to isolate a variable in one of the equations
    for (int i = 0; i < equations.length; i++) {
      final eq = equations[i];
      for (int j = 0; j < variables.length; j++) {
        final v = variables[j];
        try {
          // Attempt to isolate v
          // We use _isolateVariable which assumes eq = 0
          // It returns v = isolated_expr
          final isolated = _isolateVariable(eq, v);
          // print('DEBUG: Isolated $v in $eq -> $isolated');

          // If successful, we have v = isolated
          // Substitute v in remaining equations
          final remainingEqs = <Expression>[];
          for (int k = 0; k < equations.length; k++) {
            if (k == i) continue;
            remainingEqs.add(equations[k].substitute(v, isolated).simplify());
          }

          final remainingVars = List<Variable>.from(variables)..removeAt(j);

          // Recursively solve
          final subSolution =
              _solveSystemRecursive(remainingEqs, remainingVars);

          if (subSolution != null) {
            // Back-substitute
            // v = isolated.substitute(subSolution)
            var val = isolated;
            subSolution.forEach((sv, sexpr) {
              val = val.substitute(sv, sexpr);
            });
            val = val.simplify();

            subSolution[v] = val;
            return subSolution;
          }
        } catch (e) {
          // Cannot isolate this variable in this equation, try next
          // print('DEBUG: Failed to isolate $v in $eq: $e');
          continue;
        }
      }
    }

    return null; // Failed to solve
  }
}
