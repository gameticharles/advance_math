import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  group('VarArgsFunction Integration', () {
    test('should evaluate VarArgsFunction in expression', () {
      var context = defaultContext;

      // avg
      expect(
          Expression.parse('avg(10, 20, 30)').evaluate(context), equals(20.0));
      expect(Expression.parse('avg([10, 20, 30])').evaluate(context),
          equals(20.0));

      // max
      expect(Expression.parse('max(1, 5, 2)').evaluate(context), equals(5));
      expect(Expression.parse('max([1, 5, 2])').evaluate(context), equals(5));

      // min
      expect(Expression.parse('min(1, 5, 2)').evaluate(context), equals(1));
      expect(Expression.parse('min([1, 5, 2])').evaluate(context), equals(1));

      // sum
      expect(Expression.parse('sum(1, 2, 3)').evaluate(context), equals(6));
      expect(Expression.parse('sum([1, 2, 3])').evaluate(context), equals(6));

      // Mixed types and consistency
      expect(Expression.parse('sum(1, 2.5)').evaluate(context), equals(3.5));

      // Complex handling (assuming avg/sum support it if implemented)
      // Note: avg in utils.dart casts to num, so Complex with 0 imaginary part should work
      // but pure Complex might fail or be handled if supported by underlying logic.
      // Based on my edit, I added explicit support for real-Complex casting.
    });
  });
}
