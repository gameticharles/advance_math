import 'dart:math';
import '../src/ext/angle_ext.dart' show angle0, angle360, tau;
import '../src/si/types/angle.dart';
import 'quantity_range.dart';

/// An immutable angle range with a start angle, an end angle and an
/// implicit direction.
class AngleRange extends QuantityRange<Angle> {
  /// Constructs an angle range.
  AngleRange(Angle startAngle, Angle endAngle) : super(startAngle, endAngle);

  /// Constructs an angle range in radians.
  AngleRange.radians(double startAngleRad, double endAngleRad)
      : super(Angle(rad: startAngleRad), Angle(rad: endAngleRad));

  /// Constructs an angle range in degrees.
  AngleRange.degrees(double startAngleDeg, double endAngleDeg)
      : super(Angle(deg: startAngleDeg), Angle(deg: endAngleDeg));

  /// The starting angle in the range.
  Angle get startAngle => q1;

  /// The ending angle in the range.
  Angle get endAngle => q2;

  /// True if the range represents a clockwise direction.
  bool get isClockwise => q2 > q1;

  /// True if the range represents a counterclockwise direction.
  ///
  /// Synonymous with anticlockwise.
  ///
  bool get isCounterclockwise => q1 > q2;

  /// True if the range represents a anticlockwise direction.
  ///
  /// Synonymous with counterclockwise.
  ///
  bool get isAnticlockwise => isCounterclockwise;

  /// A range is considered tiny if its width is less than or equal to
  /// [epsilon], which is 0.001 degree by default.
  bool isTiny({Angle? epsilon}) {
    epsilon ??= Angle(deg: 0.001);
    if (span <= epsilon) return true;
    return false;
  }

  /// The change in value from start to end, which may be negative.
  @override
  Angle get delta => Angle(rad: q2.mks - q1.mks);

  /// The number of full revolutions encompassed by the range.
  ///
  /// Counterclockwise revolutions will be returned as a negative number.
  ///
  int get revolutions => (q2.mks - q1.mks).toDouble() ~/ twoPi;

  /// Returns true if this angle range overlaps [range2]'s angle range
  /// (exclusive of the endpoints).
  ///
  /// The ranges are projected onto the 0-360 degree range.
  ///
  bool overlaps360(AngleRange range2) {
    if (overlaps(range2)) return true;

    // No direct overlap... check if the projections overlap
    final list1 = <AngleRange>[];
    final min360 = minValue.angle360;
    var max360 = maxValue.angle360;
    if (max360 < min360) {
      max360 = max360 + Angle(rad: twoPi) as Angle;
      list1..add(AngleRange(min360, Angle(rad: twoPi)))..add(AngleRange(Angle(rad: 0), max360));
    } else {
      list1.add(AngleRange(min360, max360));
    }

    final list2 = <AngleRange>[];
    final min360two = range2.minValue.angle360;
    var max360two = range2.maxValue.angle360;
    if (max360two < min360two) {
      max360two = max360two + Angle(rad: twoPi) as Angle;
      list2..add(AngleRange(min360two, Angle(rad: twoPi)))..add(AngleRange(Angle(rad: 0), max360two));
    } else {
      list2.add(AngleRange(min360two, max360two));
    }

    for (final range1 in list1) {
      for (final range2 in list2) {
        if (range1.overlaps(range2)) return true;
      }
    }

    return false;
  }

  /// Derive a AngleRange from this one by applying one or more
  /// transforms.
  ///
  /// Rotation:  move the range by [rotate] degrees
  /// Scale: grow or shrink the range about its center by a [scale] factor
  /// Reverse:  flip the direction by exchanging the start and end angles
  ///
  AngleRange deriveRange({double? rotate, double? scale, bool? reverse}) {
    var start = q1;
    var end = q2;
    if (reverse != null && reverse) {
      final temp = q1;
      start = end;
      end = temp;
    }
    if (scale != null) {
      final delta = (end - start) * (scale / 2.0) as Angle;
      start = centerValue - delta as Angle;
      end = centerValue + delta as Angle;
    }
    if (rotate != null) {
      final newCenter = centerValue + rotate as Angle;
      final delta = (end - start) / 2.0 as Angle;
      start = newCenter - delta as Angle;
      end = newCenter + delta as Angle;
    }

    return AngleRange(start, end);
  }

  /// Returns the equivalent range(s) projected onto the 0-360 degree circle.
  ///
  /// Note that there may be either one or two ranges in the returned list,
  /// depending on whether or not the projection of this range crosses
  /// 0 degrees.
  List<AngleRange> get ranges360 {
    if (revolutions.abs() > 0) return <AngleRange>[AngleRange(angle0, angle360)];

    final rangeList = <AngleRange>[];

    if (startAngle < endAngle) {
      // clockwise
      final start360 = startAngle.angle360;
      final delta = start360 - startAngle as Angle;
      final endPlusDelta = endAngle + delta as Angle;
      if (endPlusDelta.valueSI > twoPi) {
        rangeList..add(AngleRange(angle0, endPlusDelta.angle360))..add(AngleRange(start360, angle360));
      } else {
        rangeList.add(AngleRange(start360, endPlusDelta));
      }
    } else {
      // counterclockwise
      final end360 = endAngle.angle360;
      final delta = end360 - endAngle as Angle;
      final startPlusDelta = startAngle + delta as Angle;
      if (startPlusDelta.valueSI > twoPi) {
        rangeList..add(AngleRange(angle360, end360))..add(AngleRange(startPlusDelta - angle360 as Angle, angle0));
      } else {
        rangeList.add(AngleRange(end360, startPlusDelta));
      }
    }

    return rangeList;
  }

  /// True if this range, projected onto the 0-360 degree circle
  /// contains [angle] when it also is projected onto the 0-360 circle.
  ///
  /// The test is [inclusive] of the endpoints by default and has a
  /// rounding tolerance, [epsilon] of 1.0e-10.
  ///
  /// This is a more lenient test than [contains()] in superclass
  /// [QuantityRange].
  ///
  bool contains360(Angle angle, [bool inclusive = true, double epsilon = 1.0e-10]) {
    if (contains(angle, inclusive, epsilon) || revolutions.abs() > 0) return true;
    final ang360 = angle.angle360;
    for (final range in ranges360) {
      if (range.contains(ang360, inclusive, epsilon)) return true;
    }
    return false;
  }

  /// Find the angle within this range closest to the specified [angle].
  ///
  /// If [strict] is true, then only the actual range is used
  /// regardless of whether it falls within the nominal 0-360 degree
  /// range.  If [strict] is false then the closest angle as if the
  /// ranges were projected onto a single circle is returned.
  Angle angleClosestTo(Angle angle, [bool strict = false]) {
    // Contains?
    if (!strict && contains360(angle)) {
      return angle;
    } else if (contains(angle)) {
      return angle;
    }

    // Not contained... return closest endpoint.
    if (!strict) {
      final angRev0 = angle.angle360;
      late Angle closest;
      num minDeltaRad = angle360.mks.toDouble();
      final ranges = ranges360;
      num deltaStartRad;
      num deltaStartRadRev;
      num deltaEndRad;
      num deltaEndRadRev;
      for (final range in ranges) {
        deltaStartRad = (range.startAngle.mks.toDouble() - angRev0.mks.toDouble()).abs();
        deltaStartRadRev = tau + range.startAngle.mks.toDouble() - angRev0.mks.toDouble();
        deltaStartRad = min(deltaStartRad, deltaStartRadRev);
        deltaEndRad = (range.endAngle.mks.toDouble() - angRev0.mks.toDouble()).abs();
        deltaEndRadRev = tau + range.endAngle.mks.toDouble() - angRev0.mks.toDouble();
        deltaEndRad = min(deltaEndRad, deltaEndRadRev);
        if (deltaStartRad < minDeltaRad) {
          closest = range.startAngle;
          minDeltaRad = deltaStartRad;
        }
        if (deltaEndRad < minDeltaRad) {
          closest = range.endAngle;
          minDeltaRad = deltaEndRad;
        }
      }
      return closest;
    } else {
      final num deltaStartRad = (startAngle.mks.toDouble() - angle.mks.toDouble()).abs();
      final num deltaEndRad = (endAngle.mks.toDouble() - angle.mks.toDouble()).abs();
      return (deltaStartRad <= deltaEndRad) ? Angle(rad: deltaStartRad) : Angle(rad: deltaEndRad);
    }
  }
}
