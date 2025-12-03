import 'package:advance_math/advance_math.dart';

void main() {
  // Test case: x+y=a, x-y=b, z+y=c
  // Expected: x = (a+b)/2, y = (a-b)/2, z = c - (a-b)/2

  var x = Variable('x');
  var y = Variable('y');
  var z = Variable('z');
  var a = Variable('a');
  var b = Variable('b');
  var c = Variable('c');

  var eq1 = Equation(Add(x, y), a); // x+y=a
  var eq2 = Equation(Subtract(x, y), b); // x-y=b
  var eq3 = Equation(Add(z, y), c); // z+y=c

  print('Equations:');
  print(eq1);
  print(eq2);
  print(eq3);

  // Step 1: Isolate x in eq1 -> x = a - y
  var isolatedX = Subtract(a, y);
  print('\nIsolated x: $isolatedX');

  // Step 2: Substitute x in eq2 -> (a-y) - y = b
  var subEq2Left = eq2.left.substitute(x, isolatedX);
  print('\nSubstituted eq2 left (raw): $subEq2Left');

  var subEq2LeftSimplified = subEq2Left.simplify();
  print('Substituted eq2 left (simplified): $subEq2LeftSimplified');

  // Check if y is solvable in simplified eq2: (a-2y) = b
  // _solveFor needs variable on one side usually, or able to isolate.
  // If simplified is a-2y, _solveFor(a-2y, y, b)

  // Let's try to run solveEquations directly
  print('\nRunning solveEquations...');
  var solutions = ExpressionSolver.solveEquations([
    Expression.parse("x+y=a"),
    Expression.parse("x-y=b"),
    Expression.parse("z+y=c")
  ], [
    x,
    y,
    z
  ]);

  print('Solutions: $solutions');
}
