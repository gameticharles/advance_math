import 'package:advance_math/advance_math.dart';

void main() {
  final rat = Rational(19992598074486523, 200000000000000000);
  final c1 = Complex(rat);
  final c2 = Complex(0.3333333333333333);
  final result = c1.pow(c2);
  print('c1: $c1, c2: $c2, result: $result');
}
