import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('LuminousIntensity', () {
    test('constructors', () {
      var a = LuminousIntensity();
      expect(a, isNotNull);
      expect(a.valueSI, Double.zero);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, LuminousIntensity.luminousIntensityDimensions);
      expect(a.preferredUnits, LuminousIntensity.candelas);

      a = LuminousIntensity(cd: 2.4);
      expect(a, isNotNull);
      expect(a.valueSI.toDouble(), 2.4);
      expect(a.valueSI is Double, true);
      expect(a.dimensions, LuminousIntensity.luminousIntensityDimensions);
      expect(a.preferredUnits, LuminousIntensity.candelas);
    });
  });
}
