import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void c(String expr, String exp) {
  try {
    var r = Expression.parse(expr).evaluate().toString();
    print('${r == exp ? "✓" : "✗"}  $expr${r != exp ? "\n   exp: $exp\n   got: $r" : ""}');
  } catch(e) { print('✗  $expr\n   ERR: $e'); }
}

void main() {
  test('q', () {
    c('laplace(2*sqrt(t), t, s)', 's^(-3/2)*sqrt(pi)');
    c('ilt(1/(s^2+1), s, t)', 'sin(t)');
    c('ilt(s/(s^2+1), s, t)', 'cos(t)');
    c('ilt(3*s/(4*s^2+5),s,t)', '(3/4)*cos((1/2)*sqrt(5)*t)');
    c('ilt(2/(3*s^2+1),s,t)', '2*sin((1/3)*sqrt(3)*t)*sqrt(3)^(-1)');
    c('ilt(((s+1)*(s+2)*(s+3))^(-1), s, t)', '(1/2)*e^(-3*t)+(1/2)*e^(-t)-e^(-2*t)');
    c('ilt(1/(s^2+s+1),s,t)', '2*e^((-1/2)*t)*sin((1/2)*sqrt(3)*t)*sqrt(3)^(-1)');
    c('ilt(1/(s^2+2s+1),s,t)', 'e^(-t)*t');
  });
}
