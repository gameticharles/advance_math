import 'package:advance_math/advance_math.dart';

void main() {
  // Test case 1: Standard quadratic with parameters
  // Expected: Solves correctly
  print('--- Test 1: a*x^2+b*x+c ---');
  try {
    var sol1 =
        ExpressionSolver.solve(Expression.parse('a*x^2+b*x+c'), Variable('x'));
    print('Solution 1: $sol1');
  } catch (e) {
    print('Error 1: $e');
  }

  // Test case 2: Uncombined linear terms
  // Expected: Fails currently
  print('\n--- Test 2: -a*c-a*x+c*x+x^2 ---');
  try {
    var sol2 = ExpressionSolver.solve(
        Expression.parse('-a*c-a*x+c*x+x^2'), Variable('x'));
    print('Solution 2: $sol2');
  } catch (e) {
    print('Error 2: $e');
  }
}
