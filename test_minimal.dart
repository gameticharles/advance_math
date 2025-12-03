import 'package:advance_math/advance_math.dart';

void main() {
  print('Test 1: Parse equation');
  var eq = Expression.parse('x^2-1=0');
  print('Parsed: $eq (type: ${eq.runtimeType})');
  print('Done!');
}
