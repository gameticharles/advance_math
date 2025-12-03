import 'package:advance_math/advance_math.dart';

void main() {
  print('Test 1: Simple solve');
  try {
    var eq = Expression.parse('x^2-1=0');
    print('Equation: $eq');

    var v = Variable('x');
    print('Calling ExpressionSolver.solve...');

    var result = ExpressionSolver.solve(eq, v);
    print('Result: $result');
  } catch (e, s) {
    print('Error: $e');
    print(s);
  }
  print('Done!');
}
