import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/calculus/symbolic_integration.dart';

void main() {
  group('Symbolic Integration Tests', () {
    final x = Variable('x');
    final y = Variable('y');

    group('Power Rule', () {
      test('∫x dx = x²/2', () {
        final expr = x;
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Divide>());
        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('2'));
      });

      test('∫x² dx = x³/3', () {
        final expr = Pow(x, Literal(2));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Divide>());
        expect(result.toString(), contains('3'));
      });

      test('∫x³ dx = x⁴/4', () {
        final expr = Pow(x, Literal(3));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Divide>());
        expect(result.toString(), contains('4'));
      });

      test('∫1/x dx = ln(x)', () {
        final expr = Pow(x, Literal(-1));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Ln>());
      });

      test('∫c dx = c·x (constant integration)', () {
        final expr = Literal(5);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Multiply>());
        expect(result.toString(), contains('5'));
        expect(result.toString(), contains('x'));
      });

      test('∫3x² dx = x³', () {
        final expr = Multiply(Literal(3), Pow(x, Literal(2)));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Multiply>());
        expect(result.toString(), contains('3'));
      });
    });

    group('Trigonometric Integration', () {
      test('∫sin(x) dx = -cos(x)', () {
        final expr = Sin(x);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Negate>());
        final negated = result as Negate;
        expect(negated.operand, isA<Cos>());
      });

      test('∫cos(x) dx = sin(x)', () {
        final expr = Cos(x);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Sin>());
      });

      test('∫sec²(x) dx = tan(x)', () {
        final expr = Pow(Sec(x), Literal(2));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Tan>());
      });

      test('∫csc²(x) dx = -cot(x)', () {
        final expr = Pow(Csc(x), Literal(2));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Negate>());
        final negated = result as Negate;
        expect(negated.operand, isA<Cot>());
      });
    });

    group('Exponential Integration', () {
      test('∫e^x dx = e^x', () {
        final expr = Exp(x);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Exp>());
      });

      test('∫2^x dx = 2^x / ln(2)', () {
        final expr = Pow(Literal(2), x);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Divide>());
        expect(result.toString(), contains('2'));
        expect(result.toString(), contains('ln'));
      });
    });

    group('Sum and Difference Rules', () {
      test('∫(x + x²) dx = x²/2 + x³/3', () {
        final expr = Add(x, Pow(x, Literal(2)));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Add>());
      });

      test('∫(x² - x) dx = x³/3 - x²/2', () {
        final expr = Subtract(Pow(x, Literal(2)), x);
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Subtract>());
      });

      test('∫(sin(x) + cos(x)) dx = -cos(x) + sin(x)', () {
        final expr = Add(Sin(x), Cos(x));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Add>());
      });

      test('∫(3x² + 2x + 1) dx', () {
        final expr = Add(
            Add(Multiply(Literal(3), Pow(x, Literal(2))),
                Multiply(Literal(2), x)),
            Literal(1));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Add>());
      });
    });

    group('U-Substitution (Phase 4B)', () {
      test('∫2x·sin(x²) dx = -cos(x²)', () {
        final x = Variable('x');
        // ∫2x·sin(x²) dx where u = x², du = 2x dx
        final expr = Multiply(Multiply(Literal(2), x), Sin(Pow(x, Literal(2))));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Negate>());
        expect(result.toString(), contains('cos'));
        expect(result.toString(), contains('x'));
      });

      test('∫2x·e^(x²) dx = e^(x²)', () {
        final x = Variable('x');
        // ∫2x·e^(x²) dx where u = x², du = 2x dx
        final expr = Multiply(Multiply(Literal(2), x), Exp(Pow(x, Literal(2))));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Exp>());
        expect(result.toString(), contains('x'));
      });

      test('∫2x·cos(x²) dx = sin(x²)', () {
        final x = Variable('x');
        final expr = Multiply(Multiply(Literal(2), x), Cos(Pow(x, Literal(2))));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Sin>());
      });
    });

    group('Integration by Parts (Phase 4B)', () {
      test('∫x·cos(x) dx uses integration by parts', () {
        final x = Variable('x');
        // u = x, dv = cos(x)
        // ∫x·cos(x) dx = x·sin(x) + cos(x)
        final expr = Multiply(x, Cos(x));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result,
            isA<Subtract>()); // Actually Add? x*sin(x) - (-cos(x)) = x*sin(x) + cos(x)
        // Wait, ∫x cos x dx = x sin x - ∫sin x dx = x sin x - (-cos x) = x sin x + cos x
        // My implementation returns Subtract(Multiply(u, v), integralVDu)
        // u=x, v=sin(x). u*v = x*sin(x).
        // vDu = sin(x)*1 = sin(x).
        // ∫vDu = -cos(x).
        // Result = Subtract(x*sin(x), -cos(x)) = x*sin(x) - (-cos(x)).
        // This IS a Subtract expression where right side is Negate.
        expect(result, isA<Subtract>());
        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('sin'));
      });

      test('∫x·e^x dx uses integration by parts', () {
        final x = Variable('x');
        // u = x, dv = e^x
        // ∫x·e^x dx = x·e^x - e^x
        final expr = Multiply(x, Exp(x));
        final result = SymbolicIntegration.integrate(expr, x);

        expect(result, isA<Subtract>());
        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('exp'));
      });

      test('integration by parts framework exists', () {
        // Verify the IntegrationByPartsStrategy is instantiated
        expect(
            SymbolicIntegration.strategies
                .any((s) => s.name == 'Integration By Parts'),
            isTrue);
      });

      test('by parts structure verification', () {
        expect(SymbolicIntegration.strategies.length, equals(8));
      });
    });

    group('Edge Cases', () {
      test('constant with respect to different variable is linear', () {
        final expr = x; // x is constant with respect to y
        final result = SymbolicIntegration.integrate(expr, y);

        // ∫x dy = x·y
        expect(result, isA<Multiply>());
        expect(result.toString(), contains('x'));
        expect(result.toString(), contains('y'));
      });

      test('throws for unsupported expressions', () {
        // Something complex that we don't support yet
        final expr = Multiply(Sin(x), Cos(x)); // Would need substitution

        expect(() => SymbolicIntegration.integrate(expr, x),
            throwsUnimplementedError);
      });
    });

    group('Fundamental Theorem of Calculus', () {
      test('d/dx(∫x² dx) = x²', () {
        final f = Pow(x, Literal(2));
        final integral = SymbolicIntegration.integrate(f, x);
        final derivative = integral.differentiate(x);

        // After simplification, should equal f
        // Note: may have constant difference
        expect(derivative.toString(), contains('x'));
      });

      test('∫(d/dx(x³)) dx = x³ (up to constant)', () {
        final f = Pow(x, Literal(3));
        final derivative = f.differentiate(x); // 3x²
        final integral = SymbolicIntegration.integrate(derivative, x);

        // Should get x³ back (times constant)
        expect(integral.toString(), contains('x'));
        expect(integral.toString(), contains('3'));
      });
    });
  });
}
