import 'package:advance_math/src/math/algebra/expression/expression.dart';

void main() {
  final parser = ExpressionParser();
  final cases = [
    ['partfrac((3*x+2)/(x^2+x), x)', '(1+x)^(-1)+2*x^(-1)', true],
    ['partfrac((17*x-53)/(x^2-2*x-15), x)', '13*(3+x)^(-1)+4*(-5+x)^(-1)', false],
    ['partfrac((x^3+2)/(x+1)^2,x)', '(1+x)^(-2)+3*(1+x)^(-1)-2+x', false],
    ['partfrac(x/(x-1)^2, x)', '(-1+x)^(-1)+(-1+x)^(-2)', false],
    ['partfrac((x^2+1)/(x*(x-1)^3), x)', '(-1+x)^(-1)+2*(-1+x)^(-3)-x^(-1)', false],
    ['partfrac((17-53)/(x^2-2*x-15), x)', '(-9/2)*(-5+x)^(-1)+(9/2)*(3+x)^(-1)', false],
    ['partfrac(1/(x^6-1),x)', '(-1/3)*(-x+x^2+1)^(-1)+(-1/3)*(1+x+x^2)^(-1)+(-1/6)*(1+x)^(-1)+(-1/6)*(1+x+x^2)^(-1)*x+(1/6)*(-1+x)^(-1)+(1/6)*(-x+x^2+1)^(-1)*x', false],
    ['partfrac((3*x^2-3*x-8)/((x-5)*(x^2+x-4)),x)', '(-4+x+x^2)^(-1)*x+2*(-5+x)^(-1)', false],
    ['partfrac(15*(9+s^2)^(-1)*cos(1)+5*(9+s^2)^(-1)*s*sin(1),s)', '(15*cos(1)+5*s*sin(1))*(9+s^2)^(-1)', false]
  ];

  for (var c in cases) {
    final formula = c[0] as String;
    final expected = c[1] as String;
    final isEval = c[2] as bool;

    var parsed = parser.parse(formula);
    var actual = isEval ? parsed.evaluate().toString() : parsed.toString();
    print('Formula: $formula');
    print('  Expected: $expected');
    print('  Actual:   $actual');
    print('  Match:    ${actual == expected}');
  }
}
