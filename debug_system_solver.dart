import 'package:advance_math/advance_math.dart';

void main() {
  // Regression case from solve_spec_test.dart
  // Expected: [d, 4, x, 1, y, 2, z, 3]
  // Actual: [d, 4, x, -3, y, 0, z, 3]

  var equations = ["x-2*y=-3", "x+y-z+2*d=8", "5*d-1=19", "z+d=7"];

  print('Solving system: $equations');
  var parsedEquations = equations.map((e) => Expression.parse(e)).toList();
  var solution = ExpressionSolver.solveEquations(parsedEquations);
  print('Solution: $solution');

  // Check correctness
  // d=4, z=3, y=2, x=1

  // Debug specific equation simplification
  var eq2 = Expression.parse("x+y-z+2*d-8"); // moved 8 to left
  print('Parsed eq2: $eq2');

  // Substitute knowns
  var eq2Sub = eq2.substitute(Variable('d'), Literal(4));
  print('Substituted d=4: $eq2Sub');
  eq2Sub = eq2Sub.substitute(Variable('z'), Literal(3));
  print('Substituted z=3: $eq2Sub');
  print('Simplified: ${eq2Sub.simplify()}');
}
