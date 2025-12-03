import 'package:advance_math/advance_math.dart';

void main() {
  print('--- Test x+a=0 ---');
  var x = Variable('x');
  var a = Variable('a');
  var eq = Expression.parse('x+a=0');
  print('Equation: $eq');

  // Simulate _solveByIsolation
  // x+a = 0
  // _solveFor(x+a, x, 0)
  // -> _solveFor(x, x, 0-a)

  var target = Literal(0);
  var sub = Subtract(target, a);
  print('Subtract(0, a): $sub');
  print('Simplified: ${sub.simplify()}');

  var res = ExpressionSolver.solve(eq, x);
  print('Result: $res');
}
