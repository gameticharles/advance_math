import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Matrix Decomposition & Property Caching', () {
    test('LU Decomposition caching and invalidation', () {
      final m = Matrix([
        [4, 3],
        [6, 3]
      ]);

      final lu1 = m.decomposition.luDecompositionDoolittle();
      final lu2 = m.decomposition.luDecompositionDoolittle();

      // Second computation should be cached and return the exact same instance
      expect(identical(lu1, lu2), isTrue);

      // Mutate the matrix in-place (swap rows)
      m.swapRows(0, 1);

      // Now elementsSignature changes, so it should compute a new fresh LU decomposition
      final lu3 = m.decomposition.luDecompositionDoolittle();
      expect(identical(lu1, lu3), isFalse);
    });

    test('QR Decomposition, SVD, Cholesky caching and retrieval', () {
      final m = Matrix([
        [12, -51, 4],
        [6, 167, -68],
        [-4, 24, -41]
      ]);

      final qr1 = m.decomposition.qrDecompositionHouseholder();
      final qr2 = m.decomposition.qrDecompositionHouseholder();
      expect(identical(qr1, qr2), isTrue);

      final svd1 = m.decomposition.singularValueDecomposition();
      final svd2 = m.decomposition.singularValueDecomposition();
      expect(identical(svd1, svd2), isTrue);

      final cholMatrix = Matrix([
        [4, 12, -16],
        [12, 37, -43],
        [-16, -43, 98]
      ]);
      final chol1 = cholMatrix.decomposition.choleskyDecomposition();
      final chol2 = cholMatrix.decomposition.choleskyDecomposition();
      expect(identical(chol1, chol2), isTrue);
    });

    test('Matrix Inverse and Pseudo-inverse caching', () {
      final m = Matrix([
        [4, 7],
        [2, 6]
      ]);

      final inv1 = m.inverse();
      final inv2 = m.inverse();
      expect(identical(inv1, inv2), isTrue);

      final pinv1 = m.pseudoInverse();
      final pinv2 = m.pseudoInverse();
      expect(identical(pinv1, pinv2), isTrue);

      // Mutate and verify invalidation
      m.swapRows(0, 1);
      final inv3 = m.inverse();
      expect(identical(inv1, inv3), isFalse);
    });
  });

  group('Polynomial Durand-Kerner Roots Caching', () {
    test('Should cache roots of high-degree polynomial', () {
      // Create a polynomial DurandKerner instance
      final dk = DurandKerner.num([1, -10, 35, -50, 24, 0]); // x^5 - 10x^4 + 35x^3 - 50x^2 + 24x = 0 (roots: 0, 1, 2, 3, 4)

      final stopwatch1 = Stopwatch()..start();
      final r1 = dk.roots();
      stopwatch1.stop();

      final stopwatch2 = Stopwatch()..start();
      final r2 = dk.roots();
      stopwatch2.stop();

      expect(r1.length, equals(5));
      expect(r2.length, equals(5));
      expect(identical(r1, r2), isTrue);
      // The second run should be extremely fast (essentially 0ms) due to caching
      expect(stopwatch2.elapsedMicroseconds, lessThan(stopwatch1.elapsedMicroseconds));
    });
  });

  group('Expression Parser Caching', () {
    test('Should cache parsed expression syntax trees', () {
      final parser = ExpressionParser();
      final expr1 = parser.parse("sin(x) + cos(x) * 2");
      final expr2 = parser.parse("sin(x) + cos(x) * 2");

      expect(identical(expr1, expr2), isTrue);

      final expr3 = parser.tryParse("sin(x) + cos(x) * 2");
      expect(identical(expr1, expr3), isTrue);

      final expr4 = parser.parse("sin(x) + cos(x) * 3");
      expect(identical(expr1, expr4), isFalse);
    });
  });

  group('Primes and Arithmetic Caching', () {
    test('isPrime and primeFactors caching and speedup', () {
      // Large prime number
      const largePrime = 7919; // 1000th prime
      
      final stopwatch1 = Stopwatch()..start();
      final isP1 = isPrime(largePrime);
      stopwatch1.stop();

      final stopwatch2 = Stopwatch()..start();
      final isP2 = isPrime(largePrime);
      stopwatch2.stop();

      expect(isP1, isTrue);
      expect(isP2, isTrue);
      expect(stopwatch2.elapsedMicroseconds, lessThan(stopwatch1.elapsedMicroseconds));

      // primeFactors
      const numberToFactor = 123456789;
      
      final stopwatch3 = Stopwatch()..start();
      final factors1 = primeFactors(numberToFactor);
      stopwatch3.stop();

      final stopwatch4 = Stopwatch()..start();
      final factors2 = primeFactors(numberToFactor);
      stopwatch4.stop();

      expect(factors1, equals(factors2));
      expect(stopwatch4.elapsedMicroseconds, lessThan(stopwatch3.elapsedMicroseconds));
    });
  });
}
