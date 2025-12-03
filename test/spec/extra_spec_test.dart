import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, String expected) {
    var parsed = Expression.parse(given);
    var result = parsed.evaluate();
    expect(result.toString(), equals(expected), reason: 'Eval of $given');
  }

  group('Extra Calculus', () {
    test('should transform Laplace correctly', () {
      check('laplace(5, t, s)', '5*s^(-1)');
      check('laplace(a*t, t, s)', 'a*s^(-2)');
      check('laplace(cos(a*t), t, s)', '(a^2+s^2)^(-1)*s');
      check('laplace(cos(x), t, s)', 'cos(x)*s^(-1)');
      check('laplace(sinh(a*t), t, s)', '(-a^2+s^2)^(-1)*a');
      check('laplace(a*t^2, t, s)', '2*a*s^(-3)');
      check('laplace(2*sqrt(t), t, s)', 's^(-3/2)*sqrt(pi)');
      check('laplace(x*e^(a*t), t, s)', '(-a+s)^(-1)*x');
      check('laplace(x*(sin(a*t)-a*t*cos(a*t)), t, s)',
          '((a^2+s^2)^(-1)*a-((1+a^2*s^(-2))^(-2)*s^(-2)-(1+a^2*s^(-2))^(-2)*a^2*s^(-4))*a)*x');
      check('laplace(sin(a*t), t, s)', '(a^2+s^2)^(-1)*a');
      check('laplace(t*sin(a*t), t, s)', '2*(1+a^2*s^(-2))^(-2)*a*s^(-3)');
      check('laplace(sin(a*t+b), t, s)',
          '(1+a^2*s^(-2))^(-1)*a*cos(b)*s^(-2)+(1+a^2*s^(-2))^(-1)*s^(-1)*sin(b)');
      check('laplace(t^2*e^(a*t), t, s)', '-2*(-s+a)^(-3)');
      check('laplace(6*t*e^(-9*t)*sin(6*t), t, s)',
          '-72*(-9-s)^(-3)*(1+36*(-9-s)^(-2))^(-2)');
      check('laplace(sinh(t)*e^t, t, s)', '(-1/2)*(-s+2)^(-1)+(-1/2)*s^(-1)');
    });

    test('should invert a Laplace transform correctly', () {
      check('ilt(a/(b*x), x, t)', 'a*b^(-1)');
      check('ilt(a*6/(b*s^6),s,t)', '(1/20)*a*b^(-1)*t^5');
      check('ilt(3*s/(4*s^2+5),s,t)', '(3/4)*cos((1/2)*sqrt(5)*t)');
      check('ilt(2/(3*s^2+1),s,t)', '2*sin((1/3)*sqrt(3)*t)*sqrt(3)^(-1)');
      check('ilt(5*sqrt(pi)/(3*s^(3/2)),s,t)', '(10/3)*sqrt(t)');
      check('ilt(3/(7*s^2+1)^2, s, t)',
          '(-3/14)*cos((1/7)*sqrt(7)*t)*t+(3/2)*sin((1/7)*sqrt(7)*t)*sqrt(7)^(-1)');
      check('ilt(5*s/(s^2+4)^2, s, t)', '(5/4)*sin(2*t)*t');
      check('ilt(8*s^2/(2*s^2+3)^2, s, t)',
          '2*sin((1/2)*sqrt(6)*t)*sqrt(6)^(-1)+cos((1/2)*sqrt(6)*t)*t');
      check('ilt((6*s^2-1)/(4*s^2+1)^2, s, t)',
          '(1/8)*sin((1/2)*t)+(5/16)*cos((1/2)*t)*t');
      check('ilt((5*(sin(1)*s+3*cos(1)))/(s^2+9),s, t)',
          '5*cos(1)*sin(3*t)+5*cos(3*t)*sin(1)');
      check('ilt(((s+1)*(s+2)*(s+3))^(-1), s, t)',
          '(1/2)*e^(-3*t)+(1/2)*e^(-t)-e^(-2*t)');
      check('ilt(1/(s^2+s+1),s,t)',
          '2*e^((-1/2)*t)*sin((1/2)*sqrt(3)*t)*sqrt(3)^(-1)');
      check('ilt(1/(s^2+2s+1),s,t)', 'e^(-t)*t');
    });

    test('should calculate mode correctly', () {
      check('mode(r,r,r,r)', 'r');
      check('mode(1,2)', 'mode(1,2)');
      check('mode(1,2,3,1,2)', 'mode(1,2)');
      check('mode(1,1,2)', '1');
      check('mode(a,a,b,c,a,b,d)', 'a');
      check('mode(x, r+1, 21, tan(x), r+1)', '1+r');
      check('mode(x, r+1, 21, tan(x), r+1, x)', 'mode(1+r,x)');
    });
  });
}
