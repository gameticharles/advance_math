import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Frequency', () {
    test('constructors', () {
      var q = Frequency();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Frequency.frequencyDimensions);
      expect(q.preferredUnits, Frequency.hertz);
      expect(q.relativeUncertainty, 0);

      q = Frequency(Hz: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Frequency.frequencyDimensions);
      expect(q.preferredUnits, Frequency.hertz);
      expect(q.relativeUncertainty, 0.001);

      q = Frequency(kHz: 1);
      expect(q.valueSI.toDouble(), 1000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Frequency.frequencyDimensions);
      expect(q.preferredUnits, Frequency.kilohertz);
      expect(q.relativeUncertainty, 0);

      q = Frequency(MHz: 1);
      expect(q.valueSI.toDouble(), 1000000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Frequency.frequencyDimensions);
      expect(q.preferredUnits, Frequency.megahertz);
      expect(q.relativeUncertainty, 0);

      q = Frequency(GHz: 1);
      expect(q.valueSI.toDouble(), 1000000000);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, Frequency.frequencyDimensions);
      expect(q.preferredUnits, Frequency.gigahertz);
      expect(q.relativeUncertainty, 0);
    });
  });
}
