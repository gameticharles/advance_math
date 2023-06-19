import 'dart:math' show pi;
import 'package:advance_math/src/quantity/quantity.dart';
import 'package:test/test.dart';

void main() {
  group('AngleRange', () {
    test('constructors', () {
      final range = AngleRange(Angle(deg: 15), Angle(deg: 70.1));
      expect(range, isNotNull);
    });

    test('endpoint getters', () {
      var range = AngleRange(Angle(rad: 2.4), Angle(rad: 0.9));
      expect(range.startAngle.valueSI.toDouble() == 2.4, true);
      expect(range.endAngle.valueSI.toDouble() == 0.9, true);

      range = AngleRange(Angle(rad: 0.3), Angle(rad: 0.9));
      expect(range.startAngle.valueSI.toDouble() == 0.3, true);
      expect(range.endAngle.valueSI.toDouble() == 0.9, true);

      range = AngleRange.degrees(90, 180);
      expect(range.startAngle.valueSI.toDouble(), closeTo(pi / 2, 0.0001));
      expect(range.endAngle.valueSI.toDouble(), closeTo(pi, 0.0001));

      range = AngleRange.degrees(180, 90);
      expect(range.startAngle.valueSI.toDouble(), closeTo(pi, 0.0001));
      expect(range.endAngle.valueSI.toDouble(), closeTo(pi / 2, 0.0001));

      range = AngleRange.radians(1.72, 1.95);
      expect(range.startAngle.valueSI.toDouble() == 1.72, true);
      expect(range.endAngle.valueSI.toDouble() == 1.95, true);

      range = AngleRange.radians(1.95, 1.72);
      expect(range.startAngle.valueSI.toDouble() == 1.95, true);
      expect(range.endAngle.valueSI.toDouble() == 1.72, true);
    });

    test('revolutions', () {
      var range = AngleRange(Angle(deg: 15), Angle(deg: 70.1));
      expect(range.revolutions, 0);

      range = AngleRange(Angle(deg: 15), Angle(deg: 470.1));
      expect(range.revolutions, 1);

      range = AngleRange(Angle(deg: 0), Angle(deg: 3605));
      expect(range.revolutions, 10);

      range = AngleRange(Angle(deg: 15), Angle(deg: -70.1));
      expect(range.revolutions, 0);

      range = AngleRange(Angle(deg: 15), Angle(deg: -470.1));
      expect(range.revolutions, -1);

      range = AngleRange(Angle(deg: 0), Angle(deg: -3605));
      expect(range.revolutions, -10);
    });

    test('clockwise/counterclockwise', () {
      var range = AngleRange(Angle(deg: 15), Angle(deg: 70.1));
      expect(range.isClockwise, true);
      expect(range.isCounterclockwise, false);
      expect(range.isAnticlockwise, false);

      range = AngleRange(Angle(deg: 90), Angle(deg: -40));
      expect(range.isClockwise, false);
      expect(range.isCounterclockwise, true);
      expect(range.isAnticlockwise, true);
    });

    test('ranges360', () {
      var range = AngleRange(Angle(deg: 15), Angle(deg: 70.1));
      var list = range.ranges360;
      expect(list.length, 1);
      expect(list[0].startAngle == Angle(deg: 15), true);
      expect(list[0].endAngle == Angle(deg: 70.1), true);

      range = AngleRange(Angle(deg: 5), Angle(deg: 370));
      list = range.ranges360;
      expect(list.length, 1);
      expect(list[0].startAngle == Angle(deg: 0), true);
      expect(list[0].endAngle == Angle(deg: 360), true);

      range = AngleRange(Angle(deg: -25), Angle(deg: 45));
      list = range.ranges360;
      expect(list.length, 2);
      expect(list[0].startAngle == Angle(deg: 0), true);
      expect(list[0].endAngle.valueSI.toDouble(),
          closeTo(Angle(deg: 45).valueSI.toDouble(), 0.00001));
      expect(list[1].startAngle.valueSI.toDouble(),
          closeTo(Angle(deg: 335).valueSI.toDouble(), 0.00001));
      expect(list[1].endAngle == Angle(deg: 360), true);
    });

    test('contains/contains360', () {
      final range = AngleRange(Angle(deg: 15), Angle(deg: 70.1));
      expect(range.contains(Angle(deg: 55)), true);
      expect(range.contains(Angle(deg: 155)), false);
      expect(range.contains(Angle(deg: 15)), true);
      expect(range.contains(Angle(deg: 70.1)), true);
      expect(range.contains(Angle(deg: 15), false, 0), false);
      expect(range.contains(Angle(deg: 70.1), false, 0), false);
      expect(range.contains(Angle(deg: 380), false, 0), false);
      expect(range.contains(Angle(deg: -300), false, 0), false);

      expect(range.contains360(Angle(deg: 55)), true);
      expect(range.contains360(Angle(deg: 155)), false);
      expect(range.contains360(Angle(deg: 15)), true);
      expect(range.contains360(Angle(deg: 70.1)), true);
      expect(range.contains360(Angle(deg: 15), false, 0), false);
      expect(range.contains360(Angle(deg: 70.1), false, 0), false);
      expect(range.contains360(Angle(deg: 380)), true);
      expect(range.contains360(Angle(deg: -300)), true);
      expect(range.contains360(Angle(deg: 375), true), true);
      expect(range.contains360(Angle(deg: 430.1), true), true);
      expect(range.contains360(Angle(deg: 375), false, 0), false);
      expect(range.contains360(Angle(deg: 430.0000009), false, 0.0), true);
      expect(range.contains360(Angle(deg: 430.1), false, 1.0e-15), true);
      expect(range.contains360(Angle(deg: 430.1), true, 0), true);
      expect(range.contains360(Angle(deg: 430.1000001), false, 0.0), false);
      expect(range.contains360(Angle(deg: -345), true, 0.0), true);
      expect(range.contains360(Angle(deg: 259.9), false), false);
      expect(range.contains360(Angle(deg: -345), true, 0), true);
      expect(range.contains360(Angle(deg: -289.9), true), true);
    });

    test('angleClosestTo', () {
      final ang15 = Angle(deg: 15);
      final ang45 = Angle(deg: 45);
      final range = AngleRange(ang15, ang45);
      expect(range.angleClosestTo(angle0), ang15);
      expect(range.angleClosestTo(angle90), ang45);
      expect(range.angleClosestTo(angle180), ang45);
      expect(range.angleClosestTo(angle270), ang15);

      // Flipped range.
      final rangeFlip = AngleRange(ang45, ang15);
      expect(rangeFlip.angleClosestTo(angle0), ang15);
      expect(rangeFlip.angleClosestTo(angle90), ang45);
      expect(rangeFlip.angleClosestTo(angle180), ang45);
      expect(rangeFlip.angleClosestTo(angle270), ang15);
    });

    test('operator ==', () {
      final a1 = Angle(rad: 1.5);
      final a2 = Angle(deg: 234.5);
      final a3 = Angle(rad: 1.5);
      expect(a1 == a2, false);
      expect(a2 == a3, false);
      expect(a1 == a3, true);
      expect(a3 == a1, true);
    });

    test('hashCode', () {
      final a1 = Angle(rad: 1.5);
      final a2 = Angle(deg: 234.5);
      final a3 = Angle(rad: 1.5);

      expect(a1.hashCode == a2.hashCode, false);
      expect(a2.hashCode == a3.hashCode, false);
      expect(a1.hashCode == a3.hashCode, true);
    });
  });
}
