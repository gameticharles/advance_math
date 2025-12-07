import 'package:test/test.dart';
import 'package:advance_math/src/number/complex/complex.dart';
import 'package:advance_math/advance_math.dart' as math;

/// Class to test extending Complex
class TestComplex extends Complex {
  TestComplex(num super.real, num super.imaginary);

  factory TestComplex.from(Complex other) {
    return TestComplex(other.real, other.imaginary);
  }

  @override
  String toString({bool asFraction = false, int? fractionDigits}) {
    return '$real ${imaginary}j';
  }
}

/// Returns a matcher which matches if the match argument is within [delta]
/// of some [value]; i.e. if the match argument is greater than
/// than or equal [value]-[delta] and less than or equal to [value]+[delta].
Matcher closeToZ(Complex value, num delta) => _IsCloseToZ(value, delta);

class _IsCloseToZ extends Matcher {
  const _IsCloseToZ(this._value, this._delta);

  final Complex _value;
  final num _delta;

  @override
  bool matches(item, Map matchState) {
    if (item is! Complex) {
      return false;
    }
    var reDiff = item.real - _value.real;
    if (reDiff < 0) reDiff = -reDiff;
    if (reDiff > _delta) {
      return false;
    }
    var imDiff = item.imaginary - _value.imaginary;
    if (imDiff < 0) imDiff = -imDiff;
    if (imDiff > _delta) {
      return false;
    }
    return true;
  }

  @override
  Description describe(Description description) => description
      .add('a complex value within ')
      .addDescriptionOf(_delta)
      .add(' of ')
      .addDescriptionOf(_value);

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Complex) {
      return mismatchDescription.add(' not complex');
    } else {
      var diff = item.abs() - _value.abs();
      if (diff < 0) diff = -diff;
      return mismatchDescription.add(' differs by ').addDescriptionOf(diff);
    }
  }
}

void main() {
  group('Complex Number Tests', () {
    group('Special Values and Constants', () {
      var inf = double.infinity;
      var neginf = double.negativeInfinity;
      var nan = double.nan;

      test('Special Value Constructions', () {
        expect(Complex(1, inf).toString(), '1 + Infinityi');
        expect(Complex(inf, 1).toString(), 'Infinity + i');
        expect(Complex(inf, inf).toString(), 'Infinity + Infinityi');
        expect(Complex(neginf, inf).toString(), '-Infinity + Infinityi');
        expect(Complex(nan, inf).toString(), 'NaN + Infinityi');
        expect(Complex(1, nan).toString(), '1 + NaNi');
        expect(Complex(0, inf).toString(), 'Infinityi');
        expect(Complex(0, nan).toString(), 'NaNi');
      });

      test('Special Value Operations', () {
        final infInf = Complex(inf, inf);
        final oneInf = Complex(1, inf);
        final zeroInf = Complex(0, inf);

        expect((infInf + oneInf).toString(), 'Infinity + Infinityi');
        expect((infInf * oneInf).toString(), 'Infinity + Infinityi');
        expect(Complex.zero() / Complex.zero(), isA<Complex>());
        expect((oneInf / zeroInf).toString(), 'NaN + NaNi');
        expect(Complex(nan, 0).value, Complex.nan());
        expect(Complex(inf, 0).value, inf);
        expect(Complex(neginf, 0).value, neginf);
      });
    });

    group('Basic Operations', () {
      test('Addition', () {
        final a = Complex(3, 4);
        final b = Complex(1, 2);
        expect((a + b).toString(), '4 + 6i');
        expect((a + 5).toString(), '8 + 4i');
      });

      test('Subtraction', () {
        final a = Complex(3, 4);
        final b = Complex(1, 2);
        expect((b - a).toString(), '-2 - 2i');
      });

      test('Multiplication', () {
        final a = Complex(3, 4);
        final b = Complex(1, 2);
        expect((a * b).toString(), '-5 + 10i');
      });

      test('Division', () {
        final a = Complex(3, 4);
        final b = Complex(1, 2);
        expect((b / a).toString(), '0.44 + 0.08i');
      });

      test('Reciprocal', () {
        final a = Complex(3, 4);
        expect(~a, isA<Complex>());
      });
    });

    group('String Parsing', () {
      test('Basic Format', () {
        expect(Complex('3+4i').toString(), '3 + 4i');
        expect(Complex('1-i').toString(), '1 - i');
        expect(Complex('5').toString(), '5');
        expect(Complex('-2.5', '3.7').toString(), '-2.5 + 3.7i');
        expect(Complex('i').toString(), 'i');
        expect(Complex('-i').toString(), '-i');
        expect(Complex('0.5i').toString(), '0.5i');
        expect(Complex('-0.5i').toString(), '-0.5i');
      });

      test('Fractional Format', () {
        expect(Complex('3/2+5/4i').toString(), '1.5 + 1.25i');
        expect(Complex.parse('3/4+5/2i').toString(), '0.75 + 2.5i');
      });

      test('Mathematical Constants', () {
        expect(Complex('-√3+2πi').toString(),
            '${-math.sqrt(3)} + ${2 * math.pi}i');
        expect(Complex.parse('π+ei').toString(), '${math.pi} + ${math.e}i');
        expect(Complex.parse('√2-i').toString(), '${math.sqrt(2)} - i');
      });

      test('Scientific Notation', () {
        expect(Complex.parse('1e3 + 2.5e-2i').toString(), '1000 + 0.025i');
        expect(Complex('1.2e3+3.4e-5i').toString(), '1200 + 0.000034i');
        expect(Complex.parse('2.5e3+4.2e-2i').toString(), '2500 + 0.042i');
      });
    });

    group('Complex Constructor Combinations', () {
      test('Complex with Complex Arguments', () {
        expect(Complex(Complex(5, -1), Complex(2, 2)).toString(), '3 + i');
        expect(Complex(Complex(2, 3), Complex(4, 5)).toString(), '-3 + 7i');
        expect(Complex(Complex(0, 1), Complex(0, 1)).toString(), '-1 + i');
        expect(Complex(Complex(3, 2), Complex(5, -4)).toString(), '7 + 7i');
        expect(Complex(Complex(3, -2), Complex(5, -4)).toString(), '7 + 3i');
      });

      test('Mixed Arguments', () {
        expect(Complex(Complex(2, 3), 4).toString(), '2 + 7i');
        expect(Complex(5, Complex(1, 2)).toString(), '3 + i');
        expect(Complex(3.14, Complex(0, 1)).toString(), '2.14');
        expect(Complex(5, '2+1i').toString(), '4 + 2i');
        expect(Complex('3+2i', '5-4i').toString(), '7 + 7i');
      });
    });

    group('Value Simplification', () {
      test('Integer Simplification', () {
        expect(Complex(5, 0).value, 5);
        expect(Complex(5.0, 0).value, 5);
        expect(Complex(-0.0, 0).value, 0);
        expect(Complex(1e-20, 0).value, 0);
      });

      test('Double Precision', () {
        expect(Complex(1.000000000000001, 0).value, 1.000000000000001);
        expect(Complex(5.5, 0).value, 5.5);
      });

      test('Large Numbers', () {
        expect(Complex(9007199254740992.0, 0).value, 9007199254740992);
        expect(Complex(9007199254740993.0, 0).value, 9007199254740993.0);
        expect(Complex(1e30, 0).value is num, true);
      });
    });

    group('String Representation', () {
      test('toString Formatting', () {
        expect(Complex(7, 0).toString(), '7');
        expect(Complex(7.0, 0).toString(), '7');
        expect(Complex(7.5, 0).toString(), '7.5');
        expect(Complex(3, 4).toString(), '3 + 4i');
        expect(Complex(2.5, 0).toString(), '2.5');
      });

      test('Fixed Precision', () {
        final c1 = Complex(3, 4);
        final c2 = Complex(2.5, 0);
        expect(c1.toStringAsFixed(1), '3.0 + 4.0i');
        expect(c2.toStringAsFixed(1), '2.5');
      });

      test('Polar Form', () {
        final c = Complex.polar(2, math.pi / 2);
        expect(c.toStringAsFixed(3), '0.000 + 2.000i');
      });
    });

    group('Properties and Methods', () {
      test('Modulus', () {
        final c = Complex(2, 5);
        expect(c.modulus, closeTo(c.complexModulus, 1.0e-9));
        expect(c.modulus, closeTo(math.sqrt(29), 1.0e-9));
        // expect(c.modulus, c.complexModulus);
        // expect(c.modulus, math.sqrt(29));
      });

      test('Value Property', () {
        expect(Complex(5.0, 0).value is int, true);
        expect(Complex(5.5, 0).value is double, true);
        expect(Complex(2, 5).value, isA<Complex>());
      });

      test('Equality', () {
        final c = Complex.fromReal(5);
        expect(c == 5, true);
        expect(Complex(3, 4) == 3, false);
      });
    });
  });

  var inf = double.infinity;
  var neginf = double.negativeInfinity;
  var nan = double.nan;
  var pi = math.pi;
  var oneInf = Complex(1, inf);
  var oneNegInf = Complex(1, neginf);
  var infOne = Complex(inf, 1);
  var infZero = Complex(inf, 0);
  var infNaN = Complex(inf, nan);
  var infNegInf = Complex(inf, neginf);
  var infInf = Complex(inf, inf);
  var negInfInf = Complex(neginf, inf);
  var negInfZero = Complex(neginf, 0);
  var negInfOne = Complex(neginf, 1);
  var negInfNaN = Complex(neginf, nan);
  var negInfNegInf = Complex(neginf, neginf);
  var oneNaN = Complex(1, nan);
  var zeroInf = Complex(0, inf);
  var zeroNaN = Complex(0, nan);
  var nanInf = Complex(nan, inf);
  var nanNegInf = Complex(nan, neginf);
  var nanZero = Complex(nan, 0);

  test('Constructor', () {
    var z = Complex(3.0, 4.0);
    expect(3.0, closeTo(z.real, 1.0e-5));
    expect(4.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('ConstructorNaN', () {
    var z1 = Complex(3.0, double.nan);
    expect(z1.isNaN, isTrue);

    var z2 = Complex(double.nan, 4.0);
    expect(z2.isNaN, isTrue);

    var z3 = Complex(3.0, 4.0);
    expect(z3.isNaN, isFalse);
  });

  test('Abs', () {
    var z = Complex(3.0, 4.0);
    expect(5.0, closeTo(z.abs(), 1.0e-5));
  });

  test('AbsNaN', () {
    expect(Complex.nan().abs().isNaN, isTrue);
    var z = Complex(inf, nan);
    expect(z.abs().isNaN, isTrue);
  });

  test('AbsInfinite', () {
    var z1 = Complex(inf, 0);
    expect(inf, equals(z1.abs()));

    var z2 = Complex(0, neginf);
    expect(inf, equals(z2.abs()));

    var z3 = Complex(inf, neginf);
    expect(inf, equals(z3.abs()));
  });

  test('Add', () {
    var x = Complex(3.0, 4.0);
    var y = Complex(5.0, 6.0);
    final z = x + y;
    expect(8.0, closeTo(z.real, 1.0e-5));
    expect(10.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('AddNaN', () {
    var x = Complex(3.0, 4.0);
    final z1 = x + Complex.nan();
    expect(Complex.nan(), equals(z1));

    var z2 = Complex(1, nan);
    final w = x + z2;
    expect(Complex.nan(), equals(w));
  });

  test('AddInf', () {
    var x = Complex(1, 1);
    var z = Complex(inf, 0);
    final w = x + z;
    expect(w.imaginary, equals(1));
    expect(inf, equals(w.real));

    var x1 = Complex(neginf, 0);
    expect((x1 + z).real.isNaN, isTrue);
  });

  test('ScalarAdd', () {
    var x = Complex(3.0, 4.0);
    var yDouble = 2.0;
    var yComplex = Complex(yDouble);
    expect(x + yComplex, equals(x + yDouble));
  });

  test('ScalarAddNaN', () {
    var x = Complex(3.0, 4.0);
    var yDouble = double.nan;
    var yComplex = Complex(yDouble);
    expect(x + yComplex, equals(x + yDouble));
  });

  test('ScalarAddInf', () {
    var x = Complex(1, 1);
    var yDouble = double.infinity;

    var yComplex = Complex(yDouble);
    expect(x + yComplex, x + yDouble);

    {
      var x = Complex(neginf, 0);
      expect(x + yComplex, x + yDouble);
    }
  });

  test('Conjugate', () {
    var x = Complex(3.0, 4.0);
    final z = x.conjugate;
    expect(3.0, closeTo(z.real, 1.0e-5));
    expect(-4.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('ConjugateNaN', () {
    final z = Complex.nan().conjugate;
    expect(z.isNaN, isTrue);
  });

  test('ConjugateInfinite', () {
    {
      var z = Complex(0, inf);
      expect(neginf, equals(z.conjugate.imaginary));
    }
    {
      var z = Complex(0, neginf);
      expect(inf, equals(z.conjugate.imaginary));
    }
  });

  test('Divide', () {
    var x = Complex(3.0, 4.0);
    var y = Complex(5.0, 6.0);
    final z = x / y;
    expect(39.0 / 61.0, closeTo(z.real, 1.0e-5));
    expect(2.0 / 61.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('DivideReal', () {
    var x = Complex(2, 3);
    var y = Complex(2, 0);
    expect(Complex(1, 1.5), equals(x / y));
  });

  test('DivideImaginary', () {
    var x = Complex(2, 3);
    var y = Complex(0, 2);
    expect(Complex(1.5, -1), equals(x / y));
  });

  test('DivideInf', () {
    var x = Complex(3, 4);

    {
      var w = Complex(neginf, inf);
      expect(x / w == Complex.zero(), isTrue);

      final z = w / x;
      expect(z.real.isNaN, isTrue);
      expect(inf, equals(z.imaginary));
    }

    {
      var w = Complex(inf, inf);
      final z = w / x;
      expect(z.imaginary.isNaN, isTrue);
      expect(inf, equals(z.real));
    }

    {
      var w = Complex(1, inf);
      final z = w / w;
      expect(z.real.isNaN, isTrue);
      expect(z.imaginary.isNaN, isTrue);
    }
  });

  test('DivideZero', () {
    var x = Complex(3.0, 4.0);
    final z = x / Complex.zero();
    // expect(z, Complex.INF); // See MATH-657
    expect(z, equals(Complex.infinity()));
  });

  test('DivideZeroZero', () {
    var x = Complex(0.0, 0.0);
    final z = x / Complex.zero();
    expect(z, equals(Complex.nan()));
  });

  test('DivideNaN', () {
    var x = Complex(3.0, 4.0);
    final z = x / Complex.nan();
    expect(z.isNaN, isTrue);
  });

  test('DivideNaNInf', () {
    {
      final z = oneInf / Complex.one();
      expect(z.real.isNaN, isTrue);
      expect(inf, equals(z.imaginary));
    }

    {
      final z = negInfNegInf / oneNaN;
      expect(z.real.isNaN, isTrue);
      expect(z.imaginary.isNaN, isTrue);
    }

    {
      final z = negInfInf / Complex.one();
      expect(z.real.isNaN, isTrue);
      expect(z.imaginary.isNaN, isTrue);
    }
  });

  test('ScalarDivide', () {
    var x = Complex(3.0, 4.0);
    var yDouble = 2.0;
    var yComplex = Complex(yDouble);
    expect(x / yComplex, equals(x / yDouble));
  });

  test('ScalarDivideNaN', () {
    var x = Complex(3.0, 4.0);
    var yDouble = double.nan;
    var yComplex = Complex(yDouble);
    expect(x / yComplex, equals(x / yDouble));
  });

  test('ScalarDivideInf', () {
    var x = Complex(1, 1);

    {
      var yDouble = double.infinity;
      var yComplex = Complex(yDouble);
      expect(x / yComplex, equals(x / yDouble));
    }

    {
      var yDouble = double.negativeInfinity;
      var yComplex = Complex(yDouble);
      expect(x / yComplex, equals(x / yDouble));
    }

    {
      var x = Complex(1, double.negativeInfinity);
      var yDouble = double.negativeInfinity;
      var yComplex = Complex(yDouble);
      expect(x / yComplex, equals(x / yDouble));
    }
  });

  test('ScalarDivideZero', () {
    var x = Complex(1, 1);
    expect(x / Complex.zero(), equals(x / 0));
  });

  test('Reciprocal', () {
    var z = Complex(5.0, 6.0);
    final act = z.reciprocal;
    var expRe = 5.0 / 61.0;
    var expIm = -6.0 / 61.0;
    expect(expRe, closeTo(act.real, /*FastMath.ulp(expRe)*/ 1.0e-12));
    expect(expIm, closeTo(act.imaginary, /*FastMath.ulp(expIm)*/ 1.0e-12));
  });

  test('ReciprocalReal', () {
    var z = Complex(-2.0, 0.0);
    //expect(Complex.equals(Complex(-0.5, 0.0), z.reciprocal()), isTrue);
    expect(Complex(-0.5, 0.0), equals(z.reciprocal));
  });

  test('ReciprocalImaginary', () {
    var z = Complex(0.0, -2.0);
    expect(Complex(0.0, 0.5), equals(z.reciprocal));
  });

  test('ReciprocalInf', () {
    {
      var z = Complex(neginf, inf);
      expect(z.reciprocal == Complex.zero(), isTrue);
    }

    {
      final z = Complex(1, inf).reciprocal;
      expect(z, equals(Complex.zero()));
    }
  });

  test('ReciprocalZero', () {
    expect(Complex.zero().reciprocal, equals(Complex.infinity()));
  });

  test('ReciprocalNaN', () {
    expect(Complex.nan().reciprocal.isNaN, isTrue);
  });

  test('Multiply', () {
    var x = Complex(3.0, 4.0);
    var y = Complex(5.0, 6.0);
    final z = x * y;
    expect(-9.0, closeTo(z.real, 1.0e-5));
    expect(38.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('MultiplyNaN', () {
    var x = Complex(3.0, 4.0);
    {
      final z = x * Complex.nan();
      expect(Complex.nan(), equals(z));
    }
    {
      final z = Complex.nan() * 5;
      expect(Complex.nan(), equals(z));
    }
  });

  test('MultiplyInfInf', () {
    // expect(infInf.multiply(infInf).isNaN()); // MATH-620
    expect((infInf * infInf).isInfinite, isTrue);
  });

  test('MultiplyNaNInf', () {
    {
      var z = Complex(1, 1);
      final w = z * infOne;
      expect(w.real, equals(inf));
      expect(w.imaginary, equals(inf));
    }

    // [MATH-164]
    expect(Complex(1, 0) * infInf == Complex.infinity(), isTrue);
    expect(
        (Complex(-1, 0) * infInf) == Complex.infinity(), isFalse); // -Infinity
    expect(Complex(1, 0) * negInfZero == Complex.infinity(), isFalse);

    {
      final w = oneInf * oneNegInf;
      expect(w.real, equals(inf));
      expect(w.imaginary, equals(inf));
    }

    {
      final w = negInfNegInf * oneNaN;
      expect(w.real.isNaN, isTrue);
      expect(w.imaginary.isNaN, isTrue);
    }

    {
      var z = Complex(1, neginf);
      expect(Complex.infinity(), equals(z * z));
    }
  });

  test('ScalarMultiply', () {
    var x = Complex(3.0, 4.0);
    var yDouble = 2.0;
    var yComplex = Complex(yDouble);
    expect(x * yComplex, equals(x * yDouble));
    var zInt = -5;
    final zComplex = Complex(zInt.toDouble());
    expect(x * zComplex, equals(x * zInt));
  });

  test('ScalarMultiplyNaN', () {
    var x = Complex(3.0, 4.0);
    var yDouble = double.nan;
    var yComplex = Complex(yDouble);
    expect(x * yComplex, equals(x * yDouble));
  });

  test('ScalarMultiplyInf', () {
    var x = Complex(1, 1);
    {
      var yDouble = double.infinity;
      var yComplex = Complex(yDouble);
      expect(x * yComplex, equals(x * yDouble));
    }

    {
      var yDouble = double.negativeInfinity;
      var yComplex = Complex(yDouble);
      expect(x * yComplex, equals(x * yDouble));
    }
  });

  test('Negate', () {
    var x = Complex(3.0, 4.0);
    final z = -x;
    expect(-3.0, closeTo(z.real, 1.0e-5));
    expect(-4.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('NegateNaN', () {
    Complex z = -Complex.nan();
    expect(z.isNaN, isTrue);
  });

  test('Subtract', () {
    var x = Complex(3.0, 4.0);
    var y = Complex(5.0, 6.0);
    final z = x - y;
    expect(-2.0, closeTo(z.real, 1.0e-5));
    expect(-2.0, closeTo(z.imaginary, 1.0e-5));
  });

  test('SubtractNaN', () {
    var x = Complex(3.0, 4.0);
    {
      final z = x - Complex.nan();
      expect(Complex.nan(), equals(z));
    }

    {
      var z = Complex(1, nan);
      final w = x - z;
      expect(Complex.nan(), equals(w));
    }
  });

  test('SubtractInf', () {
    var z = Complex(neginf, 0);
    {
      var x = Complex(1, 1);

      final w = x - z;
      expect(w.imaginary, equals(1));
      expect(inf, equals(w.real));
    }

    {
      var x = Complex(neginf, 0);
      expect((x - z).real.isNaN, isTrue);
    }
  });

  test('ScalarSubtract', () {
    var x = Complex(3.0, 4.0);
    var yDouble = 2.0;
    var yComplex = Complex(yDouble);
    expect(x - yComplex, equals(x - yDouble));
  });

  test('ScalarSubtractNaN', () {
    var x = Complex(3.0, 4.0);
    var yDouble = double.nan;
    var yComplex = Complex(yDouble);
    expect(x - yComplex, equals(x - yDouble));
  });

  test('ScalarSubtractInf', () {
    var yDouble = double.infinity;
    var yComplex = Complex(yDouble);
    {
      var x = Complex(1, 1);

      expect(x - yComplex, equals(x - yDouble));
    }

    {
      var x = Complex(neginf, 0);
      expect(x - yComplex, equals(x - yDouble));
    }
  });

  /*test('FloatingPointEqualsPrecondition1', () {
    expect(() {
      Complex.equals(Complex(3.0, 4.0), null, 3);
    }, throwsA(NullPointerException));
  });

  test('FloatingPointEqualsPrecondition2', () {
    expect(() {
      Complex.equals(null, Complex(3.0, 4.0), 3);
    }, throwsA(NullPointerException));
  });*/

  test('EqualsClass', () {
    var x = Complex(3.0, 4.0);
    expect(x is TestComplex, isFalse);
  });

  test('EqualsSame', () {
    var x = Complex(3.0, 4.0);
    expect(x == x, isTrue);
  });

  test('FloatingPointEquals', () {
    var re = -3.21;
    var im = 456789e10;

    var x = Complex(re, im);
    var y = Complex(re, im);

    expect(x == y, isTrue);
  });

  test('FloatingPointEqualsNaN', () {
    Complex c = Complex(double.nan, 1);
    expect(c.equals(c), isFalse);

    c = Complex(1, double.nan);
    expect(c.equals(c), isFalse);
  });

  test('FloatingPointEqualsWithAllowedDelta', () {
    final double re = 153.0000;
    final double im = 152.9375;
    final double tol1 = 0.0625;
    final Complex x = Complex(re, im);
    final Complex y = Complex(re + tol1, im + tol1);
    expect(x.equals(y, tolerance: tol1), isTrue);

    final double tol2 = 0.0624;
    expect(x.equals(y, tolerance: tol2), isFalse);
  });

  test('FloatingPointEqualsWithRelativeTolerance', () {
    final double tol = 1e-4;
    final double re = 1;
    final double im = 1e10;

    final double f = 1 + tol;
    final Complex x = Complex(re, im);
    final Complex y = Complex(re * f, im * f);
    expect(x.isApproximatelyEqualTo(y, tolerance: tol), isTrue);
  });

  test('EqualsTrue', () {
    var x = Complex(3.0, 4.0);
    var y = Complex(3.0, 4.0);
    expect(x == y, isTrue);
  });

  test('EqualsRealDifference', () {
    var x = Complex(0.0, 0.0);
    var y = Complex(0.0 + double.minPositive, 0.0);
    expect(x == y, isFalse);
  });

  test('EqualsImaginaryDifference', () {
    var x = Complex(0.0, 0.0);
    var y = Complex(0.0, 0.0 + double.minPositive);
    expect(x == y, isFalse);
  });

  test('EqualsNaN', () {
    var realNaN = Complex(double.nan, 0.0);
    var imaginaryNaN = Complex(0.0, double.nan);
    Complex complexNaN = Complex.nan();
    expect(realNaN == imaginaryNaN, isTrue);
    expect(imaginaryNaN == complexNaN, isTrue);
    expect(realNaN == complexNaN, isTrue);
  });

  test('HashCode', () {
    var x = Complex(0.0, 0.0);
    {
      var y = Complex(0.0, 0.0 + double.minPositive);
      expect(x.hashCode == y.hashCode, isFalse);
    }
    {
      {
        var y = Complex(0.0 + double.minPositive, 0.0);
        expect(x.hashCode == y.hashCode, isFalse);
      }
      var realNaN = Complex(double.nan, 0.0);
      var imaginaryNaN = Complex(0.0, double.nan);
      expect(realNaN.hashCode, equals(imaginaryNaN.hashCode));
      expect(imaginaryNaN.hashCode, equals(Complex.nan().hashCode));
    }

    // MATH-1118
    // "equals" and "hashCode" must be compatible: if two objects have
    // different hash codes, "equals" must return false.
    final msg = "'==' not compatible with 'hashCode'";

    {
      var x = Complex(0.0, 0.0);
      var y = Complex(0.0, -0.0);
      expect(x.hashCode != y.hashCode, isFalse);
      expect(x != y, isFalse, reason: msg);
    }
    {
      var x = Complex(0.0, 0.0);
      var y = Complex(-0.0, 0.0);
      expect(x.hashCode != y.hashCode, isFalse);
      expect(x != y, isFalse, reason: msg);
    }
  });

  test('Acos', () {
    var z = Complex(3, 4);
    var expected = Complex(0.936812, -2.30551);
    expect(expected, closeToZ(z.acos(), 1.0e-5));
    expect(Complex(math.acos(0), 0), closeToZ(Complex.zero().acos(), 1.0e-12));
  });

  test('AcosInf', () {
    expect(Complex.nan(), equals(oneInf.acos()));
    expect(Complex.nan(), equals(oneNegInf.acos()));
    expect(Complex.nan(), equals(infOne.acos()));
    expect(Complex.nan(), equals(negInfOne.acos()));
    expect(Complex.nan(), equals(infInf.acos()));
    expect(Complex.nan(), equals(infNegInf.acos()));
    expect(Complex.nan(), equals(negInfInf.acos()));
    expect(Complex.nan(), equals(negInfNegInf.acos()));
  });

  test('AcosNaN', () {
    expect(Complex.nan().acos().isNaN, isTrue);
  });

  test('Asin', () {
    var z = Complex(3, 4);
    var expected = Complex(0.633984, 2.30551);
    expect(expected, closeToZ(z.asin(), 1.0e-5));
  });

  test('AsinNaN', () {
    expect(Complex.nan().asin().isNaN, isTrue);
  });

  test('AsinInf', () {
    expect(Complex.nan(), equals(oneInf.asin()));
    expect(Complex.nan(), equals(oneNegInf.asin()));
    expect(Complex.nan(), equals(infOne.asin()));
    expect(Complex.nan(), equals(negInfOne.asin()));
    expect(Complex.nan(), equals(infInf.asin()));
    expect(Complex.nan(), equals(infNegInf.asin()));
    expect(Complex.nan(), equals(negInfInf.asin()));
    expect(Complex.nan(), equals(negInfNegInf.asin()));
  });

  test('Atan', () {
    var z = Complex(3, 4);
    var expected = Complex(1.44831, 0.158997);
    expect(expected, closeToZ(z.atan(), 1.0e-5));
  });

  test('AtanInf', () {
    expect(Complex.nan(), equals(oneInf.atan()));
    expect(Complex.nan(), equals(oneNegInf.atan()));
    expect(Complex.nan(), equals(infOne.atan()));
    expect(Complex.nan(), equals(negInfOne.atan()));
    expect(Complex.nan(), equals(infInf.atan()));
    expect(Complex.nan(), equals(infNegInf.atan()));
    expect(Complex.nan(), equals(negInfInf.atan()));
    expect(Complex.nan(), equals(negInfNegInf.atan()));
  });

  test('AtanI', () {
    expect(Complex.i().atan().isNaN, isTrue);
  });

  test('AtanNaN', () {
    expect(Complex.nan().atan().isNaN, isTrue);
  });

  test('Cos', () {
    var z = Complex(3, 4);
    var expected = Complex(-27.03495, -3.851153);
    expect(expected, closeToZ(z.cos(), 1.0e-5));
  });

  test('CosNaN', () {
    expect(Complex.nan().cos().isNaN, isTrue);
  });

  test('CosInf', () {
    expect(infNegInf, equals(oneInf.cos()));
    expect(infInf, equals(oneNegInf.cos()));
    expect(Complex.nan(), equals(infOne.cos()));
    expect(Complex.nan(), equals(negInfOne.cos()));
    expect(Complex.nan(), equals(infInf.cos()));
    expect(Complex.nan(), equals(infNegInf.cos()));
    expect(Complex.nan(), equals(negInfInf.cos()));
    expect(Complex.nan(), equals(negInfNegInf.cos()));
  });

  test('Cosh', () {
    var z = Complex(3, 4);
    var expected = Complex(-6.58066, -7.58155);
    expect(expected, closeToZ(z.cosh(), 1.0e-5));
  });

  test('CoshNaN', () {
    expect(Complex.nan().cosh().isNaN, isTrue);
  });

  test('CoshInf', () {
    expect(Complex.nan(), equals(oneInf.cosh()));
    expect(Complex.nan(), equals(oneNegInf.cosh()));
    expect(infInf, equals(infOne.cosh()));
    expect(infNegInf, equals(negInfOne.cosh()));
    expect(Complex.nan(), equals(infInf.cosh()));
    expect(Complex.nan(), equals(infNegInf.cosh()));
    expect(Complex.nan(), equals(negInfInf.cosh()));
    expect(Complex.nan(), equals(negInfNegInf.cosh()));
  });

  test('Exp', () {
    var z = Complex(3, 4);
    var expected = Complex(-13.12878, -15.20078);
    expect(expected, closeToZ(z.exp(), 1.0e-5));
    expect(Complex.one(), closeToZ(Complex.zero().exp(), 10e-12));
    final iPi = Complex.i() * Complex(pi, 0);
    expect(-Complex.one(), closeToZ(iPi.exp(), 10e-12));
  });

  test('ExpNaN', () {
    expect(Complex.nan().exp().isNaN, isTrue);
  });

  test('ExpInf', () {
    expect(Complex.nan(), equals(oneInf.exp()));
    expect(Complex.nan(), equals(oneNegInf.exp()));
    expect(infInf, equals(infOne.exp()));
    expect(Complex.zero(), equals(negInfOne.exp()));
    expect(Complex.nan(), equals(infInf.exp()));
    expect(Complex.nan(), equals(infNegInf.exp()));
    expect(Complex.nan(), equals(negInfInf.exp()));
    expect(Complex.nan(), equals(negInfNegInf.exp()));
  });

  test('Log', () {
    var z = Complex(3, 4);
    var expected = Complex(1.60944, 0.927295);
    expect(expected, closeToZ(z.log(), 1.0e-5));
  });

  test('LogNaN', () {
    expect(Complex.nan().log().isNaN, isTrue);
  });

  test('LogInf', () {
    expect(Complex(inf, pi / 2), closeToZ(oneInf.log(), 10e-12));
    expect(Complex(inf, -pi / 2), closeToZ(oneNegInf.log(), 10e-12));
    expect(infZero, closeToZ(infOne.log(), 10e-12));
    expect(Complex(inf, pi), closeToZ(negInfOne.log(), 10e-12));
    expect(Complex(inf, pi / 4), closeToZ(infInf.log(), 10e-12));
    expect(Complex(inf, -pi / 4), closeToZ(infNegInf.log(), 10e-12));
    expect(Complex(inf, 3 * pi / 4), closeToZ(negInfInf.log(), 10e-12));
    expect(
      Complex(inf, -3 * pi / 4),
      closeToZ(negInfNegInf.log(), 10e-12),
    );
  });

  test('LogZero', () {
    expect(negInfZero, equals(Complex.zero().log()));
  });

  test('Pow', () {
    var x = Complex(3, 4);
    var y = Complex(5, 6);
    var expected = Complex(-1.860893, 11.83677);
    expect(expected, closeToZ(x.pow(y), 1.0e-5));
  });

  test('PowNaNBase', () {
    var x = Complex(3, 4);
    expect(Complex.nan().power(x).isNaN, isTrue);
  });

  test('PowNaNExponent', () {
    var x = Complex(3, 4);
    expect(x.power(Complex.nan()).isNaN, isTrue);
  });

  test('PowInf', () {
    expect(Complex.nan(), equals(Complex.one().power(oneInf)));
    expect(Complex.nan(), equals(Complex.one().power(oneNegInf)));
    expect(Complex.nan(), equals(Complex.one().power(infOne)));
    expect(Complex.nan(), equals(Complex.one().power(infInf)));
    expect(Complex.nan(), equals(Complex.one().power(infNegInf)));
    expect(Complex.nan(), equals(Complex.one().power(negInfInf)));
    expect(Complex.nan(), equals(Complex.one().power(negInfNegInf)));
    expect(Complex.nan(), equals(infOne.power(Complex.one())));
    expect(Complex.nan(), equals(negInfOne.power(Complex.one())));
    expect(Complex.nan(), equals(infInf.power(Complex.one())));
    expect(Complex.nan(), equals(infNegInf.power(Complex.one())));
    expect(Complex.nan(), equals(negInfInf.power(Complex.one())));
    expect(Complex.nan(), equals(negInfNegInf.power(Complex.one())));
    expect(Complex.nan(), equals(negInfNegInf.power(infNegInf)));
    expect(Complex.nan(), equals(negInfNegInf.power(negInfNegInf)));
    expect(Complex.nan(), equals(negInfNegInf.power(infInf)));
    expect(Complex.nan(), equals(infInf.power(infNegInf)));
    expect(Complex.nan(), equals(infInf.power(negInfNegInf)));
    expect(Complex.nan(), equals(infInf.power(infInf)));
    expect(Complex.nan(), equals(infNegInf.power(infNegInf)));
    expect(Complex.nan(), equals(infNegInf.power(negInfNegInf)));
    expect(Complex.nan(), equals(infNegInf.power(infInf)));
  });

  test('PowZero', () {
    expect(Complex.nan(), equals(Complex.zero().power(Complex.one())));
    expect(Complex.nan(), equals(Complex.zero().power(Complex.zero())));
    expect(Complex.nan(), equals(Complex.zero().power(Complex.i())));
    expect(
        Complex.one(), closeToZ(Complex.one().power(Complex.zero()), 10e-12));
    expect(Complex.one(), closeToZ(Complex.i().power(Complex.zero()), 10e-12));
    expect(Complex.one(), closeToZ((3.im - 1).power(Complex.zero()), 10e-12));
  });

  test('ScalarPow', () {
    var x = Complex(3, 4);
    var yDouble = 5.0;
    var yComplex = Complex(yDouble);
    expect(x.power(yComplex), equals(x.pow(yDouble)));
  });

  test('ScalarPowNaNBase', () {
    var x = Complex.nan();
    var yDouble = 5.0;
    var yComplex = Complex(yDouble);
    expect(x.power(yComplex), equals(x.pow(yDouble)));
  });

  test('ScalarPowNaNExponent', () {
    var x = Complex(3, 4);
    var yDouble = double.nan;
    var yComplex = Complex(yDouble);
    expect(x.power(yComplex), x.pow(yDouble));
  });

  test('ScalarPowInf', () {
    expect(Complex.nan(), equals(Complex.one().pow(double.infinity)));
    expect(Complex.nan(), equals(Complex.one().pow(double.negativeInfinity)));
    expect(Complex.nan(), equals(infOne.pow(1.0)));
    expect(negInfInf, equals(negInfOne.pow(1.0)));
    expect(Complex.infinity(), equals(infInf.pow(1.0)));
    expect(infNegInf, equals(infNegInf.pow(1.0)));
    expect(Complex.negativeInfinity(), equals(negInfInf.pow(10)));
    expect(Complex.negativeInfinity(), equals(negInfNegInf.pow(1.0)));
    expect(Complex.nan(), equals(negInfNegInf.pow(double.infinity)));
    expect(Complex.nan(), equals(negInfNegInf.pow(double.infinity)));
    expect(Complex.nan(), equals(infInf.pow(double.infinity)));
    expect(Complex.nan(), equals(infInf.pow(double.negativeInfinity)));
    expect(Complex.nan(), equals(infNegInf.pow(double.negativeInfinity)));
    expect(Complex.nan(), equals(infNegInf.pow(double.infinity)));
  });

  test('ScalarPowZero', () {
    expect(Complex.zero(), equals(Complex.zero().pow(1.0)));
    expect(Complex.nan(), equals(Complex.zero().pow(0.0)));
    expect(Complex.one(), closeToZ(Complex.one().pow(0.0), 10e-12));
    expect(Complex.one(), closeToZ(Complex.i().pow(0.0), 10e-12));
    expect(Complex.one(), closeToZ(Complex(-1, 3).pow(0.0), 10e-12));
  });

  test('Sin', () {
    var z = Complex(3, 4);
    var expected = Complex(3.853738, -27.01681);
    expect(expected, closeToZ(z.sin(), 1.0e-5));
  });

  test('SinInf', () {
    expect(infInf, equals(oneInf.sin()));
    expect(infNegInf, equals(oneNegInf.sin()));
    expect(Complex.nan(), equals(infOne.sin()));
    expect(Complex.nan(), equals(negInfOne.sin()));
    expect(Complex.nan(), equals(infInf.sin()));
    expect(Complex.nan(), equals(infNegInf.sin()));
    expect(Complex.nan(), equals(negInfInf.sin()));
    expect(Complex.nan(), equals(negInfNegInf.sin()));
  });

  test('SinNaN', () {
    expect(Complex.nan().sin().isNaN, isTrue);
  });

  test('Sinh', () {
    var z = Complex(3, 4);
    var expected = Complex(-6.54812, -7.61923);
    expect(expected, closeToZ(z.sinh(), 1.0e-5));
  });

  test('SinhNaN', () {
    expect(Complex.nan().sinh().isNaN, isTrue);
  });

  test('SinhInf', () {
    expect(Complex.nan(), equals(oneInf.sinh()));
    expect(Complex.nan(), equals(oneNegInf.sinh()));
    expect(infInf, equals(infOne.sinh()));
    expect(negInfInf, equals(negInfOne.sinh()));
    expect(Complex.nan(), equals(infInf.sinh()));
    expect(Complex.nan(), equals(infNegInf.sinh()));
    expect(Complex.nan(), equals(negInfInf.sinh()));
    expect(Complex.nan(), equals(negInfNegInf.sinh()));
  });

  test('SqrtRealPositive', () {
    var z = Complex(3, 4);
    var expected = Complex(2, 1);
    expect(expected, closeToZ(z.sqrt(), 1.0e-5));
  });

  test('SqrtRealZero', () {
    var z = Complex(0.0, 4);
    var expected = Complex(1.41421, 1.41421);
    expect(expected, closeToZ(z.sqrt(), 1.0e-5));
  });

  test('SqrtRealNegative', () {
    var z = Complex(-3.0, 4);
    var expected = Complex(1, 2);
    expect(expected, closeToZ(z.sqrt(), 1.0e-5));
  });

  test('SqrtImaginaryZero', () {
    var z = Complex(-3.0, 0.0);
    final expected = Complex(0.0, math.sqrt(3));
    expect(z.sqrt(), closeToZ(expected, 1.0e-9));
  });

  test('SqrtImaginaryNegative', () {
    var z = Complex(-3.0, -4.0);
    var expected = Complex(1.0, -2.0);
    expect(expected, closeToZ(z.sqrt(), 1.0e-5));
  });

  test('SqrtPolar', () {
    var r = 1.0;
    for (var i = 0; i < 5; i++) {
      r += i;
      var theta = 0.0;
      for (var j = 0; j < 11; j++) {
        theta += pi / 12;
        final z = Complex.polar(r, theta);
        final sqrtz = Complex.polar(math.sqrt(r), theta / 2);
        expect(sqrtz, closeToZ(z.sqrt(), 10e-12));
      }
    }
  });

  test('SqrtNaN', () {
    expect(Complex.nan().sqrt().isNaN, isTrue);
  });

  test('SqrtInf', () {
    expect(infNaN, equals(oneInf.sqrt()));
    expect(infNaN, equals(oneNegInf.sqrt()));
    expect(infZero, equals(infOne.sqrt()));
    expect(zeroInf, equals(negInfOne.sqrt()));
    expect(infNaN, equals(infInf.sqrt()));
    expect(infNaN, equals(infNegInf.sqrt()));
    expect(nanInf, equals(negInfInf.sqrt()));
    expect(nanNegInf, equals(negInfNegInf.sqrt()));
  });

  test('Sqrt1z', () {
    var z = Complex(3, 4);
    var expected = Complex(4.08033, -2.94094);
    expect(expected, closeToZ(z.sqrt1z(), 1.0e-5));
  });

  test('Sqrt1zNaN', () {
    expect(Complex.nan().sqrt1z().isNaN, isTrue);
  });

  test('Tan', () {
    var z = Complex(3, 4);
    var expected = Complex(-0.000187346, 0.999356);
    expect(expected, closeToZ(z.tan(), 1.0e-5));
    /* Check that no overflow occurs (MATH-722) */

    {
      final actual = Complex(3.0, 1E10).tan();
      var expected = Complex(0, 1);
      expect(expected, closeToZ(actual, 1.0e-5));
    }
    {
      final actual = Complex(3.0, -1E10).tan();
      var expected = Complex(0, -1);
      expect(expected, closeToZ(actual, 1.0e-5));
    }
  });

  test('TanNaN', () {
    expect(Complex.nan().tan().isNaN, isTrue);
  });

  test('TanInf', () {
    expect(Complex(0.0, 1.0), equals(oneInf.tan()));
    expect(Complex(0.0, -1.0), equals(oneNegInf.tan()));
    expect(Complex.nan(), equals(infOne.tan()));
    expect(Complex.nan(), equals(negInfOne.tan()));
    expect(Complex.nan(), equals(infInf.tan()));
    expect(Complex.nan(), equals(infNegInf.tan()));
    expect(Complex.nan(), equals(negInfInf.tan()));
    expect(Complex.nan(), equals(negInfNegInf.tan()));
  });

  test('TanCritical', () {
    expect(infNaN, equals(Complex(pi / 2, 0).tan()));
    expect(negInfNaN, equals(Complex(-pi / 2, 0).tan()));
  });

  test('Tanh', () {
    var z = Complex(3, 4);
    var expected = Complex(1.00071, 0.00490826);
    expect(expected, closeToZ(z.tanh(), 1.0e-5));
    /* Check that no overflow occurs (MATH-722) */
    final actual = Complex(1E10, 3.0).tanh();
    {
      var expected = Complex(1, 0);
      expect(expected, closeToZ(actual, 1.0e-5));
    }
    {
      final actual = Complex(-1E10, 3.0).tanh();
      var expected = Complex(-1, 0);
      expect(expected, closeToZ(actual, 1.0e-5));
    }
  });

  test('TanhNaN', () {
    expect(Complex.nan().tanh().isNaN, isTrue);
  });

  test('TanhInf', () {
    expect(Complex.nan(), equals(oneInf.tanh()));
    expect(Complex.nan(), equals(oneNegInf.tanh()));
    expect(Complex.nan(), equals(infOne.tanh()));
    expect(Complex.nan(), equals(negInfOne.tanh()));
    expect(Complex.nan(), equals(infInf.tanh()));
    expect(Complex.nan(), equals(infNegInf.tanh()));
    expect(Complex.nan(), equals(negInfInf.tanh()));
    expect(Complex.nan(), equals(negInfNegInf.tanh()));
  });

  test('TanhCritical', () {
    expect(nanInf, equals(Complex(0, pi / 2).tanh()));
  });

  /// test issue MATH-221

  test('Math221', () {
    expect(Complex(0, -1) == Complex.i() * Complex(-1, 0), isTrue);
  });

  /// Test: computing <b>third roots</b> of z.
  ///
  ///     z = -2 + 2 * i
  ///      => z_0 =  1      +          i
  ///      => z_1 = -1.3660 + 0.3660 * i
  ///      => z_2 =  0.3660 - 1.3660 * i

  test('NthRoot_normal_thirdRoot', () {
    // The complex number we want to compute all third-roots for.
    var z = Complex(-2, 2);
    // The List holding all third roots
    final thirdRootsOfZ = z.nthRoot(3, allRoots: true); //.toArray(Complex[0]);
    // Returned Collection must not be empty!
    expect(3, equals(thirdRootsOfZ.length));
    // test z_0
    expect(1.0, closeTo(thirdRootsOfZ[0].real, 1.0e-5));
    expect(1.0, closeTo(thirdRootsOfZ[0].imaginary, 1.0e-5));
    // test z_1
    expect(-1.3660254037844386, closeTo(thirdRootsOfZ[1].real, 1.0e-5));
    expect(0.36602540378443843, closeTo(thirdRootsOfZ[1].imaginary, 1.0e-5));
    // test z_2
    expect(0.366025403784439, closeTo(thirdRootsOfZ[2].real, 1.0e-5));
    expect(-1.3660254037844384, closeTo(thirdRootsOfZ[2].imaginary, 1.0e-5));
  });

  /// Test: computing <b>fourth roots</b> of z.
  ///
  ///     z = 5 - 2 * i
  ///      => z_0 =  1.5164 - 0.1446 * i
  ///      => z_1 =  0.1446 + 1.5164 * i
  ///      => z_2 = -1.5164 + 0.1446 * i
  ///      => z_3 = -1.5164 - 0.1446 * i

  test('NthRoot_normal_fourthRoot', () {
    // The complex number we want to compute all third-roots for.
    var z = Complex(5, -2);
    // The List holding all fourth roots
    final fourthRootsOfZ = z.nthRoot(4, allRoots: true); //.toArray(Complex[0]);
    // Returned Collection must not be empty!
    expect(4, equals(fourthRootsOfZ.length));
    // test z_0
    expect(0.14469266210702256, closeTo(fourthRootsOfZ[0].real, 1.0e-5));
    expect(1.5164629308487783, closeTo(fourthRootsOfZ[0].imaginary, 1.0e-5));
    // test z_1
    expect(-1.5164629308487783, closeTo(fourthRootsOfZ[1].real, 1.0e-5));
    expect(0.14469266210702267, closeTo(fourthRootsOfZ[1].imaginary, 1.0e-5));
    // test z_2
    expect(-0.14469266210702275, closeTo(fourthRootsOfZ[2].real, 1.0e-5));
    expect(-1.5164629308487783, closeTo(fourthRootsOfZ[2].imaginary, 1.0e-5));
    // test z_3
    expect(1.5164629308487783, closeTo(fourthRootsOfZ[3].real, 1.0e-5));
    expect(-0.14469266210702283, closeTo(fourthRootsOfZ[3].imaginary, 1.0e-5));
  });

  /// Test: computing <b>third roots</b> of z.
  ///
  ///     z = 8
  ///      => z_0 =  2
  ///      => z_1 = -1 + 1.73205 * i
  ///      => z_2 = -1 - 1.73205 * i

  test('NthRoot_cornercase_thirdRoot_imaginaryPartEmpty', () {
    // The number 8 has three third roots.
    // One we all already know is the number 2.
    // But there are two more complex roots.
    var z = Complex(8, 0);
    // The List holding all third roots
    final thirdRootsOfZ = z.nthRoot(3, allRoots: true); //.toArray(Complex[0]);
    // Returned Collection must not be empty!
    expect(3, equals(thirdRootsOfZ.length));
    // test z_0
    expect(2.0, closeTo(thirdRootsOfZ[0].real, 1.0e-5));
    expect(0.0, closeTo(thirdRootsOfZ[0].imaginary, 1.0e-5));
    // test z_1
    expect(-1.0, closeTo(thirdRootsOfZ[1].real, 1.0e-5));
    expect(1.7320508075688774, closeTo(thirdRootsOfZ[1].imaginary, 1.0e-5));
    // test z_2
    expect(-1.0, closeTo(thirdRootsOfZ[2].real, 1.0e-5));
    expect(-1.732050807568877, closeTo(thirdRootsOfZ[2].imaginary, 1.0e-5));
  });

  /// Test: computing <b>third roots</b> of z with real part 0.
  ///
  ///     z = 2 * i
  ///      => z_0 =  1.0911 + 0.6299 * i
  ///      => z_1 = -1.0911 + 0.6299 * i
  ///      => z_2 = -2.3144 - 1.2599 * i

  test('NthRoot_cornercase_thirdRoot_realPartZero', () {
    // complex number with only imaginary part
    var z = Complex(0, 2);
    // The List holding all third roots
    final thirdRootsOfZ = z.nthRoot(3, allRoots: true); //.toArray(Complex[0]);
    // Returned Collection must not be empty!
    expect(3, equals(thirdRootsOfZ.length));
    // test z_0
    expect(1.0911236359717216, closeTo(thirdRootsOfZ[0].real, 1.0e-5));
    expect(0.6299605249474365, closeTo(thirdRootsOfZ[0].imaginary, 1.0e-5));
    // test z_1
    expect(-1.0911236359717216, closeTo(thirdRootsOfZ[1].real, 1.0e-5));
    expect(0.6299605249474365, closeTo(thirdRootsOfZ[1].imaginary, 1.0e-5));
    // test z_2
    expect(-2.3144374213981936E-16, closeTo(thirdRootsOfZ[2].real, 1.0e-5));
    expect(-1.2599210498948732, closeTo(thirdRootsOfZ[2].imaginary, 1.0e-5));
  });

  /// Test cornercases with NaN and Infinity.

  test('NthRoot_cornercase_NAN_Inf', () {
    // NaN + finite -> NaN
    {
      final roots = oneNaN.nthRoot(3, allRoots: true);
      expect(1, equals(roots.length));
      expect(Complex.nan(), equals(roots[0]));
    }

    {
      final roots = nanZero.nthRoot(3, allRoots: true);
      expect(1, equals(roots.length));
      expect(Complex.nan(), equals(roots[0]));
    }

    // NaN + infinite -> NaN
    {
      final roots = nanInf.nthRoot(3, allRoots: true);
      expect(1, equals(roots.length));
      expect(Complex.nan(), equals(roots[0]));
    }

    // finite + infinite -> Inf
    {
      final roots = oneInf.nthRoot(3, allRoots: true);
      expect(1, equals(roots.length));
      expect(Complex.infinity(), equals(roots[0]));
    }

    // infinite + infinite -> Inf
    {
      final roots = negInfInf.nthRoot(3, allRoots: true);
      expect(1, equals(roots.length));
      expect(Complex.infinity(), equals(roots[0]));
    }
  });

  /// Test standard values

  test('argument', () {
    var z = Complex(1, 0);
    expect(0.0, closeTo(z.argument, 1.0e-12));

    z = Complex(1, 1);
    expect(math.pi / 4, closeTo(z.argument, 1.0e-12));

    z = Complex(0, 1);
    expect(math.pi / 2, closeTo(z.argument, 1.0e-12));

    z = Complex(-1, 1);
    expect(3 * math.pi / 4, closeTo(z.argument, 1.0e-12));

    z = Complex(-1, 0);
    expect(math.pi, closeTo(z.argument, 1.0e-12));

    z = Complex(-1, -1);
    expect(-3 * math.pi / 4, closeTo(z.argument, 1.0e-12));

    z = Complex(0, -1);
    expect(-math.pi / 2, closeTo(z.argument, 1.0e-12));

    z = Complex(1, -1);
    expect(-math.pi / 4, closeTo(z.argument, 1.0e-12));
  });

  /// Verify atan2-style handling of infinite parts

  test('argumentInf', () {
    expect(math.pi / 4, closeTo(infInf.argument, 1.0e-12));
    expect(math.pi / 2, closeTo(oneInf.argument, 1.0e-12));
    expect(0.0, closeTo(infOne.argument, 1.0e-12));
    expect(math.pi / 2, closeTo(zeroInf.argument, 1.0e-12));
    expect(0.0, closeTo(infZero.argument, 1.0e-12));
    expect(math.pi, closeTo(negInfOne.argument, 1.0e-12));
    expect(-3.0 * math.pi / 4, closeTo(negInfNegInf.argument, 1.0e-12));
    expect(-math.pi / 2, closeTo(oneNegInf.argument, 1.0e-12));
  });

  /// Verify that either part NaN results in NaN

  test('GetArgumentNaN', () {
    expect(nanZero.argument.isNaN, isTrue);
    expect(zeroNaN.argument.isNaN, isTrue);
    expect(Complex.nan().argument.isNaN, isTrue);
  });
}
