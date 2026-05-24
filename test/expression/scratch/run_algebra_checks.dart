import 'package:advance_math/advance_math.dart';

void main() {
  var expression = ExpressionParser();

  // Test coeffs
  print('--- COEFFS ---');
  try {
    print("coeffs(x^2+2*x+1, x) -> ${expression.parse('coeffs(x^2+2*x+1, x)').toString()}");
    print("coeffs(a*b*x^2+c*x+d, x) -> ${expression.parse('coeffs(a*b*x^2+c*x+d, x)').toString()}");
    print("coeffs(t*x, x) -> ${expression.parse('coeffs(t*x, x)').toString()}");
    print("coeffs(b*(t*x-5), x) -> ${expression.parse('coeffs(b*(t*x-5), x)').toString()}");
    print("coeffs(a*x^2+b*x+c+x, x) -> ${expression.parse('coeffs(a*x^2+b*x+c+x, x)').toString()}");
    print("coeffs(x+A+1, x) -> ${expression.parse('coeffs(x+A+1, x)').toString()}");
    print("coeffs(2x+i*x+5, x) -> ${expression.parse('coeffs(2x+i*x+5, x)').toString()}");
  } catch (e) {
    print('Coeffs error: $e');
  }

  // Test line
  print('--- LINE ---');
  try {
    print("line([1,2], [3,4]) -> ${expression.parse('line([1,2], [3,4])').toString()}");
    print("line([a1,b1], [a2,b2], t) -> ${expression.parse('line([a1,b1], [a2,b2], t)').toString()}");
  } catch (e) {
    print('Line error: $e');
  }

  // Test sqcomp
  print('--- SQCOMP ---');
  try {
    print("sqcomp(a*x^2+b*x-11*c, x) -> ${expression.parse('sqcomp(a*x^2+b*x-11*c, x)').toString()}");
    print("sqcomp(9*x^2-18*x+17) -> ${expression.parse('sqcomp(9*x^2-18*x+17)').toString()}");
    print("sqcomp(s^2+s+1) -> ${expression.parse('sqcomp(s^2+s+1)').toString()}");
  } catch (e) {
    print('Sqcomp error: $e');
  }

  // Test simplify
  print('--- SIMPLIFY ---');
  final simplifies = [
    'simplify(sin(x)^2+cos(x)^2)',
    'simplify(1/2*sin(x^2)^2+cos(x^2)^2)',
    'simplify(0.75*sin(x^2)^2+cos(x^2)^2)',
    'simplify(cos(x)^2+sin(x)^2+cos(x)-tan(x)-1+sin(x^2)^2+cos(x^2)^2)',
    'simplify((x^2+4*x-45)/(x^2+x-30))',
    'simplify(1/(x-1)+1/(1-x))',
    'simplify((x-1)/(1-x))',
    'simplify((x^2+2*x+1)/(x+1))',
    'simplify((- x + x^2 + 1)/(x - x^2 - 1))',
    'simplify(n!/(n+1)!)',
    'simplify((17/2)*(-10+8*i)^(-1)-5*(-10+8*i)^(-1)*i)',
    'simplify((-2*i+7)^(-1)*(3*i+4))',
    'simplify(((17/2)*(-5*K+32)^(-1)*K^2+(5/2)*K-125*(-5*K+32)^(-1)*K-16+400*(-5*K+32)^(-1))*(-17*(-5*K+32)^(-1)*K+80*(-5*K+32)^(-1))^(-1))',
    'simplify(((a+b)^2)/c)',
    'simplify(-(-5*x - 9 + 2*y))',
    'simplify(a/b+b/a)',
    'simplify(((2*e^t)/(e^t))+(1/(e^t)))',
    'simplify((-3/2)x+(1/3)y+2+z)',
  ];

  for (var f in simplifies) {
    try {
      print("$f -> ${expression.parse(f).toString()}");
    } catch (e) {
      print("$f error: $e");
    }
  }
}
