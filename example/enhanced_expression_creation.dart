import 'package:advance_math/advance_math.dart';

/// Comprehensive examples demonstrating enhanced expression creation methods.
/// This example showcases all three approaches for creating expressions with
/// numeric literals and provides guidance on when to use each method.
void main() {
  print('=== Enhanced Expression Creation Examples ===\n');

  basicExpressionCreation();
  complexMathematicalExpressions();
  calculusOperations();
  troubleshootingExamples();
  performanceComparison();
  migrationExamples();
}

/// Demonstrates the three basic approaches for creating expressions with literals.
void basicExpressionCreation() {
  print('1. Basic Expression Creation Methods\n');

  final x = Variable('x');
  final y = Variable('y');

  // Method 1: Explicit Literal objects (traditional, always works)
  print('Method 1: Explicit Literal Objects');
  final expr1 = Literal(2) * x + Literal(3);
  print('  Code: Literal(2) * x + Literal(3)');
  print('  Result: $expr1');
  print('  Evaluated at x=5: ${expr1.evaluate({'x': 5})}');
  print('');

  // Method 2: Extension method toExpression()
  print('Method 2: Extension Method toExpression()');
  final expr2 = 2.toExpression() * x + 3.toExpression();
  print('  Code: 2.toExpression() * x + 3.toExpression()');
  print('  Result: $expr2');
  print('  Evaluated at x=5: ${expr2.evaluate({'x': 5})}');
  print('');

  // Method 3: Helper function ex()
  print('Method 3: Helper Function ex()');
  final expr3 = ex(2) * x + ex(3);
  print('  Code: ex(2) * x + ex(3)');
  print('  Result: $expr3');
  print('  Evaluated at x=5: ${expr3.evaluate({'x': 5})}');
  print('');

  // Mixed approach (recommended for complex expressions)
  print('Method 4: Mixed Approach (Recommended)');
  final expr4 = 2.toExpression() * x + ex(3) * y - Literal(1);
  print('  Code: 2.toExpression() * x + ex(3) * y - Literal(1)');
  print('  Result: $expr4');
  print('  Evaluated: ${expr4.evaluate({'x': 5, 'y': 2})}');
  print('');

  print('All methods produce equivalent results and are interchangeable.\n');
  print('${'=' * 60}\n');
}

/// Shows complex mathematical expressions using enhanced creation methods.
void complexMathematicalExpressions() {
  print('2. Complex Mathematical Expressions\n');

  final x = Variable('x');
  final y = Variable('y');
  final z = Variable('z');

  // Polynomial expressions
  print('Polynomial Expressions:');
  final polynomial = 3.toExpression() * (x ^ ex(4)) -
      2.toExpression() * (x ^ ex(3)) +
      ex(5) * (x ^ ex(2)) -
      7.toExpression() * x +
      Literal(11);
  print('  P(x) = 3x⁴ - 2x³ + 5x² - 7x + 11');
  print(
      '  Code: 3.toExpression() * (x ^ ex(4)) - 2.toExpression() * (x ^ ex(3)) + ...');
  print('  Expression: $polynomial');
  print('  P(2) = ${polynomial.evaluate({'x': 2})}');
  print('');

  // Multivariate expressions
  print('Multivariate Expressions:');
  final multivar = ex(2) * x * y * z +
      3.toExpression() * (x ^ ex(2)) * y -
      Literal(4) * x * (z ^ ex(2)) +
      ex(5) * y * z -
      6.toExpression();
  print('  f(x,y,z) = 2xyz + 3x²y - 4xz² + 5yz - 6');
  print('  Expression: $multivar');
  print('  f(1,2,3) = ${multivar.evaluate({'x': 1, 'y': 2, 'z': 3})}');
  print('');

  // Rational expressions
  print('Rational Expressions:');
  final numerator = (x ^ ex(2)) + 2.toExpression() * x + ex(1);
  final denominator = x - ex(1);
  final rational = numerator / denominator;
  print('  R(x) = (x² + 2x + 1) / (x - 1)');
  print('  Numerator: $numerator');
  print('  Denominator: $denominator');
  print('  Rational: $rational');
  print('  R(3) = ${rational.evaluate({'x': 3})}');
  print('');

  // Trigonometric expressions
  print('Trigonometric Expressions:');
  final trigExpr = Sin(2.toExpression() * x) + Cos(ex(3) * x) * Tan(x / ex(2));
  print('  T(x) = sin(2x) + cos(3x) * tan(x/2)');
  print('  Expression: $trigExpr');
  print('');

  // Exponential and logarithmic expressions
  print('Exponential and Logarithmic Expressions:');
  final expLogExpr =
      Exp(2.toExpression() * x) + Ln((x ^ ex(2)) + ex(1)) - Log.base10(x);
  print('  E(x) = e^(2x) + ln(x² + 1) - log₁₀(x)');
  print('  Expression: $expLogExpr');
  print('');

  print('${'=' * 60}\n');
}

/// Demonstrates calculus operations with enhanced expression creation.
void calculusOperations() {
  print('3. Calculus Operations\n');

  final x = Variable('x');

  // Differentiation examples
  print('Differentiation:');
  final func1 =
      (x ^ ex(3)) + 2.toExpression() * (x ^ ex(2)) - ex(5) * x + ex(7);
  print('  f(x) = x³ + 2x² - 5x + 7');
  print('  f\'(x) = ${func1.differentiate()}');
  print('');

  final func2 = Sin(2.toExpression() * x) * Cos(ex(3) * x);
  print('  g(x) = sin(2x) * cos(3x)');
  print('  g\'(x) = ${func2.differentiate()}');
  print('');

  // Integration examples
  print('Integration:');
  final integrand1 =
      6.toExpression() * (x ^ ex(2)) + 4.toExpression() * x - ex(3);
  print('  ∫(6x² + 4x - 3)dx = ${integrand1.integrate()}');
  print('');

  final integrand2 = Sin(x) + Cos(2.toExpression() * x);
  print('  ∫(sin(x) + cos(2x))dx = ${integrand2.integrate()}');
  print('');

  // Chain rule examples
  print('Chain Rule Examples:');
  final chainFunc = Sin((x ^ ex(2)) + ex(1));
  print('  h(x) = sin(x² + 1)');
  print('  h\'(x) = ${chainFunc.differentiate()}');
  print('');

  // Product rule examples
  print('Product Rule Examples:');
  final productFunc = (x ^ ex(2)) * Exp(x);
  print('  p(x) = x² * e^x');
  print('  p\'(x) = ${productFunc.differentiate()}');
  print('');

  print('${'=' * 60}\n');
}

/// Shows common troubleshooting scenarios and their solutions.
void troubleshootingExamples() {
  print('4. Troubleshooting Common Issues\n');

  final x = Variable('x');

  print('Problem: Type inference errors with numeric literals\n');

  // This would cause a type error in older versions:
  // final expr = 2 + x; // Error: A value of type 'num' can't be assigned...

  print('❌ Problematic code (would cause type error):');
  print('  final expr = 2 + x; // Type error!');
  print('');

  print('✅ Solutions:');
  print('  Solution 1: Use toExpression()');
  print('    final expr = 2.toExpression() + x;');
  final solution1 = 2.toExpression() + x;
  print('    Result: $solution1');
  print('');

  print('  Solution 2: Use ex() helper');
  print('    final expr = ex(2) + x;');
  final solution2 = ex(2) + x;
  print('    Result: $solution2');
  print('');

  print('  Solution 3: Use explicit Literal');
  print('    final expr = Literal(2) + x;');
  final solution3 = Literal(2) + x;
  print('    Result: $solution3');
  print('');

  print('Problem: Mixed numeric types in expressions\n');
  print('✅ All numeric types work seamlessly:');
  final intExpr = 5.toExpression() * x;
  final doubleExpr = 3.14.toExpression() * x;
  final negativeExpr = (-2).toExpression() * x;
  print('  Integer: ${intExpr.evaluate({'x': 2})}');
  print('  Double: ${doubleExpr.evaluate({'x': 2})}');
  print('  Negative: ${negativeExpr.evaluate({'x': 2})}');
  print('');

  print('Problem: Complex nested expressions\n');
  print('✅ Use parentheses and mixed approaches:');
  final complex =
      ((2.toExpression() * x + ex(1)) ^ ex(2)) * (ex(3) * x - Literal(4));
  print(
      '  Code: ((2.toExpression() * x + ex(1)) ^ ex(2)) * (ex(3) * x - Literal(4))');
  print('  Result: $complex');
  print('  Evaluated at x=2: ${complex.evaluate({'x': 2})}');
  print('');

  print('${'=' * 60}\n');
}

/// Compares performance and usage patterns of different methods.
void performanceComparison() {
  print('5. Performance and Usage Guidelines\n');

  final x = Variable('x');

  print('Performance: All methods create equivalent Expression objects');
  final literal = Literal(5) * x;
  final extension = 5.toExpression() * x;
  final helper = ex(5) * x;

  print('  Literal(5) * x: ${literal.runtimeType}');
  print('  5.toExpression() * x: ${extension.runtimeType}');
  print('  ex(5) * x: ${helper.runtimeType}');
  print('  All evaluate to: ${literal.evaluate({'x': 3})}');
  print('');

  print('Usage Guidelines:');
  print('  📝 For simple expressions: Use ex() helper');
  print('    Example: ex(2) * x + ex(3)');
  print('');

  print('  🔗 For fluent APIs: Use toExpression()');
  print('    Example: 2.toExpression() * x + 3.toExpression()');
  print('');

  print('  🎯 For explicit control: Use Literal()');
  print('    Example: Literal(2) * x + Literal(3)');
  print('');

  print('  🎨 For complex expressions: Mix approaches');
  print('    Example: 2.toExpression() * x + ex(3) * y - Literal(1)');
  print('');

  print('Memory Usage: All methods have identical memory footprint');
  print('Execution Speed: No measurable performance difference');
  print('');

  print('${'=' * 60}\n');
}

/// Shows migration patterns from older code to enhanced methods.
void migrationExamples() {
  print('6. Migration Examples\n');

  final x = Variable('x');
  final y = Variable('y');

  print('Migrating from verbose Literal usage:');
  print('');

  print('❌ Old verbose approach:');
  print('  Add(Multiply(Literal(2), x), Literal(3))');
  final oldWay = Add(Multiply(Literal(2), x), Literal(3));
  print('  Result: $oldWay');
  print('');

  print('✅ New concise approaches:');
  print('  2.toExpression() * x + ex(3)');
  final newWay1 = 2.toExpression() * x + ex(3);
  print('  Result: $newWay1');
  print('');

  print('  ex(2) * x + ex(3)');
  final newWay2 = ex(2) * x + ex(3);
  print('  Result: $newWay2');
  print('');

  print('Complex migration example:');
  print('');

  print('❌ Old complex expression:');
  print('  Add(');
  print('    Multiply(Literal(3), Pow(x, Literal(2))),');
  print('    Subtract(');
  print('      Multiply(Literal(2), y),');
  print('      Literal(5)');
  print('    )');
  print('  )');
  final oldComplex = Add(Multiply(Literal(3), Pow(x, Literal(2))),
      Subtract(Multiply(Literal(2), y), Literal(5)));
  print('  Result: $oldComplex');
  print('');

  print('✅ New readable expression:');
  print('  ex(3) * (x ^ ex(2)) + (2.toExpression() * y - ex(5))');
  final newComplex = ex(3) * (x ^ ex(2)) + (2.toExpression() * y - ex(5));
  print('  Result: $newComplex');
  print('');

  print('Both evaluate to the same result:');
  final context = {'x': 2, 'y': 3};
  print('  Old way: ${oldComplex.evaluate(context)}');
  print('  New way: ${newComplex.evaluate(context)}');
  print('');

  print('Migration is completely backward compatible!');
  print('You can migrate incrementally without breaking existing code.');
  print('');

  print('${'=' * 60}\n');
}
