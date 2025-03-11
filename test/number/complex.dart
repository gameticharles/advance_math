import 'package:test/test.dart';
import 'package:advance_math/src/number/complex/complex.dart';
import 'package:advance_math/advance_math.dart' as math;

void main() {
  group('Complex Number Tests', () {
    group('Special Values and Constants', () {
      const inf = double.infinity;
      const neginf = double.negativeInfinity;
      const nan = double.nan;

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
        expect(c.modulus, c.complexModulus);
        expect(c.modulus, math.sqrt(29));
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
}
