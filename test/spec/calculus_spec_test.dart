import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void main() {
  void check(String given, String expected) {
    var parsed = Expression.parse(given);
    // Simplify if needed, or just toString comparison
    // Nerdamer often returns simplified results
    var result = parsed.simplify();
    expect(result.toString(), equals(expected), reason: 'Eval of $given');
  }

  group('Nerdamer calculus', () {
    test('should differentiate correctly', () {
      check('diff(cos(x),x)', '-sin(x)');
      check('diff(log(x),x)', '-1/x');
      check('diff(tan(x),x)', 'sec(x)^2');
      check('diff(4*tan(x)*sec(x),x)', '4*(sec(x)*tan(x)^2+sec(x)^3)');
      check('diff(sqrt(7),x)', '0');
      check('diff(4,x)', '0');
      check('diff(x^2,x)', '2*x');
      check('diff(2*x^2+4,x)', '4*x');
      check('diff(sqrt(x)*x,x)', '(3/2)*x^(1/2)');
      check('diff(sqrt(x)-1/sqrt(x),x)', '(1/2)*x^(-1/2)+(1/2)*x^(-3/2)');
      check('diff(x^2/3-3/x^2,x)', '(2/3)*x+6*x^(-3)');
      check('diff(sqrt(x)*(x^2+1),x)', '(1/2)*(1+x^2)*x^(-1/2)+2*x^(3/2)');
      check('diff(e^x/(e^x-1),x)', '(-1+e^x)^(-1)*e^x-(-1+e^x)^(-2)*e^(2*x)');
      check('diff(e^x,x)', 'e^x');
      check('diff(e^x/x,x)', '-e^x*x^(-2)+e^x*x^(-1)');
      check('diff(tan(x)*log(1/cos(x)),x)',
          '-(-cos(x)^(-1)*sin(x)*tan(x)+log(cos(x))*sec(x)^2)');
      check('diff((2*x)^(e),x)', '2^e*e*x^(-1+e)');
      check('diff(2*cos(x)*log(x),x)', '2*(-log(x)*sin(x)+cos(x)*x^(-1))');
      check('diff(cos(5*x)*log(sec(sqrt(cos(x^(4/5))^2))/y^2)*y,x)',
          '(-4/5)*abs(cos(x^(4/5)))^(-1)*cos(x^(4/5))*sec(abs(cos(x^(4/5))))*sin(x^(4/5))*tan(abs(cos(x^(4/5))))*x^(-1/5)*y^(-2)*cos(5*x)*sec(abs(cos(x^(4/5))))^(-1)*y^3-5*log(sec(abs(cos(x^(4/5))))*y^(-2))*sin(5*x)*y');
      check('diff(x*cos(x)^log(x),x)',
          '(-cos(x)^(-1)*log(x)*sin(x)+log(cos(x))*x^(-1))*cos(x)^log(x)*x+cos(x)^log(x)');
      check('diff(cos(2*x),x)', '-2*sin(2*x)');
      check('diff(cos(x)*tan(x),x)', '-sin(x)*tan(x)+cos(x)*sec(x)^2');
      check('diff(sec(sqrt(cos(x^(4/5))^2)),x)',
          '(-4/5)*abs(cos(x^(4/5)))^(-1)*cos(x^(4/5))*sec(abs(cos(x^(4/5))))*sin(x^(4/5))*tan(abs(cos(x^(4/5))))*x^(-1/5)');
      check('diff(log(log(log(cos(t*t)^z))),t)',
          '-2*cos(t^2)^(-1)*sin(t^2)*t*z*log(cos(t^2))^(-1)*log(log(cos(t^2))*z)^(-1)*z^(-1)');
      check('diff(6*log(x)^(3*log(x^2)),x)',
          '36*(log(log(x))*x^(-1)+x^(-1))*log(x)^(6*log(x))');
      check('diff(sinh(x^2)^cos(x),x)',
          '(-log(sinh(x^2))*sin(x)+2*cos(x)*cosh(x^2)*sinh(x^2)^(-1)*x)*sinh(x^2)^cos(x)');
      check('diff(tan(x)*tanh(x),x)', 'sec(x)^2*tanh(x)+sech(x)^2*tan(x)');
      check('diff(4*x*tan(x)*7*tanh(x),x)',
          '28*(sec(x)^2*tanh(x)*x+sech(x)^2*tan(x)*x+tan(x)*tanh(x))');
      check('diff(y*tan(y)*7*tanh(y),x)', '0');
      check('diff(yx*tan(y)*7*tanh(y),x)', '0');
      check('diff(y,x)', '0');
      check('diff(x*y,x)', 'y');
      check('diff([sin(x), x^2, x],x)', '[cos(x),2*x,1]');
      check('diff(sinc(a*x^3+b),x)',
          '3*((a*x^3+b)*cos(a*x^3+b)-sin(a*x^3+b))*(a*x^3+b)^(-2)*a*x^2');
      check('diff(sqrt(e^x + a),x)', '(1/2)*(a+e^x)^(-1/2)*e^x');
    });

    test('should calculate sums correctly', () {
      check('sum(x+y, x, 0, 3)', '4*y+6');
      check('sum(x^2+x, x, 0, 10)', '440');
      check('sum(x^2*z^2+x*y-z+1, x, 0, 10)', '-11*z+385*z^2+11+55*y');
      check('sum(x^2*z^2+x*y-z+1, z, 0, 10)', '-44+11*x*y+385*x^2');
      check('sum(sqrt(x)*sin(x), x, 0, 10)', '775334583/372372283');
      check('sum(e^(-x^2*π/9),x,1,100)', '633863423979/633863423978');
    });

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
    });

    test('should integrate properly', () {
      check('integrate(sin(x), x)', '-cos(x)');
      check('integrate((22/7)^x,x)', '(log(1/7)+log(22))^(-1)*22^x*7^(-x)');
      check('integrate(cos(x), x)', 'sin(x)');
      check('integrate(2*x^2+x, x)', '(1/2)*x^2+(2/3)*x^3');
      check('integrate(log(x), x)', '-x+log(x)*x');
      check('integrate(sqrt(x), x)', '(2/3)*x^(3/2)');
      check('integrate(asin(a*x), x)', 'a^(-1)*sqrt(-a^2*x^2+1)+asin(a*x)*x');
      check('integrate(a/x, x)', 'a*log(x)');
      check('integrate(x*e^x, x)', '-e^x+e^x*x');
      check('integrate(x^3*log(x), x)', '(-1/16)*x^4+(1/4)*log(x)*x^4');
      check('integrate(x^2*sin(x), x)', '-cos(x)*x^2+2*cos(x)+2*sin(x)*x');
      check('integrate(sin(x)*log(cos(x)), x)', '-cos(x)*log(cos(x))+cos(x)');
      check('integrate(x*asin(x), x)',
          '(-1/4)*asin(x)+(1/2)*asin(x)*x^2+(1/4)*cos(asin(x))*sin(asin(x))');
      check('integrate(q/((2-3*x^2)^(1/2)), x)',
          'asin(3*sqrt(6)^(-1)*x)*q*sqrt(3)^(-1)');
      check('integrate(1/(a^2+x^2), x)', 'a^(-1)*atan(a^(-1)*x)');
      check('integrate(11/(a+5*r*x)^2,x)', '(-11/5)*(5*r*x+a)^(-1)*r^(-1)');
      check('integrate(cos(x)*sin(x), x)', '(-1/2)*cos(x)^2');
      check('integrate(x*cos(x)*sin(x), x)',
          '(-1/2)*cos(x)^2*x+(1/4)*cos(x)*sin(x)+(1/4)*x');
      check('integrate(t/(a*x+b), x)', 'a^(-1)*log(a*x+b)*t');
      check('integrate(x*(x+a)^3, x)',
          '(1/2)*a^3*x^2+(1/5)*x^5+(3/4)*a*x^4+a^2*x^3');
      check('integrate(4*x/(x^2+a^2), x)', '2*log(a^2+x^2)');
      check('integrate(1/(x^2+3*a^2), x)',
          'a^(-1)*atan(a^(-1)*sqrt(3)^(-1)*x)*sqrt(3)^(-1)');
      check('integrate(8*x^3/(6*x^2+3*a^2), x)',
          '8*((-1/24)*a^2*log(2*x^2+a^2)+(1/12)*x^2)');
      check('integrate(10*q/(4*x^2+24*x+20), x)',
          '10*((-1/16)*log(5+x)+(1/16)*log(1+x))*q');
      check('integrate(x/(x+a)^2, x)', '(a+x)^(-1)*a+log(a+x)');
      check('integrate(sqrt(x-a), x)', '(2/3)*(-a+x)^(3/2)');
      check('integrate(x^n*log(x), x)',
          '(1+n)^(-1)*log(x)*x^(1+n)-(1+n)^(-2)*x^(1+n)');
      check('integrate(3*a*sec(x)^2, x)', '3*a*tan(x)');
      check('integrate(a/(x^2+b*x+a*x+a*b),x)',
          '(((-a^(-1)*b+1)^(-1)*a^(-1)*b+1)*a^(-1)*log(b+x)-(-a^(-1)*b+1)^(-1)*a^(-1)*log(a+x))*a');
      check('integrate(log(a*x+b),x)', '((a*x+b)*log(a*x+b)-a*x-b)*a');
      check('integrate(x*log(x),x)', '(-1/4)*x^2+(1/2)*log(x)*x^2');
      check('integrate(log(a*x)/x,x)', '(1/2)*log(a*x)^2');
      check('integrate(log(x)^2,x)', '-2*log(x)*x+2*x+log(x)^2*x');
      check('integrate(t*log(x)^3,x)',
          '(-3*log(x)^2*x-6*x+6*log(x)*x+log(x)^3*x)*t');
      check('integrate(e^x*sin(x),x)', '(1/2)*(-cos(x)*e^x+e^x*sin(x))');
      check('integrate(e^(2*x)*sin(x),x)',
          '(4/5)*((-1/4)*cos(x)*e^(2*x)+(1/2)*e^(2*x)*sin(x))');
      check('integrate(e^(2*x)*sin(x)*x,x)',
          '(-3/25)*e^(2*x)*sin(x)+(4/25)*cos(x)*e^(2*x)+(4/5)*((-1/4)*cos(x)*e^(2*x)+(1/2)*e^(2*x)*sin(x))*x');
      check('integrate(x*log(x)^2,x)',
          '(-1/2)*log(x)*x^2+(1/2)*log(x)^2*x^2+(1/4)*x^2');
      check('integrate(x^2*log(x)^2,x)',
          '(-2/9)*log(x)*x^3+(1/3)*log(x)^2*x^3+(2/27)*x^3');
      check('integrate(x^2*e^(a*x),x)',
          '-2*(-a^(-2)*e^(a*x)+a^(-1)*e^(a*x)*x)*a^(-1)+a^(-1)*e^(a*x)*x^2');
      check('integrate(8*e^(a*x^2),x)',
          '4*erf(sqrt(-a)*x)*sqrt(-a)^(-1)*sqrt(pi)');
      check('integrate(5*x*e^(-8*a*x^2),x)', '(-5/16)*a^(-1)*e^(-8*a*x^2)');
      check('integrate(x^2*sin(x),x)', '-cos(x)*x^2+2*cos(x)+2*sin(x)*x');
      check('integrate(8*tan(b*x)^2,x)', '8*(-x+b^(-1)*tan(b*x))');
      check('integrate(sec(a*x)^3,x)',
          '(1/2)*a^(-1)*log(sec(a*x)+tan(a*x))+(1/2)*a^(-1)*sec(a*x)*tan(a*x)');
      check('integrate(sec(a*x)*tan(a*x),x)', 'a^(-1)*sec(a*x)');
      check('integrate(3*a*cot(a*x)^4, x)',
          '3*((-1/3)*a^(-1)*cot(a*x)^3+a^(-1)*cot(a*x)+x)*a');
      check('integrate(3*a*csc(a*x)^4, x)',
          '3*((-1/3)*a^(-1)*cot(a*x)*csc(a*x)^2+(-2/3)*a^(-1)*cot(a*x))*a');
      check('integrate(1/8*a*2/(x^3+13*x^2+47*x+35),x)',
          '(1/4)*((-1/8)*log(5+x)+(1/12)*log(7+x)+(1/24)*log(1+x))*a');
      check('integrate(a*2/(x^2+x),x)', '2*(-log(1+x)+log(x))*a');
      check('integrate((x+7)/(x+1)^3,x)',
          '(-1/2)*(1+x)^(-1)+(-7/2)*(1+x)^(-2)+(-1/2)*(1+x)^(-2)*x');
      check('integrate((3*x+2)/(x^2+x),x)', '2*log(x)+log(1+x)');
      check('integrate([sin(x), x^2, x],x)', '[-cos(x),(1/3)*x^3,(1/2)*x^2]');
      check('integrate(sinh(x),x)', 'cosh(x)');
      check('integrate(cosh(x),x)', 'sinh(x)');
      check('integrate(tanh(x),x)', 'log(cosh(x))');
      check('integrate(sinh(x)*x,x)', '-sinh(x)+cosh(x)*x');
      check('integrate((x^6+x^2-7)/(x^2+11), x)',
          '(-11/3)*x^3+(1/5)*x^5+122*x-1349*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)');
      check('integrate(x^6/(x^2+11), x)',
          '(-11/3)*x^3+(1/5)*x^5+121*x-1331*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)');
      check('integrate(x^2/(x^2+11))',
          '-11*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)+x');
      check('integrate(tan(x)*csc(x), x)', 'log(sec(x)+tan(x))');
      check('integrate(sinh(x)*e^x, x)', '(-1/2)*x+(1/4)*e^(2*x)');
      check('integrate(sinh(x)*cos(x), x)',
          '(-1/4)*e^(-x)*sin(x)+(1/4)*cos(x)*e^(-x)+(1/4)*cos(x)*e^x+(1/4)*e^x*sin(x)');
      check('integrate(cos(x^2), x)', 'integrate(cos(x^2),x)');
      check('integrate(sqrt(a-x^2)*x^2, x)',
          '((-1/16)*cos(2*asin(sqrt(a)^(-1)*x))*sin(2*asin(sqrt(a)^(-1)*x))+(1/8)*asin(sqrt(a)^(-1)*x))*a^2');
      check('integrate((1-x^2)^(3/2), x)',
          '(-3/16)*cos(2*asin(x))*sin(2*asin(x))+(-x^2+1)^(3/2)*x+(3/8)*asin(x)');
      check('integrate((1-x^2)^(3/2)*x^2, x)',
          '(-1/32)*cos(2*asin(x))*sin(2*asin(x))+(-1/48)*cos(2*asin(x))^2*sin(2*asin(x))+(1/16)*asin(x)+(1/48)*sin(2*asin(x))');
      check('integrate(cos(x)^2*sin(x)^4, x)',
          '(-1/32)*cos(2*x)*sin(2*x)+(-1/48)*sin(2*x)+(1/16)*x+(1/48)*cos(2*x)^2*sin(2*x)');
      check('integrate(log(a*x+1)/x^2, x)',
          '(-log(1+a*x)+log(x))*a-log(1+a*x)*x^(-1)');
      check('integrate(x^2*(1-x^2)^(5/2), x)',
          '(-1/128)*cos(2*asin(x))^3*sin(2*asin(x))+(-1/48)*cos(2*asin(x))^2*sin(2*asin(x))+(-3/256)*cos(2*asin(x))*sin(2*asin(x))+(1/48)*sin(2*asin(x))+(5/128)*asin(x)');
      check('integrate(1/tan(a*x)^n, x)', 'integrate(tan(a*x)^(-n),x)');
      check('integrate(sin(x)^2*cos(x)*tan(x), x)',
          '(-3/4)*cos(x)+(1/12)*cos(3*x)');
      check('integrate(cos(x)^2/sin(x),x)', '-log(cot(x)+csc(x))+cos(x)');
      check('integrate(cos(x)/x,x)', 'Ci(x)');
      check('integrate(sin(x)/x,x)', 'Si(x)');
      check('integrate(log(x)^3/x,x)', '(1/4)*log(x)^4');
      check('integrate(tan(x)^2*sec(x), x)',
          '(-1/2)*log(sec(x)+tan(x))+(1/2)*sec(x)*tan(x)');
      check('integrate(tan(x)/cos(x),x)', 'cos(x)^(-1)');
      check('integrate(sin(x)^3/x,x)', '(-1/4)*Si(3*x)+(3/4)*Si(x)');
      check('integrate(tan(x)/sec(x)*sin(x)/tan(x),x)', '(-1/2)*cos(x)^2');
      check('integrate(log(x)^n/x,x)', '(1+n)^(-1)*log(x)^(1+n)');
      check('integrate(1/(x^2+9)^3,x)',
          '(1/729)*((1/4)*cos(atan((1/3)*x))^3*sin(atan((1/3)*x))+(3/8)*atan((1/3)*x)+(3/8)*cos(atan((1/3)*x))*sin(atan((1/3)*x)))');
      check(
          'integrate(asin(x)/sqrt(2-2x^2),x)', '(1/2)*asin(x)^2*sqrt(2)^(-1)');
      check('integrate(atan(x)/(2+2*x^2),x)', '(1/4)*atan(x)^2');
      check('integrate(1/(sqrt(1-1/x^2)*x^2), x)', 'asin(sqrt(-x^(-2)+1))');
      check('integrate(1/(sqrt(1-1/x^2)*x), x)',
          '(-1/2)*log(1+sqrt(-x^(-2)+1))+(1/2)*log(-1+sqrt(-x^(-2)+1))');
      check('integrate(exp(2*log(x)),x)', '(1/3)*x^3');
    });
  });
}
