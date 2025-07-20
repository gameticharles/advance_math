import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('AngularMomentum', () {
    test('constructors', () {
      var q = AngularMomentum();
      expect(q.valueSI, Double.zero);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AngularMomentum.angularMometumDimensions);
      expect(q.preferredUnits, AngularMomentum.jouleSecond);
      expect(q.relativeUncertainty, 0);

      q = AngularMomentum(Js: 42, uncert: 0.001);
      expect(q.valueSI.toDouble(), 42);
      expect(q.valueSI is Integer, true);
      expect(q.dimensions, AngularMomentum.angularMometumDimensions);
      expect(q.preferredUnits, AngularMomentum.jouleSecond);
      expect(q.relativeUncertainty, 0.001);
    });
  });
}
