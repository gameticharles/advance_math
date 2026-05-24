import 'package:advance_math/advance_math.dart';

void main() {
  final list = [
    ['integrate(sin(x), x)', '-cos(x)'],
    ['integrate((22/7)^x,x)', '(log(1/7)+log(22))^(-1)*22^x*7^(-x)'],
    ['integrate(cos(x), x)', 'sin(x)'],
    ['integrate(2*x^2+x, x)', '(1/2)*x^2+(2/3)*x^3'],
    ['integrate(log(x), x)', '-x+log(x)*x'],
    ['integrate(sqrt(x), x)', '(2/3)*x^(3/2)'],
    ['integrate(asin(a*x), x)', 'a^(-1)*sqrt(-a^2*x^2+1)+asin(a*x)*x'],
    ['integrate(a/x, x)', 'a*log(x)'],
    ['integrate(x*e^x, x)', '-e^x+e^x*x'],
    ['integrate(x^3*log(x), x)', '(-1/16)*x^4+(1/4)*log(x)*x^4'],
    ['integrate(x^2*sin(x), x)', '-cos(x)*x^2+2*cos(x)+2*sin(x)*x'],
    ['integrate(sin(x)*log(cos(x)), x)', '-cos(x)*log(cos(x))+cos(x)'],
    [
      'integrate(x*asin(x), x)',
      '(-1/4)*asin(x)+(1/2)*asin(x)*x^2+(1/4)*cos(asin(x))*sin(asin(x))'
    ],
    [
      'integrate(q/((2-3*x^2)^(1/2)), x)',
      'asin(3*sqrt(6)^(-1)*x)*q*sqrt(3)^(-1)'
    ],
    ['integrate(1/(a^2+x^2), x)', 'a^(-1)*atan(a^(-1)*x)'],
    ['integrate(11/(a+5*r*x)^2,x)', '(-11/5)*(5*r*x+a)^(-1)*r^(-1)'],
    ['integrate(cos(x)*sin(x), x)', '(-1/2)*cos(x)^2'],
    [
      'integrate(x*cos(x)*sin(x), x)',
      '(-1/2)*cos(x)^2*x+(1/4)*cos(x)*sin(x)+(1/4)*x'
    ],
    ['integrate(t/(a*x+b), x)', 'a^(-1)*log(a*x+b)*t'],
    ['integrate(x*(x+a)^3, x)', '(1/2)*a^3*x^2+(1/5)*x^5+(3/4)*a*x^4+a^2*x^3'],
    ['integrate(4*x/(x^2+a^2), x)', '2*log(a^2+x^2)'],
    [
      'integrate(1/(x^2+3*a^2), x)',
      'a^(-1)*atan(a^(-1)*sqrt(3)^(-1)*x)*sqrt(3)^(-1)'
    ],
    [
      'integrate(8*x^3/(6*x^2+3*a^2), x)',
      '8*((-1/24)*a^2*log(2*x^2+a^2)+(1/12)*x^2)'
    ],
    [
      'integrate(10*q/(4*x^2+24*x+20), x)',
      '10*((-1/16)*log(5+x)+(1/16)*log(1+x))*q'
    ],
    ['integrate(x/(x+a)^2, x)', '(a+x)^(-1)*a+log(a+x)'],
    ['integrate(sqrt(x-a), x)', '(2/3)*(-a+x)^(3/2)'],
    [
      'integrate(x^n*log(x), x)',
      '(1+n)^(-1)*log(x)*x^(1+n)-(1+n)^(-2)*x^(1+n)'
    ],
    ['integrate(3*a*sec(x)^2, x)', '3*a*tan(x)'],
    [
      'integrate(a/(x^2+b*x+a*x+a*b),x)',
      '(((-a^(-1)*b+1)^(-1)*a^(-1)*b+1)*a^(-1)*log(b+x)-(-a^(-1)*b+1)^(-1)*a^(-1)*log(a+x))*a'
    ],
    ['integrate(log(a*x+b),x)', '((a*x+b)*log(a*x+b)-a*x-b)*a'],
    ['integrate(x*log(x),x)', '(-1/4)*x^2+(1/2)*log(x)*x^2'],
    ['integrate(log(a*x)/x,x)', '(1/2)*log(a*x)^2'],
    ['integrate(log(x)^2,x)', '-2*log(x)*x+2*x+log(x)^2*x'],
    ['integrate(t*log(x)^3,x)', '(-3*log(x)^2*x-6*x+6*log(x)*x+log(x)^3*x)*t'],
    ['integrate(e^x*sin(x),x)', '(1/2)*(-cos(x)*e^x+e^x*sin(x))'],
    [
      'integrate(e^(2*x)*sin(x),x)',
      '(4/5)*((-1/4)*cos(x)*e^(2*x)+(1/2)*e^(2*x)*sin(x))'
    ],
    [
      'integrate(e^(2*x)*sin(x)*x,x)',
      '(-3/25)*e^(2*x)*sin(x)+(4/25)*cos(x)*e^(2*x)+(4/5)*((-1/4)*cos(x)*e^(2*x)+(1/2)*e^(2*x)*sin(x))*x'
    ],
    [
      'integrate(x*log(x)^2,x)',
      '(-1/2)*log(x)*x^2+(1/2)*log(x)^2*x^2+(1/4)*x^2'
    ],
    [
      'integrate(x^2*log(x)^2,x)',
      '(-2/9)*log(x)*x^3+(1/3)*log(x)^2*x^3+(2/27)*x^3'
    ],
    [
      'integrate(x^2*e^(a*x),x)',
      '-2*(-a^(-2)*e^(a*x)+a^(-1)*e^(a*x)*x)*a^(-1)+a^(-1)*e^(a*x)*x^2'
    ],
    ['integrate(8*e^(a*x^2),x)', '4*erf(sqrt(-a)*x)*sqrt(-a)^(-1)*sqrt(pi)'],
    ['integrate(5*x*e^(-8*a*x^2),x)', '(-5/16)*a^(-1)*e^(-8*a*x^2)'],
    ['integrate(x^2*sin(x),x)', '-cos(x)*x^2+2*cos(x)+2*sin(x)*x'],
    ['integrate(8*tan(b*x)^2,x)', '8*(-x+b^(-1)*tan(b*x))'],
    [
      'integrate(sec(a*x)^3,x)',
      '(1/2)*a^(-1)*log(sec(a*x)+tan(a*x))+(1/2)*a^(-1)*sec(a*x)*tan(a*x)'
    ],
    ['integrate(sec(a*x)*tan(a*x),x)', 'a^(-1)*sec(a*x)'],
    [
      'integrate(3*a*cot(a*x)^4, x)',
      '3*((-1/3)*a^(-1)*cot(a*x)^3+a^(-1)*cot(a*x)+x)*a'
    ],
    [
      'integrate(3*a*csc(a*x)^4, x)',
      '3*((-1/3)*a^(-1)*cot(a*x)*csc(a*x)^2+(-2/3)*a^(-1)*cot(a*x))*a'
    ],
    [
      'integrate(1/8*a*2/(x^3+13*x^2+47*x+35),x)',
      '(1/4)*((-1/8)*log(5+x)+(1/12)*log(7+x)+(1/24)*log(1+x))*a'
    ],
    ['integrate(a*2/(x^2+x),x)', '2*(-log(1+x)+log(x))*a'],
    [
      'integrate((x+7)/(x+1)^3,x)',
      '(-1/2)*(1+x)^(-1)+(-7/2)*(1+x)^(-2)+(-1/2)*(1+x)^(-2)*x'
    ],
    ['integrate((3*x+2)/(x^2+x),x)', '2*log(x)+log(1+x)'],
    ['integrate([sin(x), x^2, x],x)', '[-cos(x),(1/3)*x^3,(1/2)*x^2]'],
    ['integrate(sinh(x),x)', 'cosh(x)'],
    ['integrate(cosh(x),x)', 'sinh(x)'],
    ['integrate(tanh(x),x)', 'log(cosh(x))'],
    ['integrate(sinh(x)*x,x)', '-sinh(x)+cosh(x)*x'],
    [
      'integrate((x^6+x^2-7)/(x^2+11), x)',
      '(-11/3)*x^3+(1/5)*x^5+122*x-1349*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)'
    ],
    [
      'integrate(x^6/(x^2+11), x)',
      '(-11/3)*x^3+(1/5)*x^5+121*x-1331*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)'
    ],
    ['integrate(x^2/(x^2+11))', '-11*atan(sqrt(11)^(-1)*x)*sqrt(11)^(-1)+x'],
    ['integrate(tan(x)*csc(x), x)', 'log(sec(x)+tan(x))'],
    ['integrate(sinh(x)*e^x, x)', '(-1/2)*x+(1/4)*e^(2*x)'],
    [
      'integrate(sinh(x)*cos(x), x)',
      '(-1/4)*e^(-x)*sin(x)+(1/4)*cos(x)*e^(-x)+(1/4)*cos(x)*e^x+(1/4)*e^x*sin(x)'
    ],
    ['integrate(cos(x^2), x)', 'integrate(cos(x^2),x)'],
    [
      'integrate(sqrt(a-x^2)*x^2, x)',
      '((-1/16)*cos(2*asin(sqrt(a)^(-1)*x))*sin(2*asin(sqrt(a)^(-1)*x))+(1/8)*asin(sqrt(a)^(-1)*x))*a^2'
    ],
    [
      'integrate((1-x^2)^(3/2), x)',
      '(-3/16)*cos(2*asin(x))*sin(2*asin(x))+(-x^2+1)^(3/2)*x+(3/8)*asin(x)'
    ],
    [
      'integrate((1-x^2)^(3/2)*x^2, x)',
      '(-1/32)*cos(2*asin(x))*sin(2*asin(x))+(-1/48)*cos(2*asin(x))^2*sin(2*asin(x))+(1/16)*asin(x)+(1/48)*sin(2*asin(x))'
    ],
    [
      'integrate(cos(x)^2*sin(x)^4, x)',
      '(-1/32)*cos(2*x)*sin(2*x)+(-1/48)*sin(2*x)+(1/16)*x+(1/48)*cos(2*x)^2*sin(2*x)'
    ],
    [
      'integrate(log(a*x+1)/x^2, x)',
      '(-log(1+a*x)+log(x))*a-log(1+a*x)*x^(-1)'
    ],
    [
      'integrate(x^2*(1-x^2)^(5/2), x)',
      '(-1/128)*cos(2*asin(x))^3*sin(2*asin(x))+(-1/48)*cos(2*asin(x))^2*sin(2*asin(x))+(-3/256)*cos(2*asin(x))*sin(2*asin(x))+(1/48)*sin(2*asin(x))+(5/128)*asin(x)'
    ],
    ['integrate(1/tan(a*x)^n, x)', 'integrate(tan(a*x)^(-n),x)'],
    ['integrate(sin(x)^2*cos(x)*tan(x), x)', '(-3/4)*cos(x)+(1/12)*cos(3*x)'],
    ['integrate(cos(x)^2/sin(x),x)', '-log(cot(x)+csc(x))+cos(x)'],
    ['integrate(cos(x)/x,x)', 'Ci(x)'],
    ['integrate(sin(x)/x,x)', 'Si(x)'],
    ['integrate(log(x)^3/x,x)', '(1/4)*log(x)^4'],
    [
      'integrate(tan(x)^2*sec(x), x)',
      '(-1/2)*log(sec(x)+tan(x))+(1/2)*sec(x)*tan(x)'
    ],
    ['integrate(tan(x)/cos(x),x)', 'cos(x)^(-1)'],
    ['integrate(sin(x)^3/x,x)', '(-1/4)*Si(3*x)+(3/4)*Si(x)'],
    ['integrate(tan(x)/sec(x)*sin(x)/tan(x),x)', '(-1/2)*cos(x)^2'],
    ['integrate(log(x)^n/x,x)', '(1+n)^(-1)*log(x)^(1+n)'],
    [
      'integrate(1/(x^2+9)^3,x)',
      '(1/729)*((1/4)*cos(atan((1/3)*x))^3*sin(atan((1/3)*x))+(3/8)*atan((1/3)*x)+(3/8)*cos(atan((1/3)*x))*sin(atan((1/3)*x)))'
    ],
    ['integrate(asin(x)/sqrt(2-2x^2),x)', '(1/2)*asin(x)^2*sqrt(2)^(-1)'],
    ['integrate(atan(x)/(2+2*x^2),x)', '(1/4)*atan(x)^2'],
    ['integrate(1/(sqrt(1-1/x^2)*x^2), x)', 'asin(sqrt(-x^(-2)+1))'],
    [
      'integrate(1/(sqrt(1-1/x^2)*x), x)',
      '(-1/2)*log(1+sqrt(-x^(-2)+1))+(1/2)*log(-1+sqrt(-x^(-2)+1))'
    ],
    ['integrate(exp(2*log(x)),x)', '(1/3)*x^3'],
  ];

  for (var entry in list) {
    var given = entry[0];
    var expected = entry[1];
    try {
      var parsed = Expression.parse(given);
      var result = parsed.simplify();
      if (result.toString() == expected) {
        print('PASS: $given -> $expected');
      } else {
        print(
            'FAIL: $given\n  Expected: $expected\n  Actual  : ${result.toString()}');
      }
    } catch (e) {
      print('ERROR: $given\n  Error: $e');
    }
  }
}
