import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('NaN and Infinity Support', () {
    test('Literal allows NaN and Infinity', () {
      var inf = double.infinity;
      var nan = double.nan;

      var exprInf = Literal(inf);
      expect(exprInf, isA<Literal>());
      expect(exprInf.value.isInfinite, isTrue);

      var exprNan = Literal(nan);
      expect(exprNan, isA<Literal>());
      expect(exprNan.value.isNaN, isTrue);
    });

    test('Literal holds Complex with NaN/Infinity', () {
      var lInf = Literal(double.infinity);
      expect(lInf.value, isA<Complex>());
      expect(lInf.value.isInfinite, isTrue);

      var lNan = Literal(double.nan);
      expect(lNan.value, isA<Complex>());
      expect(lNan.value.isNaN, isTrue);
    });

    test('isIndeterminate/isInfinity with dynamic', () {
      var l = Literal(10);
      expect(l.isIndeterminate(double.nan), isFalse); // Should handle nan input
      expect(l.isInfinity(double.infinity), isFalse);
    });

    test('Complex operations with Infinity', () {
      var c1 = Complex(1, 0);
      var cInf = Complex(double.infinity, 0);
      var sum = c1 + cInf;
      expect(sum.isInfinite, isTrue);
    });
  });
}
