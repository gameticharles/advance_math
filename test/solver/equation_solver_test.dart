import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/solver/equation_solver.dart';

void main() {
  group('Equation Solver Tests', () {
    final x = Variable('x');

    group('Equation Class', () {
      test('creates equation with left and right sides', () {
        final eq = Equation(x, Literal(5));
        expect(eq.left, equals(x));
        expect(eq.right, isA<Literal>());
      });

      test('converts to zero form', () {
        final eq = Equation(x, Literal(5));
        final zeroForm = eq.toZeroForm();

        expect(zeroForm, isA<Subtract>());
      });

      test('toString representation', () {
        final eq = Equation(Add(x, Literal(3)), Literal(7));
        expect(eq.toString(), contains('='));
      });
    });

    group('Linear Equations', () {
      test('solve x = 5', () {
        // x - 5 = 0
        final equation = Subtract(x, Literal(5));
        final solutions = ExpressionSolver.solve(equation, x);

        expect(solutions.length, equals(1));
        expect(solutions[0].toString(), contains('5'));
      });

      test('solve 2x = 10', () {
        // 2x - 10 = 0
        final equation = Subtract(Multiply(Literal(2), x), Literal(10));
        final solutions = ExpressionSolver.solve(equation, x);

        expect(solutions.length, equals(1));
        // x = 10/2 = 5
        expect(solutions[0], isA<Divide>());
      });

      test('solve x + 3 = 0', () {
        // x + 3 = 0 → x = -3
        final equation = Add(x, Literal(3));

        // Convert to zero form manually: (x + 3) - 0
        final zeroForm = Subtract(equation, Literal(0));

        // This should fail with UnimplementedError for now
        // as we haven't implemented full addition handling
        expect(() => ExpressionSolver.solve(zeroForm, x),
            throwsUnimplementedError);
      });
    });

    group('Quadratic Equations', () {
      test('solve x² = 9', () {
        // x² - 9 = 0
        final equation = Subtract(Pow(x, Literal(2)), Literal(9));
        final solutions = ExpressionSolver.solve(equation, x);

        expect(solutions.length, equals(2));
        // Should be ±3
        expect(solutions[0].toString(), contains('3'));
        expect(solutions[1], isA<Negate>());
      });

      test('solve x² =4', () {
        // x² - 4 = 0
        final equation = Subtract(Pow(x, Literal(2)), Literal(4));
        final solutions = ExpressionSolver.solve(equation, x);

        expect(solutions.length, equals(2));
        expect(solutions[0].toString(), contains('2'));
      });

      test('solve x² + 4 = 0 (no real solutions)', () {
        // x² - (-4) = 0 → x² = -4
        final equation = Subtract(Pow(x, Literal(2)), Literal(-4));
        final solutions = ExpressionSolver.solve(equation, x);

        // No real solutions for x² = -4
        expect(solutions, isEmpty);
      });
    });

    group('Edge Cases', () {
      test('equation with no variable returns empty or throws', () {
        // 5 = 0 (no solution)
        final equation = Literal(5);

        expect(() => ExpressionSolver.solve(equation, x),
            throwsUnimplementedError);
      });

      test('trivial equation 0 = 0', () {
        final equation = Literal(0);

        // Should recognize this has infinite solutions or handle specially
        expect(() => ExpressionSolver.solve(equation, x),
            throwsUnimplementedError);
      });
    });

    group('Variable Isolation', () {
      test('isolates x in x - 5 = 0', () {
        final equation = Subtract(x, Literal(5));
        final isolated = ExpressionSolver.solve(equation, x);

        expect(isolated.length, equals(1));
        expect(isolated[0].toString(), contains('5'));
      });

      test('isolates x in 3x - 15 = 0', () {
        final equation = Subtract(Multiply(Literal(3), x), Literal(15));
        final isolated = ExpressionSolver.solve(equation, x);

        expect(isolated.length, equals(1));
        expect(isolated[0], isA<Divide>());
      });
    });
  });
}
