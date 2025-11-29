import 'package:advance_math/advance_math.dart';
import 'package:advance_math/src/math/algebra/calculus/symbolic_calculus.dart';
import 'package:advance_math/src/math/algebra/calculus/hybrid_calculus.dart';

void main() {
  print('--- Symbolic Calculus Example ---\n');

  // 1. Define an expression
  var x = Variable('x');
  var expr = Sin(x) * x; // x * sin(x)
  print('Expression: $expr');

  // 2. Partial Derivative
  var deriv = SymbolicCalculus.partialDerivative(expr, 'x');
  print('Derivative (d/dx): $deriv');
  // Expected: sin(x) + x*cos(x) (product rule)

  // Evaluate derivative at pi
  var derivAtPi = deriv.evaluate({'x': pi});
  print('Derivative at x=pi: $derivAtPi'); // Should be -pi

  // 3. Taylor Series
  print('\n--- Taylor Series ---');
  var sinExpr = Sin(x);
  var taylor = SymbolicCalculus.taylorSeries(sinExpr, 'x', 0, 5);
  print('Taylor Series of sin(x) at x=0 (order 5):');
  print(taylor);

  // 4. Limits
  print('\n--- Limits ---');
  var limitExpr = Sin(x) / x;
  var limitVal = SymbolicCalculus.limit(limitExpr, 'x', 0);
  print('Limit of sin(x)/x as x->0: $limitVal');

  // 5. Definite Integral
  print('\n--- Definite Integral ---');
  var polyExpr = Expression.parse('x^2');
  var integralVal = SymbolicCalculus.definiteIntegral(polyExpr, 'x', 0, 3);
  print('Integral of x^2 from 0 to 3: $integralVal'); // 27/3 = 9

  // 6. Hybrid Validation
  print('\n--- Hybrid Validation ---');
  var compareExpr = Expression.parse('x^3');
  var comparison =
      HybridCalculus.compareResults(compareExpr, 'x', 2, a: 0, b: 2);

  print('Comparison for x^3 at x=2 (Derivative) and [0, 2] (Integral):');
  print('Derivative Error: ${comparison['derivative']['error']}');
  print('Integral Error: ${comparison['integral']['error']}');
}
