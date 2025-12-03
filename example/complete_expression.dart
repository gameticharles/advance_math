import 'package:advance_math/advance_math.dart';

/// Complete Expression Examples
///
/// This file demonstrates all expression parsing and evaluation capabilities
/// by showcasing examples from the test suite organized by category.
///
/// Run this file to see all expression parsing features in action:
/// ```
/// dart run example/complete_expression.dart
/// ```

void main() {
  printHeader('COMPLETE EXPRESSION EXAMPLES');

  // 1. Basic Arithmetic & Parsing
  basicArithmeticExamples();

  // 2. Algebraic Operations
  algebraExamples();

  // 3. Calculus Operations
  calculusExamples();

  // 4. Equation Solving
  solvingExamples();

  // 5. Advanced Features
  advancedExamples();

  print('\n${'=' * 80}');
  print('All examples completed successfully!');
  print('=' * 80);
}

// ============================================================================
// Helper Functions
// ============================================================================

void printHeader(String title) {
  print('\n${'=' * 80}');
  print(title.padLeft((80 + title.length) ~/ 2));
  print('=' * 80);
}

void printSection(String title) {
  print('\n${'-' * 80}');
  print(title);
  print('-' * 80);
}

void demo(String expression, {String? description}) {
  try {
    var parsed = Expression.parse(expression);
    var result = parsed.simplify();
    var desc = description ?? expression;
    print('  $desc');
    print('  => $result');
  } catch (e) {
    print('  $expression');
    print('  => ERROR: $e');
  }
}

void demoEval(String expression, {String? description}) {
  try {
    var parsed = Expression.parse(expression);
    var result = parsed.evaluate();
    var desc = description ?? expression;
    print('  $desc');
    print('  => $result');
  } catch (e) {
    print('  $expression');
    print('  => ERROR: $e');
  }
}

// ============================================================================
// 1. Basic Arithmetic & Parsing
// ============================================================================

void basicArithmeticExamples() {
  printHeader('1. BASIC ARITHMETIC & PARSING');

  printSection('Simple Arithmetic');
  demoEval('1+1', description: '1 + 1');
  demoEval('4^2', description: '4²');
  demoEval('2*-4', description: '2 × (-4)');
  demoEval('2+(3/4)', description: '2 + 3/4');
  demoEval('2/3+2/3', description: '2/3 + 2/3');
  demoEval('6.5*2', description: '6.5 × 2');

  printSection('Parentheses & Precedence');
  demoEval('((((((1+1))))))');
  demoEval('((((((1+1))+4)))+3)');
  demoEval('(2 + 3)! ', description: '(2 + 3)!');
  demoEval('1 + 2 * 3', description: 'Order of operations');
  demoEval('(1 + 2) * 3', description: 'Parentheses override order');

  printSection('Negative Numbers');
  demoEval('0-4');
  demoEval('-(4)');
  demoEval('3*-(4)');
  demoEval('1 - -2', description: 'Double negative');

  printSection('Implicit Multiplication (requires explicit *)');
  demo('2*x', description: '2 × x');
  demo('sin(2*x)', description: 'sin(2x)');
  demo('2*sin(x) + 4*sin(x)', description: 'Combining like terms');
  demo('sin(x) + sin(x)');

  printSection('Complex Expressions');
  // Note: sqrt, cbrt, log10, ln are in defaultContext but don't work through Expression.parse
  // They're treated as Variables, not callable functions during parsing
  demoEval('abs(-5)', description: 'abs(-5) - abs() works!');
  demoEval('2^3 + 3^2', description: 'Exponentiation');
  demoEval('(1+2)*(3+4)', description: 'Nested parentheses');
}

// ============================================================================
// 2. Algebraic Operations
// ============================================================================

void algebraExamples() {
  printHeader('2. ALGEBRAIC OPERATIONS');

  printSection('GCD (Greatest Common Divisor)');
  demo('gcd(18, 12, 6)', description: 'GCD of integers');
  demo('gcd(x^2+2*x+1, x+1)', description: 'GCD of polynomials');
  demo('gcd(2*x^2+8*x+5, 6*x^9+24*x^8+15*x^7+6*x^2+24*x+15)');
  demo('gcd(1/2, 1/3, 1/4)', description: 'GCD of fractions');

  printSection('LCM (Least Common Multiple)');
  demoEval('lcm(18, 12, 6)', description: 'LCM of integers');
  demoEval('lcm(3, 5, 7)');
  demo('lcm(x^2+2*x+1, x+1)', description: 'LCM of polynomials');
  demoEval('lcm(1/2, 1/3, 1/4)', description: 'LCM of fractions');

  printSection('Factorization');
  demo('factor(x^2+2*x+1)', description: 'Factor perfect square');
  demo('factor(x^2-y^2)', description: 'Difference of squares');
  demo('factor(x^16-1)', description: 'Difference of powers');
  demo('factor(100)', description: 'Prime factorization of integer');
  demo('factor(64*x^3+125)', description: 'Sum of cubes');

  printSection('Prime Factorization');
  demo('pfactor(100)', description: 'Prime factors of 100');
  demo('pfactor(8)', description: 'Prime factors of 8');
  demo('pfactor(999999999999)', description: 'Large number prime factors');

  printSection('Polynomial Degree');
  demo('deg(x^2+2*x+x^5)', description: 'Degree of polynomial');
  demo('deg(x^2+2*x+cos(x))', description: 'Mixed polynomial');
  demo('deg(a*x^2+b*x+c, x)', description: 'Degree with respect to x');

  printSection('Coefficient Extraction');
  demo('coeffs(x^2+2*x+1, x)', description: 'Get coefficients');
  demo('coeffs(a*b*x^2+c*x+d, x)');
  demo('coeffs(t*x, x)');

  printSection('Polynomial Roots (Future Feature)');
  print(
      '  roots() => (Function signature issue - needs direct Polynomial API call)');
  print('  Use: Polynomial.fromString("x^2+2*x+1").roots() instead');

  printSection('Complete the Square (Future Feature)');
  print('  sqcomp(9*x^2-18*x+17) => (Not yet implemented)');
  print('  sqcomp(s^2+s+1) => (Not yet implemented)');

  printSection('Polynomial Division (Future Feature)');
  print(
      '  div(x^2*y^3+b*y^2+3*a*x^2*y+3*a*b, y^2+3*a) => (Returns expression, not simplified)');
  print('  div(2*x^2+2*x+1, x+1) => (Returns expression, not simplified)');

  printSection('Simplification');
  demo('simplify(sin(x)^2+cos(x)^2)', description: 'Trig identity');
  demo('simplify((x^2+4*x-45)/(x^2+x-30))',
      description: 'Rational simplification');
  demo('simplify(1/(x-1)+1/(1-x))', description: 'Combine fractions');
  demo('simplify((x-1)/(1-x))', description: 'Factor and cancel');
}

// ============================================================================
// 3. Calculus Operations
// ============================================================================

void calculusExamples() {
  printHeader('3. CALCULUS OPERATIONS');

  printSection('Differentiation - Basic');
  demo('diff(x^2, x)', description: 'd/dx(x²)');
  demo('diff(2*x^2+4, x)', description: 'd/dx(2x² + 4)');
  demo('diff(x^(1/2)*x, x)', description: 'd/dx(x^(1/2) · x)');
  demo('diff(e^x, x)', description: 'd/dx(eˣ)');

  printSection('Differentiation - Trigonometric');
  demo('diff(cos(x), x)', description: 'd/dx(cos x)');
  demo('diff(sin(x), x)', description: 'd/dx(sin x)');
  demo('diff(tan(x), x)', description: 'd/dx(tan x)');
  demo('diff(4*tan(x)*sec(x), x)');

  printSection('Differentiation - Product & Chain Rule');
  demo('diff(x*cos(x), x)', description: 'Product rule');
  demo('diff(cos(2*x), x)', description: 'Chain rule');
  demo('diff(sin(x^2)^cos(x), x)', description: 'Complex composition');

  printSection('Integration - Power Rule');
  demo('integrate(x^2, x)', description: '∫ x² dx');
  demo('integrate(2*x^2+x, x)', description: '∫ (2x² + x) dx');
  // Note: sqrt not yet fully supported in integration
  print('  ∫ √x dx => (Future: symbolic sqrt integration)');

  printSection('Integration - Trigonometric');
  demo('integrate(sin(x), x)', description: '∫ sin x dx');
  demo('integrate(cos(x), x)', description: '∫ cos x dx');
  demo('integrate(sec(x)^2, x)', description: '∫ sec² x dx');
  // Note: product of trig not yet supported
  print('  ∫ cos x sin x dx => (Future: trig product integration)');

  printSection('Integration - Exponential & Logarithmic');
  print('  ∫ eˣ dx => (Future: exponential integration)');
  print('  ∫ ln x dx => (Future: integration by parts)');
  demo('integrate(a/x, x)', description: '∫ a/x dx');

  printSection('Integration - By Parts (Future Feature)');
  print('  ∫ x eˣ dx => (Not yet implemented)');
  print('  ∫ x³ ln x dx => (Not yet implemented)');
  print('  ∫ x² sin x dx => (Not yet implemented)');

  printSection('Integration - Substitution');
  demo('integrate(1/(a^2+x^2), x)', description: '∫ 1/(a² + x²) dx');
  print('  ∫ x/(x+a)² dx => (Not yet implemented)');

  printSection('Limits (Unevaluated)');
  demo('limit((2-2*x^2)/(x-1), x, 1)',
      description: 'lim(x→1) (returns expression)');
  demo('limit(tan(3*x)/tan(x), x, pi/2)');

  printSection('Summation (Unevaluated)');
  demo('sum(x+y, x, 0, 3)',
      description: 'Σ(x+y) from x=0 to 3 (returns expression)');
  demo('sum(x^2+x, x, 0, 10)', description: 'Σ(x²+x) from x=0 to 10');
}

// ============================================================================
// 4. Equation Solving
// ============================================================================

void solvingExamples() {
  printHeader('4. EQUATION SOLVING');

  printSection('Linear Equations');
  demoEval('solve(x+1=5, x)', description: 'x + 1 = 5');
  demoEval('solve(2*x-4=0, x)', description: '2x - 4 = 0');
  demoEval('solve(x/2+1=3, x)', description: 'x/2 + 1 = 3');
  demoEval('solve(a*x+b=0, x)', description: 'ax + b = 0');

  printSection('Quadratic Equations');
  demoEval('solve(x^2-1=0, x)', description: 'x² - 1 = 0');
  demoEval('solve(x^2+2*x+1=0, x)', description: 'x² + 2x + 1 = 0');
  // Complex roots not yet fully supported in solve
  print('  x² + 1 = 0 => (Complex roots - future feature)');
  print('  Quadratic formula => (General solve - future feature)');

  printSection('Cubic Equations');
  demoEval('solve(x^3=0, x)', description: 'x³ = 0');
  // General cubic solving not yet implemented
  print('  Cubic equations => (General cubic solver - future feature)');

  printSection('Factored Equations');
  demoEval('solve((x-1)*(x-2)=0, x)', description: '(x-1)(x-2) = 0');
  demoEval('solve(x*(x+3)=0, x)', description: 'x(x+3) = 0');
  // Some factored equations not working
  print('  3(x+5)(x-4) = 0 => (Solver needs improvement)');

  printSection('Equations with Special Functions (Future Features)');
  print('  √x - 1 = 0 => (Not yet implemented)');
  print('  √(x²-1) = 0 => (Not yet implemented)');
  print('  x ln x = 0 => (Not yet implemented)');

  printSection('Systems of Equations (Future Feature)');
  print('  Systems of equations => (Solver needs improvement)');
  print(
      '  solveEquations(["x+y=1", "x-y=1"]) => (Returns empty array - needs fix)');
}

// ============================================================================
// 5. Advanced Features
// ============================================================================

void advancedExamples() {
  printHeader('5. ADVANCED FEATURES');

  printSection('Hyperbolic Functions');
  demo('cosh(x)', description: 'Hyperbolic cosine');
  demo('sinh(x)', description: 'Hyperbolic sine');
  demo('tanh(x)', description: 'Hyperbolic tangent');
  demo('2*cosh(x)+cosh(x)', description: 'Combining hyperbolic terms');
  demo('cosh(x)*cosh(x)', description: 'cosh² x');
  demo('y*tanh(x)*tanh(x)', description: 'y tanh² x');

  printSection('Inverse Trigonometric Functions (Future Features)');
  print('  ∫ asin(ax) dx => (Not yet implemented)');

  printSection('Complex Numbers');
  demo('gcd(-20+16*i, -10+8*i)', description: 'GCD of complex numbers');
  demo('lcm(-20+16*i, -10+8*i)', description: 'LCM of complex numbers');
  // Complex roots not yet fully supported
  print('  x² + 1 = 0 (complex roots) => (Returns empty array - needs fix)');

  printSection('Partial Fractions (Future Features)');
  print('  partfrac((3*x+2)/(x²+x), x) => (Not yet implemented)');
  print('  Partial fraction decomposition => (Future feature)');

  printSection('Special Functions & Constants');
  demoEval('pi', description: 'π constant');
  demoEval('e', description: 'e constant');
  // Note: factorial is in defaultContext but needs to be called with context parameter
  print('  factorial(5) => 120 (requires context parameter in evaluate)');
  demoEval('5C3', description: '5 choose 3 - combination operator');
  demoEval('5P3', description: '5 permute 3 - permutation operator');

  printSection('Trigonometric Identities');
  demo('simplify(sin(x)^2+cos(x)^2)', description: 'Pythagorean identity');
  demo('simplify(1/2*sin(x^2)^2+cos(x^2)^2)', description: 'Half-angle form');
  demo('simplify(tan(x)*csc(x))', description: 'Simplify trig expression');

  printSection('Matrix & Vector Operations (if supported)');
  // These would require matrix/vector expression support
  print('  (Matrix operations through Expression parser - future feature)');

  printSection('Conditional Expressions');
  demoEval('4 > 2 ? "bigger" : "smaller"', description: 'Ternary operator');
  demoEval('2 == 2 ? true : false', description: 'Equality check');
  demoEval('2 != 2 ? true : false', description: 'Inequality check');
}
