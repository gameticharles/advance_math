import 'package:advance_math/advance_math.dart';

void main() {
  var xVar = Variable(Identifier('x'));
  var denPoly = Polynomial.fromString('x^2+x');
  var factors = denPoly.factorize();
  print('Factors: $factors');

  // Test merge check
  var f0 = factors[0] as Polynomial;
  var f1 = factors[1] as Polynomial;
  print('f0: $f0, f1: $f1');

  try {
    var q = f0 / f1;
    print('f0/f1 = $q (${q.runtimeType})');
    if (q is Polynomial) print('  degree = ${q.degree}');
  } catch (e) {
    print('f0/f1 error: $e');
  }

  // Test cofactor
  var q01 = denPoly / f0;
  print('denPoly / f0 = $q01 (${q01.runtimeType})');
  var q10 = denPoly / f1;
  print('denPoly / f1 = $q10 (${q10.runtimeType})');

  // Test coefficient extraction
  if (q01 is Polynomial) {
    print('Cofactor0 (denPoly/f0) = $q01');
    print('  degree: ${q01.degree}');
    print('  coefficients: ${q01.coefficients}');
    for (var c in q01.coefficients) {
      var v = c is Literal ? c.value : null;
      print('  coeff $c (${c.runtimeType}): value=$v (${v?.runtimeType})');
      if (v is Complex) print('    real=${v.real} (${v.real.runtimeType}), imag=${v.imaginary}');
    }
  }
  if (q10 is Polynomial) {
    print('Cofactor1 (denPoly/f1) = $q10');
    print('  coefficients: ${q10.coefficients}');
    for (var c in q10.coefficients) {
      var v = c is Literal ? c.value : null;
      print('  coeff $c: value=$v (${v?.runtimeType})');
      if (v is Complex) print('    real=${v.real} (${v.real.runtimeType}), imag=${v.imaginary}');
    }
  }
}
