import 'package:advance_math/advance_math.dart';

class TermCoeff {
  final Expression coefficient;
  final int degree;
  TermCoeff(this.coefficient, this.degree);
}

TermCoeff? parsePolynomialTerm(Expression t, String varName) {
  if (t is UnaryExpression && t.operator == '-') {
    var inner = parsePolynomialTerm(t.operand, varName);
    if (inner == null) return null;
    return TermCoeff(
        Multiply(Literal(-1), inner.coefficient).simplify(), inner.degree);
  }
  if (t is GroupExpression) {
    return parsePolynomialTerm(t.expression, varName);
  }
  if (!t
      .getVariableTerms()
      .any((varTerm) => varTerm.identifier.name == varName)) {
    return TermCoeff(t, 0);
  }
  if (t is Variable && t.identifier.name == varName) {
    return TermCoeff(Literal(1), 1);
  }
  if (t is Pow) {
    if (t.base is Variable && (t.base as Variable).identifier.name == varName) {
      if (t.exponent is Literal) {
        var val = (t.exponent as Literal).value;
        double expDouble = -1.0;
        if (val is num) expDouble = val.toDouble();
        if (val is Complex && val.isReal) {
          var r = val.real;
          if (r is num) expDouble = r.toDouble();
          if (r is Rational) expDouble = r.toDouble();
        }
        if (val is Rational) expDouble = val.toDouble();

        if (expDouble >= 0 && expDouble == expDouble.toInt()) {
          return TermCoeff(Literal(1), expDouble.toInt());
        }
      }
    }
  }
  if (t is Multiply) {
    var leftHasVar = t.left
        .getVariableTerms()
        .any((varTerm) => varTerm.identifier.name == varName);
    var rightHasVar = t.right
        .getVariableTerms()
        .any((varTerm) => varTerm.identifier.name == varName);
    if (leftHasVar && !rightHasVar) {
      var varTerm = parsePolynomialTerm(t.left, varName);
      if (varTerm == null) return null;
      return TermCoeff(
          Multiply(t.right, varTerm.coefficient).simplify(), varTerm.degree);
    } else if (!leftHasVar && rightHasVar) {
      var varTerm = parsePolynomialTerm(t.right, varName);
      if (varTerm == null) return null;
      return TermCoeff(
          Multiply(t.left, varTerm.coefficient).simplify(), varTerm.degree);
    } else {
      var leftTerm = parsePolynomialTerm(t.left, varName);
      var rightTerm = parsePolynomialTerm(t.right, varName);
      if (leftTerm == null || rightTerm == null) return null;
      return TermCoeff(
        Multiply(leftTerm.coefficient, rightTerm.coefficient).simplify(),
        leftTerm.degree + rightTerm.degree,
      );
    }
  }
  if (t is Divide) {
    var denHasVar = t.right
        .getVariableTerms()
        .any((varTerm) => varTerm.identifier.name == varName);
    if (!denHasVar) {
      var numTerm = parsePolynomialTerm(t.left, varName);
      if (numTerm == null) return null;
      return TermCoeff(
          Divide(numTerm.coefficient, t.right).simplify(), numTerm.degree);
    }
  }
  return null;
}

void main() {
  var given = '(93222358/131836323)*(-2*y+549964829/38888386)=10';
  var equation = Expression.parse(given);
  var v = Variable('y');

  // Replicate ExpressionSolver.solve logic with debug prints
  Expression simplifiedEq = equation.simplify();
  print('Step 1: simplifiedEq = $simplifiedEq');

  List<dynamic> solutions = [];
  try {
    Expression normalized = _normalizeForPoly(simplifiedEq);
    print('Step 2: normalized = $normalized');
    Expression simplified = normalized.expand().simplify();
    print('Step 3: simplified = $simplified');

    List<Expression> collectSumTerms(Expression e) {
      if (e is Add) {
        return [...collectSumTerms(e.left), ...collectSumTerms(e.right)];
      }
      if (e is Subtract) {
        return [
          ...collectSumTerms(e.left),
          ...collectSumTerms(Multiply(Literal(-1), e.right))
        ];
      }
      if (e is GroupExpression) {
        return collectSumTerms(e.expression);
      }
      return [e];
    }

    var sumTerms = collectSumTerms(simplified);
    Map<int, Expression> degreeCoeffs = {};
    var varName = 'y';
    for (var term in sumTerms) {
      var parsedTerm = parsePolynomialTerm(term, varName);
      if (parsedTerm != null) {
        var deg = parsedTerm.degree;
        var coeff = parsedTerm.coefficient;
        if (degreeCoeffs.containsKey(deg)) {
          degreeCoeffs[deg] = Add(degreeCoeffs[deg]!, coeff).simplify();
        } else {
          degreeCoeffs[deg] = coeff;
        }
      }
    }

    int maxDegree = degreeCoeffs.keys.reduce((a, b) => a > b ? a : b);
    List<Expression> coeffList = [];
    for (int d = maxDegree; d >= 0; d--) {
      coeffList.add(degreeCoeffs[d] ?? Literal(0));
    }

    Polynomial poly = Polynomial.fromList(coeffList, variable: v);
    solutions = poly.roots();
    print('Step 4: solutions after poly.roots() = $solutions');
  } catch (e) {
    print('Error: $e');
  }

  // Post-processing
  var mappedSolutions = solutions.map((s) {
    var val = s;
    if (s is Expression) {
      try {
        final evalVal = s.evaluate();
        print(
            '    s = $s, evalVal = $evalVal, evalVal type = ${evalVal.runtimeType}');

        // Exact integer check
        bool isExact(dynamic v) {
          if (v is int) return true;
          if (v is Rational && v.isInteger) return true;
          if (v is double && v == v.toInt()) return true;
          if (v is Complex) {
            final r = v.real;
            final img = v.imaginary;
            bool exactR = r is int ||
                (r is Rational && r.isInteger) ||
                (r is double && r == r.toInt());
            bool exactI = img is int ||
                (img is Rational && img.isInteger) ||
                (img is double && img == img.toInt());
            return exactR && exactI;
          }
          return false;
        }

        if (isExact(evalVal)) {
          val = evalVal;
        } else {
          val = evalVal;
        }
      } catch (e) {
        val = s;
      }
    }

    if (val is Complex) {
      final img = val.imaginary;
      double imgVal = 0.0;
      if (img is num) imgVal = img.toDouble();
      if (img is Rational) imgVal = img.toDouble();
      if (imgVal.abs() < 1e-9) {
        val = val.real;
      }
    }

    if (val is Rational) {
      if (val.isInteger) {
        val = val.toInt();
      }
    }

    if (val is double && val.isFinite && val == val.toInt()) {
      return val.toInt();
    }
    if (val is num && val.isFinite && (val - val.round()).abs() < 1e-9) {
      return val.round();
    }
    return val;
  }).toList();

  print('Step 5: mappedSolutions = $mappedSolutions');
}

Expression _normalizeForPoly(Expression e) {
  if (e is Subtract) {
    return Add(_normalizeForPoly(e.left),
        Multiply(Literal(-1), _normalizeForPoly(e.right)));
  }
  return e;
}
