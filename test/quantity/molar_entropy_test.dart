import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('MolarEntropy', () {
    test('constructors', () {
      var q = MolarEntropy();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MolarEntropy.molarEntropyDimensions);
      expect(q.preferredUnits, MolarEntropy.joulesPerMoleKelvin);
      expect(q.relativeUncertainty, 0);

      q = MolarEntropy(joulesPerMoleKelvin: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, MolarEntropy.molarEntropyDimensions);
      expect(q.preferredUnits, MolarEntropy.joulesPerMoleKelvin);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
