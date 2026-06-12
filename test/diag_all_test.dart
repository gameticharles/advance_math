import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void check(String expr, String expected) {
  try {
    var e = Expression.parse(expr);
    var r = e.evaluate();
    String got = r.toString();
    String status = got == expected ? '✓' : '✗';
    print('$status  $expr\n     exp: $expected\n     got: $got\n');
  } catch (err) {
    print('✗  $expr\n     ERROR: $err\n');
  }
}

void main() {
  test('all', () {
    print('\n=== Forward Laplace (new) ===');
    check('laplace(sinh(a*t), t, s)', '(s^2-a^2)^(-1)*a');
    check('laplace(2*sqrt(t), t, s)', 's^(-3/2)*sqrt(pi)');
    check('laplace(sinh(t)*e^t, t, s)', '(-1+(-1+s)^2)^(-1)');

    print('\n=== ILT (new) ===');
    check('ilt(3*s/(4*s^2+5),s,t)', '(3/4)*cos((1/2)*sqrt(5)*t)');
    check('ilt(2/(3*s^2+1),s,t)', '2*sin((1/3)*sqrt(3)*t)*sqrt(3)^(-1)');
    check('ilt(3/(7*s^2+1)^2, s, t)', '(-3/14)*cos((1/7)*sqrt(7)*t)*t+(3/2)*sin((1/7)*sqrt(7)*t)*sqrt(7)^(-1)');
    check('ilt(5*s/(s^2+4)^2, s, t)', '(5/4)*sin(2*t)*t');
    check('ilt(8*s^2/(2*s^2+3)^2, s, t)', '2*sin((1/2)*sqrt(6)*t)*sqrt(6)^(-1)+cos((1/2)*sqrt(6)*t)*t');
    check('ilt((6*s^2-1)/(4*s^2+1)^2, s, t)', '(1/8)*sin((1/2)*t)+(5/16)*cos((1/2)*t)*t');
    check('ilt((5*(sin(1)*s+3*cos(1)))/(s^2+9),s, t)', '5*cos(1)*sin(3*t)+5*cos(3*t)*sin(1)');
    check('ilt(((s+1)*(s+2)*(s+3))^(-1), s, t)', '(1/2)*e^(-3*t)+(1/2)*e^(-t)-e^(-2*t)');
    check('ilt(1/(s^2+s+1),s,t)', '2*e^((-1/2)*t)*sin((1/2)*sqrt(3)*t)*sqrt(3)^(-1)');
    check('ilt(1/(s^2+2s+1),s,t)', 'e^(-t)*t');

    print('\n=== Regression (already passing) ===');
    check('laplace(5, t, s)', '5/s');
    check('laplace(a*t, t, s)', 'a*s^(-2)');
    check('laplace(cos(a*t), t, s)', '(s^2+a^2)^(-1)*s');
    check('laplace(sin(a*t), t, s)', '(s^2+a^2)^(-1)*a');
    check('laplace(t*sin(a*t), t, s)', '2*(s^2+a^2)^(-2)*a*s');
    check('laplace(x*e^(a*t), t, s)', 'x*(s-a)^(-1)');
    check('laplace(a*t^2, t, s)', '2*a*s^(-3)');
    check('ilt(a/(b*x), x, t)', 'a/b');
    check('ilt(a*6/(b*s^6),s,t)', '(1/20)*a*t^5/b');
    check('ilt(5*sqrt(pi)/(3*s^(3/2)),s,t)', '(10/3)*sqrt(t)');
  });
}
