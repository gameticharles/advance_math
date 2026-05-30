import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, String expected) {
    var parsed = Expression.parse(given);
    var result = parsed.simplify();
    expect(result.toString(), equals(expected), reason: 'Eval of $given');
  }

  group('Calculus', () {
    group('Differentiation', () {
      test('diff(cos(x),x)', () => check('diff(cos(x),x)', '-sin(x)'));
      test('diff(log(x),x)', () => check('diff(log(x),x)', 'x^(-1)'));
      test('diff(tan(x),x)', () => check('diff(tan(x),x)', 'sec(x)^2'));
      test(
          'diff(4*tan(x)*sec(x),x)',
          () => check(
              'diff(4*tan(x)*sec(x),x)', '4*sec(x)^3+4*tan(x)*sec(x)*tan(x)'));
      test('diff(sqrt(7),x)', () => check('diff(sqrt(7),x)', '0'));
      test('diff(4,x)', () => check('diff(4,x)', '0'));
      test('diff(x^2,x)', () => check('diff(x^2,x)', '2*x'));
      test('diff(2*x^2+4,x)', () => check('diff(2*x^2+4,x)', '4*x'));
      test('diff(sqrt(x)*x,x)',
          () => check('diff(sqrt(x)*x,x)', '(3/2)*sqrt(x)'));
      test(
          'diff(sqrt(x)-1/sqrt(x),x)',
          () => check(
              'diff(sqrt(x)-1/sqrt(x),x)', '(1/2)*x^(-1/2)+(1/2)*x^(-3/2)'));
      test('diff(x^2/3-3/x^2,x)',
          () => check('diff(x^2/3-3/x^2,x)', '(2/3)*x+6*x^(-3)'));
      test(
          'diff(sqrt(x)*(x^2+1),x)',
          () => check(
              'diff(sqrt(x)*(x^2+1),x)', '(1/2)*x^(-1/2)*(1+x^2)+2*x^(3/2)'));
      test(
          'diff(e^x/(e^x-1),x)',
          () => check('diff(e^x/(e^x-1),x)',
              '(-1+e^x)^(-2)*(e^x*ln(e)*(-1+e^x)-e^(2*x)*ln(e))'));
      test('diff(e^x,x)', () => check('diff(e^x,x)', 'e^x*ln(e)'));
      test('diff(e^x/x,x)',
          () => check('diff(e^x/x,x)', 'x^(-2)*(e^x*ln(e)*x-e^x)'));
      test(
          'diff(tan(x)*log(1/cos(x)),x)',
          () => check('diff(tan(x)*log(1/cos(x)),x)',
              'sec(x)^2*ln(1/cos(x))+tan(x)*cos(x)^(-1)*sin(x)'));
      test(
          'diff((2*x)^(e),x)', () => check('diff((2*x)^(e),x)', '(2*x)^e*e/x'));
      test('diff(2*cos(x)*log(x),x)',
          () => check('diff(2*cos(x)*log(x),x)', '-2*sin(x)*ln(x)+2*cos(x)/x'));
      test('diff(cos(2*x),x)', () => check('diff(cos(2*x),x)', '-2*sin(2*x)'));
      test(
          'diff(cos(x)*tan(x),x)',
          () =>
              check('diff(cos(x)*tan(x),x)', '-sin(x)*tan(x)+cos(x)*sec(x)^2'));
      test(
          'diff(sec(sqrt(cos(x^(4/5))^2)),x)',
          () => check('diff(sec(sqrt(cos(x^(4/5))^2)),x)',
              '(-4/5)*sec(sqrt(cos(x^(4/5))^2))*tan(cos(x^(4/5)))*x^(-1/5)*sin(x^(4/5))'));
      test(
          'diff(log(log(log(cos(t*t)^z))),t)',
          () => check('diff(log(log(log(cos(t*t)^z))),t)',
              '-2*ln(ln(cos(t^2)^z))^(-1)*ln(cos(t^2)^z)^(-1)*cos(t^2)^(-1)*t*z*sin(t^2)'));
      test(
          'diff(6*log(x)^(3*log(x^2)),x)',
          () => check('diff(6*log(x)^(3*log(x^2)),x)',
              '(36*ln(ln(x))/x+18*ln(x)^(-1)*ln(x^2)/x)*ln(x)^(3*ln(x^2))'));
      test(
          'diff(sinh(x^2)^cos(x),x)',
          () => check('diff(sinh(x^2)^cos(x),x)',
              'sinh(x^2)^cos(x)*(-sin(x)*ln(sinh(x^2))+2*sinh(x^2)^(-1)*cos(x)*cosh(x^2)*x)'));
      test(
          'diff(tan(x)*tanh(x),x)',
          () => check(
              'diff(tan(x)*tanh(x),x)', 'sec(x)^2*tanh(x)+tan(x)*sech(x)^2'));
      test('diff(y*tan(y)*7*tanh(y),x)',
          () => check('diff(y*tan(y)*7*tanh(y),x)', '0'));
      test('diff(yx*tan(y)*7*tanh(y),x)',
          () => check('diff(yx*tan(y)*7*tanh(y),x)', '0'));
      test('diff(y,x)', () => check('diff(y,x)', '0'));
      test('diff(x*y,x)', () => check('diff(x*y,x)', 'y'));
      test('diff([sin(x), x^2, x],x)',
          () => check('diff([sin(x), x^2, x],x)', '[cos(x), 2*x, 1]'));
      test(
          'diff(sinc(a*x^3+b),x)',
          () => check('diff(sinc(a*x^3+b),x)',
              '(a*x^3+b)^(-2)*(3*a*x^2*cos(a*x^3+b)*(a*x^3+b)-3*sin(a*x^3+b)*a*x^2)'));
      test(
          'diff(sqrt(e^x + a),x)',
          () =>
              check('diff(sqrt(e^x + a),x)', '(1/2)*(e^x+a)^(-1/2)*e^x*ln(e)'));
    });

    group('sums', () {
      test('should calculate sums correctly', () {
        check('sum(x+y, x, 0, 3)', '4*y+6');
        check('sum(x^2+x, x, 0, 10)', '440');
        check('sum(x^2*z^2+x*y-z+1, x, 0, 10)', '-11*z+385*z^2+11+55*y');
        check('sum(x^2*z^2+x*y-z+1, z, 0, 10)', '-44+11*x*y+385*x^2');
        check('sum(sqrt(x)*sin(x), x, 0, 10)', '775334583/372372283');
        check('sum(e^(-x^2*π/9),x,1,100)', '633863423979/633863423978');
      }, skip: 'Sums are not symbolically/numerically implemented');
    });

    group('definite integrals', () {
      test('should calculate the definite integral correctly', () {
        check('defint(cos(x),1,2,x)', '0.067826442018');
        check('defint(cos(x)^3*x^2-1,-1,9)', '8.543016466395');
        check('defint(cos(x^x),1,2,x)', '-0.27113666621');
        check('defint(cos(x^log(sin(x))),2,3,x)', '0.805604089074');
        check('defint(log(2*cos(x/2)),-π,π,x)', '-0');
        check('defint(log(cos(x/2)),-π,π,x)', '-4.355172180607');
        check('defint(log(x+1), -1, 1, x)', '-0.6137056388801095');
        check('defint(log(x), 0, 1, x)', '-1');
        check('defint((x^2-3)/(-x^3+9x+1), 1, 3, x)', '0.732408192445406585');
        check('defint(x*(x-5)^(1/2),5,8)', '23.555890982936999348');
        check('defint(sqrt(4(x^2)+4), 0, 3)', '11.305279439735999908');
      },
          skip:
              'Definite integrals are not symbolically/numerically implemented');
    });

    test('should calculate limits correctly', () {
      check('limit((2-2*x^2)/(x-1), x, 1)', '-4');
      check('limit(1/2*(x^2 - 1)/(x^2 + 1), x, 3)', '-2/5');
      check('limit(tan(3*x)/tan(x), x, pi/2)', '-1/3');
      check('limit(x/(3*abs(4*x)),x, 0)', '-1/12');
      check('limit((4x^2-x)/(3x^2+x),x,∞)', '-4/3');
      check('limit((x^(1/2)+x^(-1/2))/(x^(1/2)-x^(-1/2)),x,Infinity)', '1');
      check('limit((2*x+log(x))/(x*log(x)),x,Infinity)', '0');
      check('limit(e^(-x)+2,x,Infinity)', '2');
      check('limit((x+1)^(1+1/x)-x^(1+x),x, Infinity)', '-Infinity');
      check('limit(x/(x+1)^2, x, -1)', '-Infinity');

      // Revisit.
      /*
         check('limit(cos(sin(x)+2), x, Infinity)').toString()).toEqual('[cos(1),cos(3)]');
         check('limit((2sin(x)-sin(2x))/(x-sin(x)),x,0)').toString()).toEqual('6');
         check('limit((3*sin(x)-sin(2*x))/(x-sin(x)),x,0)').toString()).toEqual('Infinity');
         check('limit(log(x),x, 0)').toString()).toEqual('Infinity');
         */
    }, skip: 'Limits are not symbolically/numerically implemented');
  });

  group('integration', () {
    test(
        'integrate(sin(x), x)', () => check('integrate(sin(x), x)', '-cos(x)'));
    test('integrate((22/7)^x,x)',
        () => check('integrate((22/7)^x,x)', 'ln(22/7)^(-1)*(22/7)^x'));
    test('integrate(cos(x), x)', () => check('integrate(cos(x), x)', 'sin(x)'));
    test('integrate(2*x^2+x, x)',
        () => check('integrate(2*x^2+x, x)', '(2/3)*x^3+(1/2)*x^2'));
    test('integrate(log(x), x)',
        () => check('integrate(log(x), x)', 'ln(x)*x-x'));
    test('integrate(sqrt(x), x)',
        () => check('integrate(sqrt(x), x)', '(2/3)*x^(3/2)'));
    test(
        'integrate(asin(a*x), x)',
        () =>
            check('integrate(asin(a*x), x)', 'asin(a*x)*x+sqrt(1-a^2*x^2)/a'));
    test('integrate(a/x, x)', () => check('integrate(a/x, x)', 'a*ln(x)'));
    test(
        'integrate(x*e^x, x)', () => check('integrate(x*e^x, x)', 'x*e^x-e^x'));
    test('integrate(x^3*log(x), x)',
        () => check('integrate(x^3*log(x), x)', '(1/4)*ln(x)*x^4+(-1/16)*x^4'));
    test(
        'integrate(x^2*sin(x), x)',
        () => check(
            'integrate(x^2*sin(x), x)', '-x^2*cos(x)+2*x*sin(x)+2*cos(x)'));
    test(
        'integrate(sin(x)*log(cos(x)), x)',
        () => check(
            'integrate(sin(x)*log(cos(x)), x)', '-cos(x)*ln(cos(x))+cos(x)'));
    test(
        'integrate(x*asin(x), x)',
        () => check('integrate(x*asin(x), x)',
            '(-1/4)*asin(x)+(1/2)*asin(x)*x^2+(1/4)*cos(asin(x))*sin(asin(x))'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test(
        'integrate(q/((2-3*x^2)^(1/2)), x)',
        () => check('integrate(q/((2-3*x^2)^(1/2)), x)',
            'asin(3*sqrt(6)^(-1)*x)*q*sqrt(3)^(-1)'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(1/(a^2+x^2), x)',
        () => check('integrate(1/(a^2+x^2), x)', 'atan(x/a)/a'));
    test(
        'integrate(11/(a+5*r*x)^2,x)',
        () => check(
            'integrate(11/(a+5*r*x)^2,x)', '(-11/5)*(5*r*x+a)^(-1)*r^(-1)'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(cos(x)*sin(x), x)',
        () => check('integrate(cos(x)*sin(x), x)', '(-1/2)*cos(x)^2'));
    test(
        'integrate(x*cos(x)*sin(x), x)',
        () => check('integrate(x*cos(x)*sin(x), x)',
            '(-1/2)*cos(x)^2*x+(1/4)*cos(x)*sin(x)+(1/4)*x'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(t/(a*x+b), x)',
        () => check('integrate(t/(a*x+b), x)', 't*ln(a*x+b)/a'));
    test(
        'integrate(x*(x+a)^3, x)',
        () => check('integrate(x*(x+a)^3, x)',
            '(1/2)*a^3*x^2+(1/5)*x^5+(3/4)*a*x^4+a^2*x^3'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(4*x/(x^2+a^2), x)',
        () => check('integrate(4*x/(x^2+a^2), x)', '2*ln(x^2+a^2)'));
    test(
        'integrate(1/(x^2+3*a^2), x)',
        () => check('integrate(1/(x^2+3*a^2), x)',
            'sqrt(3*a^2)^(-1)*atan(x/sqrt(3*a^2))'));
    test(
        'integrate(8*x^3/(6*x^2+3*a^2), x)',
        () => check('integrate(8*x^3/(6*x^2+3*a^2), x)',
            '8*((-1/24)*a^2*log(2*x^2+a^2)+(1/12)*x^2)'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test(
        'integrate(10*q/(4*x^2+24*x+20), x)',
        () => check('integrate(10*q/(4*x^2+24*x+20), x)',
            '10*((-1/16)*log(5+x)+(1/16)*log(1+x))*q'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(x/(x+a)^2, x)',
        () => check('integrate(x/(x+a)^2, x)', '(a+x)^(-1)*a+log(a+x)'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
    test('integrate(sqrt(x-a), x)',
        () => check('integrate(sqrt(x-a), x)', '(x-a)^(3/2)/(3/2)'));
    test(
        'integrate(x^n*log(x), x)',
        () => check('integrate(x^n*log(x), x)',
            'ln(x)*(1+n)^(-1)*x^(1+n)-(1+n)^(-2)*x^(1+n)'));
    test('integrate(3*a*sec(x)^2, x)',
        () => check('integrate(3*a*sec(x)^2, x)', '3*a*tan(x)'));
    test(
        'integrate(a/(x^2+b*x+a*x+a*b),x)',
        () => check('integrate(a/(x^2+b*x+a*x+a*b),x)',
            '(((-a^(-1)*b+1)^(-1)*a^(-1)*b+1)*a^(-1)*log(b+x)-(-a^(-1)*b+1)^(-1)*a^(-1)*log(a+x))*a'),
        skip: 'Advanced symbolic integration strategy not implemented yet');
  });
}
