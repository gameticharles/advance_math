import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Length', () {
    test('constructors -default', () {
      // default ctor, meters 0
      var a = Length();
      expect(a.valueSI, Double.zero);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, Length.lengthDimensions);
      expect(a.preferredUnits, LengthUnits.meters);
      expect(a.relativeUncertainty, 0);

      // default ctor, meters +
      a = Length(m: 42);
      expect(a.valueSI.toDouble(), 42);
      expect(a.valueSI is Integer, true);
      expect(a.dimensions, Length.lengthDimensions);
      expect(a.preferredUnits, LengthUnits.meters);
      expect(a.relativeUncertainty, 0);

      // default ctor, meters -
      a = Length(m: -99.33);
      expect(a.valueSI.toDouble(), -99.33);
      expect(a.valueSI is Double, true);
      expect(a.dimensions, Length.lengthDimensions);
      expect(a.preferredUnits, LengthUnits.meters);
      expect(a.relativeUncertainty, 0);

      // default ctor, kilometers
      a = Length(km: 76.54321);
      expect(a.valueSI.toDouble(), 76543.21);
      expect(a.preferredUnits, LengthUnits.kilometers);
      expect(a.relativeUncertainty, 0);

      // default ctor, millimeters
      a = Length(mm: 12345.6789);
      expect(a.valueSI.toDouble(), closeTo(12.3456789, 0.00001));
      expect(a.preferredUnits, LengthUnits.millimeters);
      expect(a.relativeUncertainty, 0);

      // default ctor, astronomical units
      a = Length(ua: 0.001);
      expect(a.valueSI.toDouble(), closeTo(1.495978707e8, 0.00001));
      expect(a.preferredUnits, LengthUnits.astronomicalUnits);
      expect(a.relativeUncertainty, 0);

      // default ctor, nautical miles
      a = Length(NM: 200.0);
      expect(a.valueSI.toDouble(), closeTo(3.704e5, 0.00001));
      expect(a.preferredUnits, LengthUnits.nauticalMiles);
      expect(a.relativeUncertainty, 0);
    });

    test('constructors - default (uncertainty)', () {
      var a = Length(m: 0, uncert: 0.01);
      expect(a.relativeUncertainty, 0.01);

      a = Length(km: 0, uncert: 0.0001);
      expect(a.relativeUncertainty, 0.0001);
    });

    test('operator - unary negation', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 5);
      final b = Length(m: -7);
      final c = Length(m: 5.4);
      final d = Length(m: -83.521);

      final dynamic a2 = -a;
      expect(a2.valueSI?.toDouble(), -5);
      expect(a2.valueSI is Integer, true);
      expect(a2 is Length, true);

      final dynamic b2 = -b;
      expect(b2.valueSI?.toDouble(), 7);
      expect(b2.valueSI is Integer, true);
      expect(b2 is Length, true);

      final dynamic c2 = -c;
      expect(c2.valueSI?.toDouble(), -5.4);
      expect(c2.valueSI is Double, true);
      expect(c2 is Length, true);

      final dynamic d2 = -d;
      expect(d2.valueSI?.toDouble(), 83.521);
      expect(d2.valueSI is Double, true);
      expect(d2 is Length, true);
    });

    test('operator - addition', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 5.4);
      final b = Length(m: 83.521);

      final dynamic c = a + b;
      expect(c.valueSI?.toDouble(), 88.921);
      expect(c.valueSI is Double, true);
      expect(c is Length, true);

      final dynamic d = a + b + b + a;
      expect(d.valueSI?.toDouble(), 177.842);
      expect(d.valueSI is Double, true);
      expect(d is Length, true);
    });

    test('operator - subtraction', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 75.3);
      final b = Length(m: 17.11);
      final c = Length(m: -4.2);

      final dynamic aa = a - b;
      expect(aa.valueSI == 58.19, true);
      expect(aa.valueSI is Double, true);
      expect(aa is Length, true);

      final dynamic bb = a - c;
      expect(bb.valueSI == 79.5, true);
      expect(bb.valueSI is Double, true);
      expect(bb is Length, true);
    });

    test('operator - multiplication', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 0.3);
      final b = Length(m: 42.0);
      final c = Length(m: -4.5);

      final dynamic aa = a * b;
      expect(aa.valueSI == 12.6, true);
      expect(aa.valueSI is Double, true);
      expect(aa.dimensions.equalsSI(Area.areaDimensions), true);
      expect(aa is Area, true);

      final dynamic bb = a * c;
      expect(bb.valueSI.toDouble(), closeTo(-1.35, 0.000001));
      expect(bb.valueSI is Double, true);
      expect(bb.dimensions.equalsSI(Area.areaDimensions), true);
      expect(bb is Area, true);
    });

    test('operator - division', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 0.3);
      final b = Length(m: 42.0);
      final c = Length(m: -4.5);

      final dynamic aa = b / a;
      expect(aa.valueSI == 140.0, true);
      expect(aa.valueSI is Integer, true);
      expect(aa.dimensions.equalsSI(Scalar.scalarDimensions), true);
      expect(aa is Scalar, true);

      final dynamic bb = a / c;
      expect(bb.valueSI.toDouble(), closeTo(0.3 / -4.5, 0.000001));
      expect(bb.valueSI is Double, true);
      expect(bb.dimensions.equalsSI(Scalar.scalarDimensions), true);
      expect(bb is Scalar, true);

      final dynamic cc = b / 14;
      expect(cc.valueSI == 3, true);
      expect(cc.valueSI is Integer, true);
      expect(cc.dimensions.equalsSI(Length.lengthDimensions), true);
      expect(cc is Length, true);

      final dynamic dd = b / Scalar(value: 21);
      expect(dd.valueSI == 2, true);
      expect(dd.valueSI is Integer, true);
      expect(dd.dimensions.equalsSI(Length.lengthDimensions), true);
      expect(dd is Length, true);

      final dynamic ee = b / Time(s: 4);
      expect(ee.valueSI == 10.5, true);
      expect(ee.valueSI is Double, true);
      expect(ee.dimensions.equalsSI(Speed.speedDimensions), true);
      expect(ee is Speed, true);

      final dynamic ff = b / Speed(metersPerSecond: 10.5);
      expect(ff.valueSI == 4, true);
      expect(ff.valueSI is Integer, true);
      print('Expecting time dimensions:');
      print(ff.dimensions);
      expect(ff.dimensions.equalsSI(Time.timeDimensions), true);
      expect(ff is Time, true);
    });

    test('operator - power', () {
      dynamicQuantityTyping = true;
      final a = Length(m: 2);

      final dynamic aa = a ^ 2;
      expect(aa.valueSI == 4, true);
      expect(aa.valueSI is Integer, true);
      expect(aa.dimensions.equalsSI(Area.areaDimensions), true);
      expect(aa is Area, true);

      final dynamic bb = a ^ 3;
      expect(bb.valueSI == 8, true);
      expect(bb.valueSI is Integer, true);
      expect(bb.dimensions.equalsSI(Volume.volumeDimensions), true);
      expect(bb is Volume, true);

      final dynamic cc = a ^ 2.5;
      expect(cc.valueSI is Double, true);
      expect(cc.dimensions.getComponentExponent('Length'), 2.5);
      expect(cc is MiscQuantity, true);

      final dynamic dd = a ^ 1;
      expect(identical(a, dd), true);

      final dynamic ee = a ^ 0;
      expect(identical(ee, Scalar.one), true);
    });

    test('operator - less than', () {
      final a = Length(m: 75.3);
      final b = Length(m: 17.11);
      final c = Length(m: -4.2);
      final d = Length(m: -4003.2);

      expect(a < a, false);
      expect(a < b, false);
      expect(a < c, false);
      expect(a < d, false);

      expect(b < a, true);
      expect(b < b, false);
      expect(b < c, false);
      expect(b < d, false);

      expect(c < a, true);
      expect(c < b, true);
      expect(c < c, false);
      expect(c < d, false);

      expect(d < a, true);
      expect(d < b, true);
      expect(d < c, true);
      expect(d < d, false);
    });

    test('operator - less than equals', () {
      final a = Length(m: 75.3);
      final b = Length(m: 17.11);
      final c = Length(m: -4.2);
      final d = Length(m: 75.3);
      final e = Length(m: 2317.11);

      expect(a <= a, true);
      expect(a <= b, false);
      expect(a <= c, false);
      expect(a <= d, true);
      expect(a <= e, true);
    });

    test('operator - greater than', () {
      final a = Length(m: 75.3);
      final b = Length(m: 17.11);
      final c = Length(m: -4.2);
      final d = Length(m: -4003.2);

      expect(a > a, false);
      expect(a > b, true);
      expect(a > c, true);
      expect(a > d, true);

      expect(b > a, false);
      expect(b > b, false);
      expect(b > c, true);
      expect(b > d, true);

      expect(c > a, false);
      expect(c > b, false);
      expect(c > c, false);
      expect(c > d, true);

      expect(d > a, false);
      expect(d > b, false);
      expect(d > c, false);
      expect(d > d, false);
    });

    test('operator - greater than equals', () {
      final a = Length(m: 75.3);
      final b = Length(m: 17.11);
      final c = Length(m: -4.2);
      final d = Length(m: 75.3);
      final e = Length(m: 2317.11);

      expect(a >= a, true);
      expect(a >= b, true);
      expect(a >= c, true);
      expect(a >= d, true);
      expect(a >= e, false);
    });

    test('valueInUnits', () {
      final a = Length(m: 75.3);
      expect(a.valueInUnits(LengthUnits.meters).toDouble(), 75.3);
    });

    test('units - metric', () {
      expect(LengthUnits.meters.valueSI.toDouble() == 1, true);

      expect((LengthUnits.meters.yotta() as Length).valueSI.toDouble() == 1e24,
          true);
      expect((LengthUnits.meters.zetta() as Length).valueSI.toDouble() == 1e21,
          true);
      expect((LengthUnits.meters.exa() as Length).valueSI.toDouble() == 1e18,
          true);
      expect((LengthUnits.meters.peta() as Length).valueSI.toDouble() == 1e15,
          true);
      expect((LengthUnits.meters.tera() as Length).valueSI.toDouble() == 1e12,
          true);
      expect((LengthUnits.meters.giga() as Length).valueSI.toDouble() == 1e9,
          true);
      expect((LengthUnits.meters.mega() as Length).valueSI.toDouble() == 1e6,
          true);
      expect(LengthUnits.kilometers.valueSI.toDouble() == 1000, true);
      expect((LengthUnits.meters.hecto() as Length).valueSI.toDouble() == 100,
          true);
      expect(
          (LengthUnits.meters.deka() as Length).valueSI.toDouble() == 10, true);
      expect((LengthUnits.meters.deci() as Length).valueSI.toDouble() == 0.1,
          true);
      expect(LengthUnits.centimeters.valueSI.toDouble() == 0.01, true);
      expect(LengthUnits.millimeters.valueSI.toDouble() == 0.001, true);
      expect((LengthUnits.meters.micro() as Length).valueSI.toDouble() == 1e-6,
          true);
      expect(LengthUnits.nanometers.valueSI.toDouble() == 1e-9, true);
      expect((LengthUnits.meters.pico() as Length).valueSI.toDouble() == 1e-12,
          true);
      expect((LengthUnits.meters.femto() as Length).valueSI.toDouble() == 1e-15,
          true);
      expect((LengthUnits.meters.atto() as Length).valueSI.toDouble() == 1e-18,
          true);
      expect((LengthUnits.meters.zepto() as Length).valueSI.toDouble() == 1e-21,
          true);
      expect((LengthUnits.meters.yocto() as Length).valueSI.toDouble() == 1e-24,
          true);
    });

    test('outputText', () {
      final dynamic a = Length(m: 75.3);
      final buf = StringBuffer();
      a.outputText(buf);
      expect(buf.toString(), '75.3 m');
    });
  });
}
