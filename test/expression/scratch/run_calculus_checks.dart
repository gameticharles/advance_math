import 'package:advance_math/advance_math.dart';

void main() {
  final list = [
    ['diff(cos(x),x)', '-sin(x)'],
    ['diff(log(x),x)', '-1/x'],
    ['diff(tan(x),x)', 'sec(x)^2'],
    ['diff(4*tan(x)*sec(x),x)', '4*(sec(x)*tan(x)^2+sec(x)^3)'],
    ['diff(sqrt(7),x)', '0'],
    ['diff(4,x)', '0'],
    ['diff(x^2,x)', '2*x'],
    ['diff(2*x^2+4,x)', '4*x'],
    ['diff(sqrt(x)*x,x)', '(3/2)*x^(1/2)'],
    ['diff(sqrt(x)-1/sqrt(x),x)', '(1/2)*x^(-1/2)+(1/2)*x^(-3/2)'],
    ['diff(x^2/3-3/x^2,x)', '(2/3)*x+6*x^(-3)'],
    ['diff(sqrt(x)*(x^2+1),x)', '(1/2)*(1+x^2)*x^(-1/2)+2*x^(3/2)'],
    ['diff(e^x/(e^x-1),x)', '(-1+e^x)^(-1)*e^x-(-1+e^x)^(-2)*e^(2*x)'],
    ['diff(e^x,x)', 'e^x'],
    ['diff(e^x/x,x)', '-e^x*x^(-2)+e^x*x^(-1)'],
    [
      'diff(tan(x)*log(1/cos(x)),x)',
      '-(-cos(x)^(-1)*sin(x)*tan(x)+log(cos(x))*sec(x)^2)'
    ],
    ['diff((2*x)^(e),x)', '2^e*e*x^(-1+e)'],
    ['diff(2*cos(x)*log(x),x)', '2*(-log(x)*sin(x)+cos(x)*x^(-1))'],
    [
      'diff(cos(5*x)*log(sec(sqrt(cos(x^(4/5))^2))/y^2)*y,x)',
      '(-4/5)*abs(cos(x^(4/5)))^(-1)*cos(x^(4/5))*sec(abs(cos(x^(4/5))))*sin(x^(4/5))*tan(abs(cos(x^(4/5))))*x^(-1/5)*y^(-2)*cos(5*x)*sec(abs(cos(x^(4/5))))^(-1)*y^3-5*log(sec(abs(cos(x^(4/5))))*y^(-2))*sin(5*x)*y'
    ],
    [
      'diff(x*cos(x)^log(x),x)',
      '(-cos(x)^(-1)*log(x)*sin(x)+log(cos(x))*x^(-1))*cos(x)^log(x)*x+cos(x)^log(x)'
    ],
    ['diff(cos(2*x),x)', '-2*sin(2*x)'],
    ['diff(cos(x)*tan(x),x)', '-sin(x)*tan(x)+cos(x)*sec(x)^2'],
    [
      'diff(sec(sqrt(cos(x^(4/5))^2)),x)',
      '(-4/5)*abs(cos(x^(4/5)))^(-1)*cos(x^(4/5))*sec(abs(cos(x^(4/5))))*sin(x^(4/5))*tan(abs(cos(x^(4/5))))*x^(-1/5)'
    ],
    [
      'diff(log(log(log(cos(t*t)^z))),t)',
      '-2*cos(t^2)^(-1)*sin(t^2)*t*z*log(cos(t^2))^(-1)*log(log(cos(t^2))*z)^(-1)*z^(-1)'
    ],
    [
      'diff(6*log(x)^(3*log(x^2)),x)',
      '36*(log(log(x))*x^(-1)+x^(-1))*log(x)^(6*log(x))'
    ],
    [
      'diff(sinh(x^2)^cos(x),x)',
      '(-log(sinh(x^2))*sin(x)+2*cos(x)*cosh(x^2)*sinh(x^2)^(-1)*x)*sinh(x^2)^cos(x)'
    ],
    ['diff(tan(x)*tanh(x),x)', 'sec(x)^2*tanh(x)+sech(x)^2*tan(x)'],
    [
      'diff(4*x*tan(x)*7*tanh(x),x)',
      '28*(sec(x)^2*tanh(x)*x+sech(x)^2*tan(x)*x+tan(x)*tanh(x))'
    ],
    ['diff(y*tan(y)*7*tanh(y),x)', '0'],
    ['diff(yx*tan(y)*7*tanh(y),x)', '0'],
    ['diff(y,x)', '0'],
    ['diff(x*y,x)', 'y'],
    ['diff([sin(x), x^2, x],x)', '[cos(x),2*x,1]'],
    [
      'diff(sinc(a*x^3+b),x)',
      '3*((a*x^3+b)*cos(a*x^3+b)-sin(a*x^3+b))*(a*x^3+b)^(-2)*a*x^2'
    ],
    ['diff(sqrt(e^x + a),x)', '(1/2)*(a+e^x)^(-1/2)*e^x'],
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
