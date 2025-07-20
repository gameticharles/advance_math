// ignore_for_file: collection_methods_unrelated_type

import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('hashCodes', () {
    test('equal', () {
      final a = Energy(J: 5);
      final b = Energy(J: 5);
      expect(a.hashCode, b.hashCode);

      final c = Energy(J: 5.0);
      expect(a.hashCode, c.hashCode);

      final d = Energy(J: Integer(5));
      expect(a.hashCode, d.hashCode);

      final e = Energy(J: Double(5));
      expect(a.hashCode, e.hashCode);

      final f = Energy(J: Complex.num(Double(5), Imaginary(0)));
      expect(a.hashCode, f.hashCode);

      final g = Energy(J: Precision('5.0'));
      expect(a.hashCode, g.hashCode);

      final h = Energy(J: Precision(5));
      expect(a.hashCode, h.hashCode);

      final i = Energy(J: Precision(5.0));
      expect(a.hashCode, i.hashCode);
    });

    test('not equal', () {
      final a = Energy(J: 5.0);
      final b = Energy(J: 5.000000001);
      expect(a.hashCode == b.hashCode, false);

      final c = Energy(J: -5.0);
      expect(a.hashCode == c.hashCode, false);

      final d = Energy(J: Integer(6));
      expect(a.hashCode == d.hashCode, false);

      final e = Energy(J: Double(-5));
      expect(a.hashCode == e.hashCode, false);

      final f = Energy(J: Complex.num(Double(5.01), Imaginary(0)));
      expect(a.hashCode == f.hashCode, false);

      final g = Energy(J: Precision('5.000000000000000000000000000001'));
      expect(a.hashCode == g.hashCode, false);

      final h = Energy(J: Precision(-5));
      expect(a.hashCode == h.hashCode, false);

      final i = Energy(J: Precision(5.0000001));
      expect(a.hashCode == i.hashCode, false);

      final j = Energy(J: Imaginary(5));
      expect(a.hashCode == j.hashCode, false);
    });

    test('Scalar Integer same as int', () {
      final a = Scalar(value: 5.0);
      final b = Scalar(value: 5);
      expect(a.hashCode, 5.hashCode);
      expect(b.hashCode, 5.hashCode);

      final c = Scalar(value: -5.0);
      expect(c.hashCode, -5.hashCode);

      final d = Scalar(value: Integer(5));
      expect(d.hashCode, 5.hashCode);

      final e = Scalar(value: Double(5));
      expect(e.hashCode, 5.hashCode);

      final f = Scalar(value: Complex.num(Double(5), Imaginary(0)));
      expect(f.hashCode, 5.hashCode);

      final g = Scalar(value: Precision('5.0000000000000000000'));
      expect(g.hashCode, 5.hashCode);

      final h = Scalar(value: Precision(-5));
      expect(h.hashCode, -5.hashCode);

      final i = Scalar(value: Precision(5.0));
      expect(i.hashCode, 5.hashCode);

      final j = Scalar(value: -5);
      expect(j.hashCode == 5.hashCode, false);
    });

    test('Scalar double same as Precise', () {
      final a = Scalar(value: 5.5);
      final b = Scalar(value: -5.5);
      expect(a.hashCode, Precision('5.5').hashCode);
      expect(b.hashCode, Precision('-5.5').hashCode);
    });

    test('scalar in map', () {
      final m = <int, String>{0: 'zero', 5: 'five', 10: 'ten'};

      expect(m[0], 'zero');
      expect(m[Scalar(value: 0)], 'zero');

      expect(m[5], 'five');
      expect(m[Scalar(value: Integer(5))], 'five');

      expect(m[10], 'ten');
      expect(m[Scalar(value: Double(10))], 'ten');

      expect(m[Scalar(value: Double(10.000001))], isNull);
    });
  });
}
