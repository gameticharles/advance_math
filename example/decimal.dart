import 'package:advance_math/advance_math.dart';

const precision = 400;

void main() {
  print(PI()); // Output: ~3.141592653589793238462643383

  print(Decimal.parse('1').exp()); // Output: ~2.718281828459045235360287471
  print(Decimal.parse('2').exp()); // Output: ~7.389056098930650227230427461

  print(Decimal.parse('0.5').cos()); // Output: ~0.8775825618903727161162815826
  print(Decimal.parse('0.5').sin()); // Output: ~0.4794255386042030002732879352
  print(Decimal.parse('0.5').tan()); // Output: ~0.5463024898437905
  print(Decimal.parse('0.5').exp());
  print(Decimal.parse('2.0').pow(Decimal.parse('0.5')));
}
