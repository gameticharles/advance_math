import 'package:advance_math/advance_math.dart';

void main() {
  var a = Rational.parse('93222358') / Rational.parse('131836323');
  var b = Rational.parse('549964829') / Rational.parse('38888386');
  var c = a * b - Rational.parse('10');
  print('c = $c');
}
