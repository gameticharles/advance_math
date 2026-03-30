import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';

void main() {
  group('Polynomial Expressions', () {
    final parser = ExpressionParser();
    final context = defaultContext;

    test('Polynomial creation from string', () {
      final exp = parser.parse('poly("x^2 + 2x + 1")');
      final result = exp.evaluate(context);
      expect(result, isA<Polynomial>());
      expect(result.toString().replaceAll(' ', ''),
          anyOf(contains('x²+2x+1'), contains('x^2+2x+1')));
    });

    test('Polynomial arithmetic: addition', () {
      final exp = parser.parse('poly("x + 1") + poly("x + 2")');
      final result = exp.evaluate(context);
      expect(result.toString().replaceAll(' ', ''),
          anyOf(contains('3+2x'), contains('3+2*x')));
    });

    test('Polynomial evaluation', () {
      final exp = parser.parse('evaluate(poly("x^2 + 1"), 2)');
      final result = exp.evaluate(context);
      expect(result, Complex(5, 0));
    });

    test('Polynomial roots', () {
      final exp = parser.parse('roots(poly("x^2 - 1"))');
      final result = exp.evaluate(context);
      expect(result, isA<List>());
      expect(result, contains(Complex(1, 0)));
      expect(result, contains(Complex(-1, 0)));
    });

    test('Polynomial differentiation', () {
      final exp = parser.parse('differentiate(poly("x^2 + 2x + 1"))');
      final result = exp.evaluate(context);
      expect(result.toString(), anyOf(contains('2x + 2'), contains('2x¹ + 2')));
    });

    test('Quadratic specific properties: direction of opening', () {
      // x^2 + 2x + 1 opens upwards
      final exp = parser.parse('quad_opening(poly("x^2 + 2x + 1"))');
      final result = exp.evaluate(context);
      expect(result, 'Upwards');

      // -x^2 opens downwards
      final exp2 = parser.parse('quad_opening(poly("-x^2"))');
      final result2 = exp2.evaluate(context);
      expect(result2, 'Downwards');
    });

    test('poly_expand: placeholder expands correctly', () {
      final exp = parser.parse('poly_expand(poly("x^2 + 2x + 1"))');
      final result = exp.evaluate(context);
      expect(result.toString().replaceAll(' ', ''),
          anyOf(contains('x²+2x+1'), contains('x^2+2x+1')));
    });

    test('Property functions are evaluated to numeric/complex values', () {
      final context = defaultContext;
      expect(
          Expression.parse('poly_discriminant(x^2 + 2x + 1)').evaluate(context),
          Complex.zero());
      expect(Expression.parse('quad_sum_roots(x^2 - 5x + 6)').evaluate(context),
          Complex(5, 0));
      expect(
          Expression.parse('quad_prod_roots(x^2 - 5x + 6)').evaluate(context),
          Complex(6, 0));
    });

    group('Unified Polynomial GCD/LCM', () {
      final context = defaultContext;

      test('Unified gcd handles polynomials', () {
        try {
          final result =
              Expression.parse('poly_gcd(x^2 + 2x + 1, x + 1)').evaluate(context);
          print('DEBUG: poly_gcd result: $result (${result.runtimeType})');
          expect(result, isA<Polynomial>());
          expect(result.toString(), contains('x + 1'));
        } catch (e, s) {
          print('DEBUG: poly_gcd ERROR: $e\n$s');
          rethrow;
        }
      });

      test('Unified lcm handles polynomials', () {
        try {
          final result =
              Expression.parse('poly_lcm(x + 1, x - 1)').evaluate(context);
          print('DEBUG: poly_lcm result: $result (${result.runtimeType})');
          expect(result, isA<Polynomial>());
          expect(result.toString().replaceAll(' ', ''), anyOf(contains('x²-1'), contains('x^2-1')));
        } catch (e, s) {
          print('DEBUG: poly_lcm ERROR: $e\n$s');
          rethrow;
        }
      });

      test('Unified gcd still handles numbers', () {
        try {
          final r1 = Expression.parse('gcd(18, 12)').evaluate(context);
          print('DEBUG: gcd(18, 12) = $r1 (${r1.runtimeType})');
          expect(r1, Complex(6, 0));
        } catch (e, s) {
          print('DEBUG: gcd(18, 12) ERROR: $e\n$s');
          rethrow;
        }
      });

      test('Unified lcm still handles numbers', () {
        try {
          final result = Expression.parse('lcm(15, 20)').evaluate(context);
          print('DEBUG: lcm(15, 20) = $result (${result.runtimeType})');
          expect(result, Complex(60, 0));
        } catch (e, s) {
          print('DEBUG: lcm(15, 20) ERROR: $e\n$s');
          rethrow;
        }
      });
    });

    group('Example Complex Usage', () {
      test('Complex arithmetic works in expressions', () {
        final context = defaultContext;
        expect(
            Expression.parse('complex(1, 2) + complex(3, 4)').evaluate(context),
            Complex(4, 6));
        expect(
            Expression.parse('complex(1, 2) * complex(3, 4)').evaluate(context),
            Complex(-5, 10));
      });
    });
  });
}
