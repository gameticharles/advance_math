import 'package:advance_math/advance_math.dart';

void main() {
  // Trace the full algorithm for partfrac((3*x+2)/(x^2+x), x)
  var xVar = Variable(Identifier('x'));
  var denStr = 'x^2+x';
  var numStr = '3*x+2';

  var denPoly = Polynomial.fromString(denStr);
  var numPoly = Polynomial.fromString(numStr);
  print('numPoly: $numPoly (degree ${numPoly.degree})');
  print('denPoly: $denPoly (degree ${denPoly.degree})');

  var factors = denPoly.factorize();
  print('Factors:');
  for (var f in factors) {
    print('  $f (${f.runtimeType})');
  }

  // Collect factor multiplicities
  Map<String, int> factorMult = {};
  Map<String, Expression> factorExpr = {};
  for (var f in factors) {
    Expression base = f;
    int exp = 1;
    if (f is Pow) {
      base = (f as Pow).left;
      if ((f as Pow).right is Literal) {
        var ev = ((f as Pow).right as Literal).value;
        if (ev is int) exp = ev;
        else if (ev is double) exp = ev.toInt();
      }
    }
    var key = base.toString();
    factorMult[key] = (factorMult[key] ?? 0) + exp;
    factorExpr[key] = base;
  }

  print('\nFactor keys:');
  factorMult.forEach((k, v) => print('  "$k" x$v'));

  // For each factor, try to compute cofactor
  print('\nCofactors:');
  for (var entry in factorMult.entries) {
    var fKey = entry.key;
    var n = entry.value;
    var fBase = factorExpr[fKey]!;
    for (int k = 1; k <= n; k++) {
      try {
        var fPoly2 = Polynomial.fromString(fBase.toString(), variable: xVar);
        print('  Parsed "$fKey" as poly: $fPoly2');
        Polynomial fpow = fPoly2;
        for (int pp = 1; pp < k; pp++) {
          fpow = (fpow * fPoly2) as Polynomial;
        }
        print('  factor^$k = $fpow');
        var divRes = denPoly / fpow;
        print('  denPoly / factor^$k = $divRes (${divRes.runtimeType})');
      } catch (e) {
        print('  Error for "$fKey"^$k: $e');
      }
    }
  }
}
