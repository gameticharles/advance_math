import 'package:advance_math/advance_math.dart';

void main() {
  print('Starting...');
  try {
    print('About to parse...');
    var eq = Expression.parse('2+2');
    print('Parsed: $eq');
    print('Result: ${eq.evaluate()}');
  } catch (e, s) {
    print('Error: $e');
    print(s);
  }
  print('Done!');
}
