import 'package:test/test.dart';
import 'package:advance_math/src/quantity/quantity.dart';

void main() {
  group('Uncertainty', () {
    test('constructors', () {
      var q = Length();
      expect(q.relativeUncertainty, 0);
      expect(q.standardUncertainty, Length(m: 0));

      q = Length(m: 5, uncert: 0.1);
      expect(q.relativeUncertainty, 0.1);
      expect(q.standardUncertainty, Length(m: 0.5));

      q = Length(m: 10, uncert: 0.001);
      expect(q.relativeUncertainty, 0.001);
      expect(q.standardUncertainty, Length(m: 0.01));

      q = Length(m: -10, uncert: 0.001);
      expect(q.relativeUncertainty, 0.001);
      expect(q.standardUncertainty, Length(m: 0.01));

      q = const Length.constant(Double.constant(6.5), uncert: 0.078);
      expect(q.relativeUncertainty, 0.078);
      expect(q.standardUncertainty, Length(m: 0.507));

      final misc =
          MiscQuantity(Double(99.9), SolidAngle.solidAngleDimensions, 0.0003);
      expect(misc.relativeUncertainty, 0.0003);
      expect(misc.standardUncertainty, SolidAngle(sr: 0.02997));
    });

    test('calcRelativeCombinedUncertaintySumDiff', () {
      final q1 = Length(m: 10, uncert: 0.01);
      final q2 = Length(m: 4, uncert: 0.002);
      final sumValueSI = q1.valueSI + q2.valueSI;
      final urSum =
          Quantity.calcRelativeCombinedUncertaintySumDiff(q1, q2, sumValueSI);
      expect(urSum, closeTo(7.165678e-3, 0.000001e-3));

      final diffValueSI = q1.valueSI - q2.valueSI;
      final urDiff =
          Quantity.calcRelativeCombinedUncertaintySumDiff(q1, q2, diffValueSI);
      expect(urDiff, closeTo(1.6719915e-2, 0.000001e-2));
    });

    test('quantity sum', () {
      final q1 = Mass(kg: 1000.08, uncert: 0.014);
      final q2 = Mass(kg: 437.01, uncert: 0.023);
      final sum = q1 + q2 as Mass;
      expect(sum.valueSI.toDouble(), closeTo(1437.09, 1e-12));
      expect(sum.relativeUncertainty, closeTo(0.011993256, 0.00000001));

      // Scalar.
      final s = Scalar(value: 100, uncert: 0.01);
      expect(s.relativeUncertainty, 0.01);
      expect(s.standardUncertainty.valueSI.toDouble(), 1);
      final sum2 = s + 100 as Scalar;
      expect(sum2.standardUncertainty.valueSI.toDouble(), 1);
      expect(sum2.relativeUncertainty, 0.005);
    });

    test('quantity difference', () {
      final q1 = Mass(kg: 1000.08, uncert: 0.014);
      final q2 = Mass(kg: 437.01, uncert: 0.023);
      final diff = q1 - q2 as Mass;
      expect(diff.valueSI.toDouble(), closeTo(563.07, 1e-12));
      expect(diff.relativeUncertainty, closeTo(0.030609671, 0.00000001));

      // Scalar.
      final s = Scalar(value: 200, uncert: 0.01);
      expect(s.relativeUncertainty, 0.01);
      expect(s.standardUncertainty.valueSI.toDouble(), 2);
      final diff2 = s - 100 as Scalar;
      expect(diff2.standardUncertainty.valueSI.toDouble(), 2);
      expect(diff2.relativeUncertainty, 0.02);
    });

    test('quantity product', () {
      final q1 = Mass(kg: 1000.08, uncert: 0.014);
      final q2 = Mass(kg: 437.01, uncert: 0.023);
      final prod = q1 * q2 as MiscQuantity;
      expect(prod.valueSI.toDouble(), closeTo(437044.9608, 1e-4));
      expect(prod.relativeUncertainty, closeTo(0.026925824, 0.000000001));

      // Scalar.
      final prod2 = q1 * 100 as Mass;
      expect(prod2.relativeUncertainty, 0.014);
      expect(prod2.standardUncertainty.valueSI.toDouble(), 1400.112);

      final prod3 = q1 * Scalar(value: 1000, uncert: 0.1) as Mass;
      expect(prod3.relativeUncertainty, 0.10097524449091472);
      expect(prod3.standardUncertainty.valueSI.toDouble(), 100983.322510474);
    });

    test('quantity division', () {
      final q1 = Mass(kg: 1000.08, uncert: 0.014);
      final q2 = Time(s: 437.01, uncert: 0.023);
      final div = q1 / q2 as MassFlowRate;
      expect(div.valueSI.toDouble(), closeTo(2.288460218, 1e-9));
      expect(div.relativeUncertainty, closeTo(0.026925824, 0.000000001));

      // Scalar.
      final div2 = q1 / 100 as Mass;
      expect(div2.relativeUncertainty, 0.014);
      expect(div2.standardUncertainty.valueSI.toDouble(), 0.1400112);

      final div3 = q1 / Scalar(value: 1000, uncert: 0.1) as Mass;
      expect(div3.relativeUncertainty, 0.10097524449091472);
      expect(div3.standardUncertainty.valueSI.toDouble(), 0.100983322510474);
    });

    test('expanded uncertainty', () {
      var q = Length(m: 5, uncert: 0.1);
      expect(q.relativeUncertainty, 0.1);
      expect(q.standardUncertainty, Length(m: 0.5));
      expect(q.calcExpandedUncertainty(1), Length(m: 0.5));
      expect(q.calcExpandedUncertainty(2), Length(m: 1.0));
      expect(q.calcExpandedUncertainty(3), Length(m: 1.5));
      expect(q.calcExpandedUncertainty(7.2), Length(m: 3.6));

      q = Length(m: -5, uncert: 0.1);
      expect(q.relativeUncertainty, 0.1);
      expect(q.standardUncertainty, Length(m: 0.5));
      expect(q.calcExpandedUncertainty(1), Length(m: 0.5));
      expect(q.calcExpandedUncertainty(2), Length(m: 1.0));
      expect(q.calcExpandedUncertainty(3), Length(m: 1.5));
      expect(q.calcExpandedUncertainty(7.2), Length(m: 3.6));
    });

    test('random sample', () {
      // Zero uncertainty should return the quantity itself.
      final q1 = Mass(kg: 1000.08);
      final q = q1.randomSample();
      expect(q is Mass, true);
      expect(q.valueSI.toDouble(), 1000.08);
      expect(identical(q1, q), true);

      // Non-zero uncertainty should return a different quantity of the same type.
      final q2 = Mass(kg: 1000.08, uncert: 0.001);
      final q2b = q2.randomSample();
      expect(q2b is Mass, true);
      expect(q2b.valueSI.toDouble(), closeTo(1000.08, 100));
      expect(identical(q2, q2b), false);
    });

    test('output', () {
      final q1 = Mass(kg: 1000.08, uncert: 0.002);
      final buf = StringBuffer();
      q1.outputText(buf);
      expect(buf.toString(), '1000.08 kg');

      buf.clear();
      q1.outputText(buf,
          uncertFormat: UncertaintyFormat.none,
          numberFormat: ScientificFormatSI(unicode: true));
      expect(buf.toString(), '1.000\u{2009}08 \u{00d7} 10\u{00b3} kg');

      buf.clear();
      q1.outputText(buf, uncertFormat: UncertaintyFormat.parens);
      expect(buf.toString(), '1000.08(2.000 16) kg');

      buf.clear();
      q1.outputText(buf,
          uncertFormat: UncertaintyFormat.parens,
          numberFormat: ScientificFormatSI(unicode: true));
      expect(buf.toString(),
          '1.000\u{2009}08 \u{00d7} 10\u{00b3}(2.000\u{2009}16) kg');

      buf.clear();
      q1.outputText(buf, uncertFormat: UncertaintyFormat.plusMinus);
      expect(buf.toString(), '1000.08 +/- 2.000 16 kg');

      buf.clear();
      q1.outputText(buf,
          uncertFormat: UncertaintyFormat.plusMinus,
          numberFormat: ScientificFormatSI(unicode: true));
      expect(buf.toString(),
          '1.000\u{2009}08 \u{00d7} 10\u{00b3} \u{00b1} 2.000\u{2009}16 kg');
    });
  });
}
