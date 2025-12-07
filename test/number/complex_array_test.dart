import 'package:test/test.dart';
import 'package:advance_math/src/number/complex/complex.dart';

void main() {
  group('ComplexArray', () {
    test('constructs with correct length', () {
      final array = ComplexArray(5);
      expect(array.length, 5);
      expect(array[0], Complex.zero());
      expect(array[4], Complex.zero());
    });

    test('constructs from list', () {
      final list = [Complex(1, 1), Complex(2, 2)];
      final array = ComplexArray.from(list);
      expect(array.length, 2);
      expect(array[0], Complex(1, 1));
      expect(array[1], Complex(2, 2));
    });

    test('get and set', () {
      final array = ComplexArray(3);
      array[1] = Complex(3, 4);
      expect(array[1], Complex(3, 4));
      // interleaved data check
      // cannot access private _data but can verify behavior
      expect(array[0], Complex.zero());
    });

    test('addInPlace', () {
      final a = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);
      final b = ComplexArray.from([Complex(1, 1), Complex(2, 2)]);

      a.addInPlace(b);

      expect(a[0], Complex(2, 3));
      expect(a[1], Complex(5, 6));
      // b should be unchanged
      expect(b[0], Complex(1, 1));
    });

    test('subtractInPlace', () {
      final a = ComplexArray.from([Complex(2, 3), Complex(5, 6)]);
      final b = ComplexArray.from([Complex(1, 1), Complex(2, 2)]);

      a.subtractInPlace(b);

      expect(a[0], Complex(1, 2));
      expect(a[1], Complex(3, 4));
    });

    test('scaleInPlace', () {
      final a = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);

      a.scaleInPlace(2.0);

      expect(a[0], Complex(2, 4));
      expect(a[1], Complex(6, 8));
    });

    test('multiplyInPlace', () {
      // (1+2i)(1+1i) = (1-2) + i(1+2) = -1 + 3i
      final a = ComplexArray.from([Complex(1, 2), Complex(3, 4)]);
      final b = ComplexArray.from(
          [Complex(1, 1), Complex(0, 1)]); // 3+4i * i = -4 + 3i

      a.multiplyInPlace(b);

      expect(a[0], Complex(-1, 3));
      expect(a[1], Complex(-4, 3));
    });

    test('toList', () {
      final list = [Complex(1, 2), Complex(3, 4)];
      final array = ComplexArray.from(list);
      expect(array.toList(), list);
    });

    test('throws on size mismatch', () {
      final a = ComplexArray(2);
      final b = ComplexArray(3);

      expect(() => a.addInPlace(b), throwsArgumentError);
      expect(() => a.subtractInPlace(b), throwsArgumentError);
      expect(() => a.multiplyInPlace(b), throwsArgumentError);
    });
  });

  group('ComplexArraySimd', () {
    test('constructs with correct length', () {
      final array = ComplexArraySimd(5);
      expect(array.length, 5);
      expect(array[0], Complex.zero());
      expect(array[4], Complex.zero());
    });

    test('constructs from list', () {
      final list = [Complex(1, 1), Complex(2, 2)];
      final array = ComplexArraySimd.from(list);
      expect(array.length, 2);
      expect(array[0], Complex(1, 1));
      expect(array[1], Complex(2, 2));
    });

    test('get and set', () {
      final array = ComplexArraySimd(3);
      array[1] = Complex(3, 4);
      expect(array[1], Complex(3, 4));
      expect(array[0], Complex.zero());
    });

    test('addInPlace (SIMD)', () {
      final a = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);
      final b = ComplexArraySimd.from([Complex(1, 1), Complex(2, 2)]);

      a.addInPlace(b);

      expect(a[0], Complex(2, 3));
      expect(a[1], Complex(5, 6));
      expect(b[0], Complex(1, 1));
    });

    test('subtractInPlace (SIMD)', () {
      final a = ComplexArraySimd.from([Complex(2, 3), Complex(5, 6)]);
      final b = ComplexArraySimd.from([Complex(1, 1), Complex(2, 2)]);

      a.subtractInPlace(b);

      expect(a[0], Complex(1, 2));
      expect(a[1], Complex(3, 4));
    });

    test('scaleInPlace (SIMD)', () {
      final a = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);

      a.scaleInPlace(2.0);

      expect(a[0], Complex(2, 4));
      expect(a[1], Complex(6, 8));
    });

    test('multiplyInPlace', () {
      // (1+2i)(1+1i) = (1-2) + i(1+2) = -1 + 3i
      final a = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);
      final b = ComplexArraySimd.from([Complex(1, 1), Complex(0, 1)]);

      a.multiplyInPlace(b);

      expect(a[0], Complex(-1, 3));
      expect(a[1], Complex(-4, 3));
    });

    test('absAll', () {
      final a = ComplexArraySimd.from([Complex(3, 4), Complex(0, 1)]);
      final magnitudes = a.absAll();

      expect(magnitudes[0], closeTo(5.0, 1e-10));
      expect(magnitudes[1], closeTo(1.0, 1e-10));
    });

    test('toList', () {
      final list = [Complex(1, 2), Complex(3, 4)];
      final array = ComplexArraySimd.from(list);
      expect(array.toList(), list);
    });

    test('toComplexArray', () {
      final simd = ComplexArraySimd.from([Complex(1, 2), Complex(3, 4)]);
      final regular = simd.toComplexArray();

      expect(regular.length, 2);
      expect(regular[0], Complex(1, 2));
      expect(regular[1], Complex(3, 4));
    });

    test('throws on size mismatch', () {
      final a = ComplexArraySimd(2);
      final b = ComplexArraySimd(3);

      expect(() => a.addInPlace(b), throwsArgumentError);
      expect(() => a.subtractInPlace(b), throwsArgumentError);
      expect(() => a.multiplyInPlace(b), throwsArgumentError);
    });
  });
}
