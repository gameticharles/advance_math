import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('Complex Expression Partial Evaluation', () {
    test('should handle partial evaluation with Complex literals', () {
      // Scenario from example.dart:
      // Add(Multiply(Literal(8), y), Multiply(Literal(2), x))
      // .evaluate({'x': 1})
      // Should simplify to 8*y + 2

      final x = Variable('x');
      final y = Variable('y');
      final expr = Add(
        Multiply(Literal(8), y),
        Multiply(Literal(2), x),
      );

      final context = {'x': 1};
      final result = expr.simplify().evaluate(context);

      print('Result: $result');

      // Expected: "((8.0*y) + 2.0)" or similar structure
      // It should NOT crash.
      expect(result.toString(), contains('y'));
      expect(result.toString(), contains('8'));
      expect(result.toString(), contains('2'));

      // Check type
      expect(result, isA<Expression>());
    });

    test('should handle Complex number multiplication with Variable', () {
      final y = Variable('y');
      final c = Complex(3, 4); // 3 + 4i
      final expr = Multiply(Literal(c), y);

      final result = expr.evaluate(); // Partial eval
      print('Complex partial result: $result');

      expect(result.toString(), contains('3'));
      expect(result.toString(), contains('4'));
      expect(result.toString(), contains('y'));
    });
  });
}
