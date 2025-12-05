import 'package:advance_math/advance_math.dart';
import 'package:test/test.dart';
import 'package:advance_math/src/math/algebra/expression/expression.dart';

void main() {
  group('Parser Calculus & Solver Comprehensive Tests', () {
    final parser = ExpressionParser();

    group('Differentiation Edge Cases (30 tests)', () {
      // 1-5: Basic Powers & Constants
      test('diff(x, x)',
          () => expect(parser.parse('diff(x, x)').toString(), equals('1')));
      test('diff(5, x)',
          () => expect(parser.parse('diff(5, x)').toString(), equals('0')));
      test(
          'diff(x^0, x)',
          () => expect(
              parser.parse('diff(x^0, x)').toString(), equals('0'))); // 1 -> 0
      test('diff(x^1, x)',
          () => expect(parser.parse('diff(x^1, x)').toString(), equals('1')));
      test(
          'diff(x^-1, x)',
          () => expect(parser.parse('diff(x^-1, x)').toString(),
              contains('-1 * (x^-2)')));

      // 6-10: Partial Differentiation
      test('diff(y, x)',
          () => expect(parser.parse('diff(y, x)').toString(), equals('0')));
      test('diff(x*y, x)',
          () => expect(parser.parse('diff(x*y, x)').toString(), contains('y')));
      test('diff(x*y, y)',
          () => expect(parser.parse('diff(x*y, y)').toString(), contains('x')));
      test(
          'diff(x^2*y^2, x)',
          () => expect(
              parser.parse('diff(x^2*y^2, x)').toString(), contains('2 * x')));
      test('diff(x+y, x)',
          () => expect(parser.parse('diff(x+y, x)').toString(), equals('1')));

      // 11-15: Trigonometric
      test(
          'diff(sin(x), x)',
          () => expect(
              parser.parse('diff(sin(x), x)').toString(), equals('cos(x)')));
      test(
          'diff(cos(x), x)',
          () => expect(
              parser.parse('diff(cos(x), x)').toString(), contains('sin(x)')));
      test(
          'diff(tan(x), x)',
          () => expect(parser.parse('diff(tan(x), x)').toString(),
              contains('sec(x)^2')));
      test(
          'diff(sin(2*x), x)',
          () => expect(parser.parse('diff(sin(2*x), x)').toString(),
              contains('cos((2 * x))')));
      test(
          'diff(cos(x^2), x)',
          () => expect(parser.parse('diff(cos(x^2), x)').toString(),
              contains('sin((x^2))')));

      // 16-20: Exponential & Logarithmic
      test(
          'diff(exp(x), x)',
          () => expect(
              parser.parse('diff(exp(x), x)').toString(), equals('exp(x)')));
      test(
          'diff(exp(2*x), x)',
          () => expect(parser.parse('diff(exp(2*x), x)').toString(),
              contains('exp((2 * x))')));
      test(
          'diff(ln(x), x)',
          () => expect(
              parser.parse('diff(ln(x), x)').toString(), contains('1 / x')));
      test(
          'diff(ln(x^2), x)',
          () => expect(parser.parse('diff(ln(x^2), x)').toString(),
              contains('x'))); // 2/x
      test(
          'diff(x*ln(x), x)',
          () => expect(parser.parse('diff(x*ln(x), x)').toString(),
              contains('ln(x)'))); // ln(x) + 1

      // 21-25: Chain Rule Depth
      test('diff(sin(cos(x)), x)', () {
        final res = parser.parse('diff(sin(cos(x)), x)').toString();
        expect(res, contains('cos(cos(x))'));
        expect(res, contains('sin(x)'));
      });
      test(
          'diff(exp(sin(x)), x)',
          () => expect(parser.parse('diff(exp(sin(x)), x)').toString(),
              contains('cos(x)')));
      test(
          'diff((x^2+1)^2, x)',
          () => expect(
              parser.parse('diff((x^2+1)^2, x)').toString(), contains('x')));
      test(
          'diff(sqrt(x), x)',
          () => expect(
              parser.parse('diff(x^0.5, x)').toString(), contains('x^-0.5')));
      test(
          'diff(1/x^2, x)',
          () => expect(
              parser.parse('diff(x^-2, x)').toString(), contains('x^-3')));

      // 26-30: Product & Quotient Rules
      test(
          'diff(x*x, x)',
          () => expect(
              parser.parse('diff(x*x, x)').toString(), contains('x'))); // 2x
      test(
          'diff(x/2, x)',
          () =>
              expect(parser.parse('diff(x/2, x)').toString(), contains('0.5')));
      test(
          'diff(sin(x)/cos(x), x)',
          () => expect(parser.parse('diff(sin(x)/cos(x), x)').toString(),
              contains('cos(x)^2'))); // sec^2(x)
      test(
          'diff(x*exp(x), x)',
          () => expect(parser.parse('diff(x*exp(x), x)').toString(),
              contains('exp(x)')));
      test(
          'diff(x*sin(x)*cos(x), x)',
          () => expect(parser.parse('diff(x*sin(x)*cos(x), x)').toString(),
              contains('cos(x)')));
    });

    group('Integration Edge Cases (40 tests)', () {
      // 31-35: Power Rule
      test(
          'integrate(x, x)',
          () => expect(
              parser.parse('integrate(x, x)').toString(), contains('x^2')));
      test(
          'integrate(x^2, x)',
          () => expect(
              parser.parse('integrate(x^2, x)').toString(), contains('x^3')));
      test(
          'integrate(1/x, x)',
          () => expect(
              parser.parse('integrate(1/x, x)').toString(), contains('ln(x)')));
      test(
          'integrate(x^-1, x)',
          () => expect(parser.parse('integrate(x^-1, x)').toString(),
              contains('ln(x)')));
      test(
          'integrate(x^-2, x)',
          () => expect(
              parser.parse('integrate(x^-2, x)').toString(), contains('x^-1')));

      // 36-40: Constants
      test(
          'integrate(0, x)',
          () => expect(parser.parse('integrate(0, x)').toString(),
              contains('0'))); // 0*x = 0
      test(
          'integrate(1, x)',
          () => expect(
              parser.parse('integrate(1, x)').toString(), contains('x')));
      test(
          'integrate(5, x)',
          () => expect(
              parser.parse('integrate(5, x)').toString(), contains('5 * x')));
      test(
          'integrate(pi, x)',
          () => expect(
              parser.parse('integrate(pi, x)').toString(), contains('pi * x')));
      test(
          'integrate(y, x)',
          () => expect(
              parser.parse('integrate(y, x)').toString(), contains('y * x')));

      // 41-45: Trigonometric
      test(
          'integrate(sin(x), x)',
          () => expect(parser.parse('integrate(sin(x), x)').toString(),
              contains('cos(x)')));
      test(
          'integrate(cos(x), x)',
          () => expect(parser.parse('integrate(cos(x), x)').toString(),
              contains('sin(x)')));
      test(
          'integrate(sec(x)^2, x)',
          () => expect(parser.parse('integrate(sec(x)^2, x)').toString(),
              contains('tan(x)')));
      test(
          'integrate(csc(x)^2, x)',
          () => expect(parser.parse('integrate(csc(x)^2, x)').toString(),
              contains('cot(x)')));
      test(
          'integrate(sin(x)+cos(x), x)',
          () => expect(parser.parse('integrate(sin(x)+cos(x), x)').toString(),
              contains('sin(x)')));

      // 46-50: Exponential
      test(
          'integrate(exp(x), x)',
          () => expect(parser.parse('integrate(exp(x), x)').toString(),
              contains('exp(x)')));
      test(
          'integrate(2^x, x)',
          () => expect(
              parser.parse('integrate(2^x, x)').toString(), contains('2^x')));
      test(
          'integrate(exp(x)+x, x)',
          () => expect(parser.parse('integrate(exp(x)+x, x)').toString(),
              contains('exp(x)')));
      test(
          'integrate(exp(x)+1, x)',
          () => expect(parser.parse('integrate(exp(x)+1, x)').toString(),
              contains('x')));
      test(
          'integrate(exp(x)-exp(x), x)',
          () => expect(parser.parse('integrate(exp(x)-exp(x), x)').toString(),
              contains('0')));

      // 51-55: Substitution (Linear)
      test(
          'integrate(sin(2*x), x)',
          () => expect(parser.parse('integrate(sin(2*x), x)').toString(),
              contains('cos((2 * x))'))); // -0.5*cos(2x) - requires sub
      test(
          'integrate(exp(3*x), x)',
          () => expect(parser.parse('integrate(exp(3*x), x)').toString(),
              contains('exp((3 * x))')));
      test(
          'integrate(cos(x/2), x)',
          () => expect(parser.parse('integrate(cos(x/2), x)').toString(),
              contains('sin((x / 2))')));
      test(
          'integrate((2*x+1)^2, x)',
          () => expect(parser.parse('integrate((2*x+1)^2, x)').toString(),
              contains('(2 * x)')));
      test(
          'integrate(1/(2*x), x)',
          () => expect(parser.parse('integrate(1/(2*x), x)').toString(),
              contains('ln((2 * x))')));

      // 56-60: Substitution (Non-linear)
      test(
          'integrate(2*x*sin(x^2), x)',
          () => expect(parser.parse('integrate(2*x*sin(x^2), x)').toString(),
              contains('cos((x^2))')));
      test(
          'integrate(x*exp(x^2), x)',
          () => expect(parser.parse('integrate(x*exp(x^2), x)').toString(),
              contains('exp((x^2))')));
      test(
          'integrate(cos(x)*sin(x), x)',
          () => expect(parser.parse('integrate(cos(x)*sin(x), x)').toString(),
              contains('sin(x)'))); // sin^2/2 or -cos^2/2
      test(
          'integrate(x^2*cos(x^3), x)',
          () => expect(parser.parse('integrate(x^2*cos(x^3), x)').toString(),
              contains('sin((x^3))')));
      test(
          'integrate(exp(sin(x))*cos(x), x)',
          () => expect(
              parser.parse('integrate(exp(sin(x))*cos(x), x)').toString(),
              contains('exp(sin(x))')));

      // 61-65: Integration by Parts
      test(
          'integrate(x*exp(x), x)',
          () => expect(parser.parse('integrate(x*exp(x), x)').toString(),
              contains('x * exp(x)')));
      test(
          'integrate(x*sin(x), x)',
          () => expect(parser.parse('integrate(x*sin(x), x)').toString(),
              contains('x * cos(x)')));
      test(
          'integrate(x*cos(x), x)',
          () => expect(parser.parse('integrate(x*cos(x), x)').toString(),
              contains('x * sin(x)')));
      test(
          'integrate(ln(x), x)',
          () => expect(parser.parse('integrate(ln(x), x)').toString(),
              contains('x * ln(x)'))); // x*ln(x) - x
      test(
          'integrate(x^2*exp(x), x)',
          () => expect(parser.parse('integrate(x^2*exp(x), x)').toString(),
              contains('x^2')));

      // 66-70: Definite Integrals (Simulated via FTC)
      test(
          'diff(integrate(x^2, x), x)',
          () => expect(parser.parse('diff(integrate(x^2, x), x)').toString(),
              contains('x^2')));
      test(
          'integrate(diff(sin(x), x), x)',
          () => expect(parser.parse('integrate(diff(sin(x), x), x)').toString(),
              contains('sin(x)')));
      test(
          'integrate(1/(x+1), x)',
          () => expect(parser.parse('integrate(1/(x+1), x)').toString(),
              contains('ln((x + 1))')));
      test(
          'integrate(x/(x^2+1), x)',
          () => expect(parser.parse('integrate(x/(x^2+1), x)').toString(),
              contains('ln(((x^2) + 1))')));
      test(
          'integrate(tan(x), x)',
          () => expect(parser.parse('integrate(tan(x), x)').toString(),
              contains('ln(cos(x))'))); // -ln|cos(x)|
    });

    group('Solver Edge Cases (30 tests)', () {
      // 71-75: Linear Equations
      test(
          'solve(x - 5, x)',
          () => expect(
              parser.parse('solve(x - 5, x)').toString(), contains('5')));
      test(
          'solve(2*x - 10, x)',
          () => expect(
              parser.parse('solve(2*x - 10, x)').toString(), contains('5')));
      test(
          'solve(x + x - 10, x)',
          () => expect(
              parser.parse('solve(x + x - 10, x)').toString(), contains('5')));
      test(
          'solve(3*x + 2*x - 25, x)',
          () => expect(parser.parse('solve(3*x + 2*x - 25, x)').toString(),
              contains('5')));
      test(
          'solve(x/2 - 5, x)',
          () => expect(
              parser.parse('solve(x/2 - 5, x)').toString(), contains('10')));

      // 76-80: Quadratic Equations
      test('solve(x^2 - 9, x)', () {
        final res = parser.parse('solve(x^2 - 9, x)').toString();
        expect(res, contains('3'));
        expect(res, contains('-3'));
      });
      test(
          'solve(x^2 - 2, x)',
          () => expect(
              parser.parse('solve(x^2 - 2, x)').toString(), contains('1.414')));
      test(
          'solve(2*x^2 - 8, x)',
          () => expect(
              parser.parse('solve(2*x^2 - 8, x)').toString(), contains('2')));
      test(
          'solve(x^2 + 4*x + 4, x)',
          () => expect(parser.parse('solve(x^2 + 4*x + 4, x)').toString(),
              contains('-2')));
      test('solve(x^2 - 5*x + 6, x)', () {
        final res = parser.parse('solve(x^2 - 5*x + 6, x)').toString();
        expect(res, contains('2'));
        expect(res, contains('3'));
      });

      // 81-85: No Solution / Infinite (Handling)
      test(
          'solve(x^2 + 1, x)',
          () => expect(parser.parse('solve(x^2 + 1, x)').toString(),
              equals('[]'))); // No real roots
      test(
          'solve(0*x - 5, x)',
          () => expect(() => parser.parse('solve(0*x - 5, x)'),
              throwsA(isA<UnimplementedError>())));
      test(
          'solve(1, x)',
          () => expect(() => parser.parse('solve(1, x)'),
              throwsA(isA<UnimplementedError>())));
      test(
          'solve(x-x, x)',
          () => expect(
              parser.parse('solve(x-x, x)').toString(),
              contains(
                  '0'))); // 0=0, all x? currently might return 0 literal or [] depending on impl
      test(
          'solve(x^2 + 4, x)',
          () => expect(
              parser.parse('solve(x^2 + 4, x)').toString(), equals('[]')));

      // 86-90: Variable Isolation
      test(
          'solve(x + y, x)',
          () => expect(parser.parse('solve(x + y, x)').toString(),
              contains('y'))); // x = -y
      test(
          'solve(x - y, x)',
          () => expect(
              parser.parse('solve(x - y, x)').toString(), contains('y')));
      test(
          'solve(a*x - b, x)',
          () => expect(parser.parse('solve(a*x - b, x)').toString(),
              contains('b'))); // b/a
      test(
          'solve(x/a - b, x)',
          () => expect(parser.parse('solve(x/a - b, x)').toString(),
              contains('b'))); // b*a
      test(
          'solve(x + a + b, x)',
          () => expect(parser.parse('solve(x + a + b, x)').toString(),
              contains('a'))); // -a-b

      // 91-95: Complex Expressions
      test(
          'solve((x-1)*(x-2), x)',
          () => expect(parser.parse('solve((x-1)*(x-2), x)').toString(),
              contains('1'))); // Should expand and solve
      test(
          'solve(x^2 - x, x)',
          () => expect(parser.parse('solve(x^2 - x, x)').toString(),
              contains('1'))); // 0, 1
      test(
          'solve(x^3, x)',
          () =>
              expect(parser.parse('solve(x^3, x)').toString(), contains('0')));
      test(
          'solve(x^2 - 2*x + 1, x)',
          () => expect(
              parser.parse('solve(x^2 - 2*x + 1, x)').evaluate().toString(),
              contains('1')));
      test(
          'solve(x^2 + 2*x + 1 - 4, x)',
          () => expect(parser.parse('solve(x^2 + 2*x - 3, x)').toString(),
              contains('1'))); // (x+3)(x-1) -> -3, 1

      // 96-100: Robustness
      test('solve(x, x)',
          () => expect(parser.parse('solve(x, x)').toString(), contains('0')));
      test('solve(-x, x)',
          () => expect(parser.parse('solve(-x, x)').toString(), contains('0')));
      test(
          'solve(x + 0, x)',
          () => expect(
              parser.parse('solve(x + 0, x)').toString(), contains('0')));
      test(
          'solve(x * 1, x)',
          () => expect(
              parser.parse('solve(x * 1, x)').toString(), contains('0')));
      test(
          'solve(x - x + 5, x)',
          () => expect(() => parser.parse('solve(x - x + 5, x)'),
              throwsA(isA<UnimplementedError>())));
    });
  });
}
