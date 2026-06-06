import 'package:advance_math/advance_math.dart';

Expression polyFactorToExpr(Polynomial p, Variable xVar) {
  Expression? res;
  for (int i = 0; i < p.coefficients.length; i++) {
    var coeff = p.coefficients[i];
    int deg = p.degree - i;

    dynamic cv = coeff is Literal ? coeff.value : null;
    print('  i=$i deg=$deg coeff=$coeff cv=$cv (${cv?.runtimeType})');

    if (cv is Complex && cv.imaginary == 0) {
      final r = cv.real;
      print('    r=$r (${r.runtimeType})');
      if (r is Rational && r.isInteger) {
        cv = r.numerator.toInt();
        coeff = Literal(cv);
      } else if (r is num) {
        cv = r.toInt() == r ? r.toInt() : r;
        if (cv is int && cv == 0) cv = 0;
        coeff = Literal(cv);
      }
      print('    normalized cv=$cv (${cv?.runtimeType})');
    }

    bool isZero = cv == 0 ||
        cv == 0.0 ||
        (cv is Rational && cv == Rational.zero) ||
        (cv is Complex && cv == Complex.zero());
    print('    isZero=$isZero');
    if (isZero) continue;

    bool isOne = cv == 1 || cv == 1.0 ||
        (cv is Rational && cv == Rational.one) ||
        (cv is Complex && cv == Complex.one());
    print('    isOne=$isOne');

    Expression term;
    if (deg == 0) {
      term = coeff;
    } else if (deg == 1) {
      term = isOne ? xVar : Multiply(coeff, xVar);
    } else {
      term = isOne
          ? Pow(xVar, Literal(deg))
          : Multiply(coeff, Pow(xVar, Literal(deg)));
    }
    print('    term=$term');
    res = res == null ? term : Add(res, term);
  }
  return res ?? Literal(0);
}

void main() {
  var xVar = Variable(Identifier('x'));
  var denPoly = Polynomial.fromString('x^2+x');
  var factors = denPoly.factorize();

  print('Factor 0: ${factors[0]}');
  print('Coefficients 0: ${(factors[0] as Polynomial).coefficients}');
  print('Calling polyFactorToExpr on factor 0:');
  var e0 = polyFactorToExpr(factors[0] as Polynomial, xVar);
  print('Result 0: $e0');

  print('\nFactor 1: ${factors[1]}');
  print('Coefficients 1: ${(factors[1] as Polynomial).coefficients}');
  print('Calling polyFactorToExpr on factor 1:');
  var e1 = polyFactorToExpr(factors[1] as Polynomial, xVar);
  print('Result 1: $e1');
}
