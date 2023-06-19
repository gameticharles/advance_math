import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('WaveNumber', () {
    test('constructors', () {
      var q = WaveNumber();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, WaveNumber.waveNumberDimensions);
      expect(q.preferredUnits, WaveNumber.reciprocalMeters);
      expect(q.relativeUncertainty, 0);

      q = WaveNumber(reciprocalMeters: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, WaveNumber.waveNumberDimensions);
      expect(q.preferredUnits, WaveNumber.reciprocalMeters);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
