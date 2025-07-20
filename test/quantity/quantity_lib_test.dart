import 'dart:math';
import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Quantity Library', () {
    test('createTypedQuantityInstance', () {
      var q = createTypedQuantityInstance(Length, 5.6, LengthUnits.meters);
      expect(q is Length, true);
      expect(q.valueSI is Double, true);
      expect(q.valueSI.toDouble(), 5.6);
      expect(q.preferredUnits, LengthUnits.meters);
      expect(q.relativeUncertainty, 0.0);

      // non-default units
      q = createTypedQuantityInstance(Length, 12.34567, LengthUnits.kilometers);
      expect(q is Length, true);
      expect(q.valueSI is Double, true);
      expect(q.valueSI.toDouble(), 12345.67);
      expect(q.preferredUnits, LengthUnits.kilometers);
      expect(q.relativeUncertainty, 0.0);

      // null units
      q = createTypedQuantityInstance(Length, 9.876, null);
      expect(q is Length, true);
      expect(q.valueSI is Double, true);
      expect(q.valueSI.toDouble(), 9.876);
      expect(q.preferredUnits, LengthUnits.meters);
      expect(q.relativeUncertainty, 0.0);

      // null value & units
      q = createTypedQuantityInstance(Length, null, null);
      expect(q is Length, true);
      expect(q.valueSI, Double.zero);
      expect(q.preferredUnits, LengthUnits.meters);
      expect(q.relativeUncertainty, 0.0);

      // uncertainty
      q = createTypedQuantityInstance(Length, 23.45, LengthUnits.meters,
          uncert: 0.015);
      expect(q is Length, true);
      expect(q.valueSI.toDouble(), 23.45);
      expect(q.preferredUnits, LengthUnits.meters);
      expect(q.relativeUncertainty, 0.015);

      // types
      expect(createTypedQuantityInstance(Mass, 1.1, null) is Mass, true);
      expect(createTypedQuantityInstance(Time, 1.1, null) is Time, true);
      expect(
          createTypedQuantityInstance(TemperatureInterval, 1.1, null)
              is TemperatureInterval,
          true);
      expect(
          createTypedQuantityInstance(AmountOfSubstance, 1.1, null)
              is AmountOfSubstance,
          true);
      expect(createTypedQuantityInstance(Current, 1.1, null) is Current, true);
      expect(
          createTypedQuantityInstance(
                  LuminousIntensity, 1.1, LuminousIntensity.candelas)
              is LuminousIntensity,
          true);

      expect(createTypedQuantityInstance(Scalar, 1.1, null) is Scalar, true);
      expect(
          createTypedQuantityInstance(Angle, 1.1, AngleUnits.degrees,
              uncert: 13.2) is Angle,
          true);
      expect(createTypedQuantityInstance(SolidAngle, 1.1, null) is SolidAngle,
          true);

      final random = Random();
      for (final t in allQuantityTypes) {
        try {
          final q = createTypedQuantityInstance(t, 1.1, null,
              uncert: random.nextDouble() * 10.0);
          expect(q.runtimeType == t, true);
        } catch (err) {
          expect(err, isNull);
        }
      }
    });

    test('areWithin', () {
      final s1 = Scalar(value: 7.11);
      final s2 = Scalar(value: 9.45);
      expect(areWithin(s1, s2, Scalar(value: 3)), true);
      expect(areWithin(s1, s2, Scalar(value: 2)), false);
      expect(areWithin(s1, s2, Scalar(value: 2.341)), true);
      expect(areWithin(s1, s2, Scalar(value: 2.339)), false);
      expect(areWithin(s1, s2, Scalar(value: 2.34)), true);
    });
  });
}
