import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('angle ext', () {
    test('common angles', () {
      //Scalar s = Scalar(value:42);
      expect(angle270, isNotNull);
      expect(angle270.valueInUnits(AngleUnits.degrees).toDouble(), 270.0);
      expect(angle360, isNotNull);
    });
  });
}
