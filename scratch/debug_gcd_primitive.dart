import 'package:advance_math/advance_math.dart';

void main() {
  final cases = [
    ['5*x^6+5*x^5+27*x^4+27*x^3+28*x^2+28*x', '5*x^3+7*x', '5*x^3+7*x'],
    ['2*x^2+2*x+1', 'x+1', '1'],
    ['x^2+2*x+1', 'x+1', '1+x'],
    ['6*x^9+24*x^8+15*x^7+6*x^2+24*x+15', '2*x^2+8*x+5', '2*x^2+8*x+5'],
    ['x^8+4*x^7+4*x^6+3*x^5+12*x^4+12*x^3', 'x^3+3', '3+x^3'],
    ['6*x^9+24*x^8+15*x^7+6*x^2+24*x+15', 'x^7+1', '1+x^7'],
    ['1+x^2', '2*x', '1'],
    [
      '84*x^4+147*x^3+16*x^2+28*x',
      '44*x^5+77*x^4+16*x^3+28*x^2+12*x+21',
      '4*x+7'
    ],
    [
      '5*x^11+90*x^9+361*x^7+473*x^5+72*x^3+91*x',
      '7150*x^12+9360*x^10+1375*x^9+1430*x^8+37550*x^7+1872*x^6+47075*x^5+7510*x^3+9360*x',
      '5*x^5+x'
    ],
    [
      '7*x^4+7*x^3+4*x^2+5*x+1',
      '21*x^6+47*x^4+80*x^3+20*x^2+49*x+11',
      '1+4*x+7*x^3'
    ],
  ];

  for (var trio in cases) {
    try {
      var p0 = Polynomial.fromString(trio[0]);
      var p1 = Polynomial.fromString(trio[1]);
      var g = p0.gcd(p1);
      // Try to make primitive (divide by content)
      var gPrimitive = makePrimitive(g);
      print('gcd(${trio[0]}, ${trio[1]})');
      print('  raw GCD: $g');
      print('  primitive GCD: ${reconstructExpr(gPrimitive)}');
      print('  expected: ${trio[2]}');
      print('  match: ${reconstructExpr(gPrimitive) == trio[2]}');
      print('');
    } catch (e, st) {
      print('Error for ${trio[0]}: $e');
      print(st.toString().split('\n').take(3).join('\n'));
    }
  }
}

// Make polynomial primitive by dividing out the GCD of all integer coefficients
Polynomial makePrimitive(Polynomial p) {
  // Extract numeric coefficients
  var nums = <BigInt>[];
  for (var c in p.coefficients) {
    if (c is Literal) {
      var v = c.value;
      if (v is Complex && v.imaginary == 0) {
        var r = v.real;
        if (r is Rational && r.isInteger) {
          nums.add(r.numerator.abs());
        } else if (r is num && r % 1 == 0) {
          nums.add(BigInt.from(r.abs().toInt()));
        }
      } else if (v is Rational && v.isInteger) {
        nums.add(v.numerator.abs());
      } else if (v is int) {
        nums.add(BigInt.from(v.abs()));
      } else if (v is double && v % 1 == 0) {
        nums.add(BigInt.from(v.abs().toInt()));
      }
    }
  }
  if (nums.isEmpty || nums.contains(BigInt.zero)) return p;
  var g = nums.reduce((a, b) => a.gcd(b));
  if (g <= BigInt.one) return p;
  // Divide all coefficients by g
  var newCoeffs = p.coefficients.map<Expression>((c) {
    if (c is Literal) {
      var v = c.value;
      if (v is Complex && v.imaginary == 0) {
        var r = v.real;
        if (r is Rational) {
          return Literal(Rational(r.numerator ~/ g, r.denominator));
        }
        if (r is num) return Literal(r / g.toInt());
      } else if (v is Rational) {
        return Literal(Rational(v.numerator ~/ g, v.denominator));
      } else if (v is int) {
        return Literal(v ~/ g.toInt());
      } else if (v is double) {
        return Literal(v / g.toInt());
      }
    }
    return c;
  }).toList();
  return Polynomial(newCoeffs, variable: p.variable);
}

Expression reconstructExpr(Polynomial g) {
  Expression result = Literal(0);
  for (int i = 0; i < g.coefficients.length; i++) {
    var coeff = g.coefficients[i];
    int deg = g.degree - i;
    Expression term;
    if (deg == 0) {
      term = coeff;
    } else if (deg == 1) {
      term = Multiply(coeff, g.variable);
    } else {
      term = Multiply(coeff, Pow(g.variable, Literal(deg)));
    }
    if (result is Literal && (result).value == 0) {
      result = term;
    } else {
      result = Add(result, term);
    }
  }
  return result.simplify();
}
