import 'package:test/test.dart';
import 'package:advance_math/advance_math.dart';

void c(String expr, String exp) {
  try {
    var parsed = Expression.parse(expr);
    String str = parsed.toString();
    if (str == exp) {
      print('✓  $expr');
      return;
    }
    dynamic result = parsed.evaluate();
    str = result.toString();
    if (str == exp) {
      print('✓  $expr');
      return;
    }
    print('✗  $expr\n   exp: $exp\n   got: $str');
    expect(str, equals(exp));
  } catch(e) { 
    print('✗  $expr\n   ERR: $e'); 
    fail(e.toString());
  }
}

void main() {
  test('all', () {
    // ---- Forward Laplace ----
    c('laplace(5, t, s)', '5/s');
    c('laplace(a*t, t, s)', 'a*s^(-2)');
    c('laplace(sin(a*t), t, s)', '(s^2+a^2)^(-1)*a');
    c('laplace(cos(a*t), t, s)', '(s^2+a^2)^(-1)*s');
    c('laplace(sinh(a*t), t, s)', '(s^2-a^2)^(-1)*a');
    c('laplace(2*sqrt(t), t, s)', 's^(-3/2)*sqrt(pi)');

    // ---- ILT: simple poles ----
    c('ilt(1/(s+1), s, t)', 'e^(-t)');
    c('ilt(1/(s^2+1), s, t)', 'sin(t)');
    c('ilt(s/(s^2+1), s, t)', 'cos(t)');

    // ---- ILT: quadratic with scale ----
    c('ilt(3*s/(4*s^2+5),s,t)', '(3/4)*cos((1/2)*sqrt(5)*t)');
    c('ilt(2/(3*s^2+1),s,t)', '2*3^(-1/2)*sin((1/3)*sqrt(3)*t)');
    c('ilt(1/(s^2+s+1),s,t)', '2*e^((-1/2)*t)*3^(-1/2)*sin((1/2)*sqrt(3)*t)');

    // ---- ILT: 3 distinct real poles ----
    c('ilt(((s+1)*(s+2)*(s+3))^(-1), s, t)', '(1/2)*e^(-t)-e^(-2*t)+(1/2)*e^(-3*t)');

    // ---- ILT: repeated real pole ----
    c('ilt(1/(s^2+2s+1),s,t)', 'e^(-t)*t');
  });
}
