// ignore_for_file: unnecessary_type_check

import '../src/number/util/jenkins_hash.dart';
import '../src/si/quantity.dart';
import '../src/si/quantity_exception.dart';

/// Creates a [QuantityRange] that represents the standard uncertainty of [q].
QuantityRange<Quantity> uncertaintyRangeForQuantity(Quantity q,
    {double k = 1.0}) {
  final std = q.standardUncertainty;
  if (k == 1.0) {
    return QuantityRange<Quantity>(q - std, q + std);
  } else {
    final expanded = q.calcExpandedUncertainty(k);
    return QuantityRange<Quantity>(q - expanded, q + expanded);
  }
}

/// Represents a range of quantity values.
class QuantityRange<Q extends Quantity> {
  /// Constructs a quantity range, from [q1] to [q2].
  QuantityRange(this.q1, this.q2) {
    if (q1 is! Quantity || q2 is! Quantity) {
      throw const QuantityException(
          'QuantityRange endpoints must be Quantity objects');
    }
  }

  /// The starting quantity of the range.
  Q q1;

  /// The ending quantity of the range.
  Q q2;

  // Derived values (calculated on first use)
  Q? _minValue;
  Q? _maxValue;
  Q? _centerValue;
  Q? _span;

  /// The minimum value in this range.
  Q get minValue => _minValue ??= (q1.valueSI <= q2.valueSI) ? q1 : q2;

  /// The maximum value in this range.
  Q get maxValue => _maxValue ??= (q1.valueSI > q2.valueSI) ? q1 : q2;

  /// The value at the center of the range.
  Q get centerValue => _centerValue ??= (q1 + q2) / 2.0 as Q;

  /// The magnitude of the range.
  /// This value is always positive (or zero).  Get [delta] for the signed version of the range.
  Q get span => _span ??= (q2 - q1).abs() as Q;

  /// The change in value from start to end, which may be negative.
  Q get delta => q2 - q1 as Q;

  /// Returns true if this range overlaps [range2]
  /// (exclusive of the endpoints).
  bool overlaps(QuantityRange<Q> range2) {
    if (range2.minValue <= minValue) {
      return range2.maxValue > minValue;
    } else {
      return range2.minValue < maxValue;
    }
  }

  /// True if this range contains [quantity], with a tolerance, [epsilon], of
  /// rounding errors of 1.0e-10 and [inclusive] of the endpoints by default.
  bool contains(Q quantity, [bool inclusive = true, double epsilon = 1.0e-10]) {
    if (inclusive && (quantity == q1 || quantity == q2)) return true;
    if (epsilon == 0.0) {
      if (q1 < quantity && q2 > quantity) return true;
      if (q1 > quantity && q2 < quantity) return true;
    } else {
      if (inclusive) {
        if (q1.mks - epsilon < quantity.mks &&
            q2.mks + epsilon > quantity.mks) {
          return true;
        }
        if (q1.mks + epsilon > quantity.mks &&
            q2.mks - epsilon < quantity.mks) {
          return true;
        }
      } else {
        if (q1.mks - epsilon <= quantity.mks &&
            q2.mks + epsilon >= quantity.mks) return true;
        if (q1.mks + epsilon >= quantity.mks &&
            q2.mks - epsilon <= quantity.mks) return true;
      }
    }
    return false;
  }

  /// True only if this range completely encompasses range2.
  bool encompasses(QuantityRange<Q> range2) =>
      (minValue <= range2.minValue) && (maxValue >= range2.maxValue);

  /// Returns a String representation of this range in the form '<Q1> to <Q2>'.
  @override
  String toString() => '$q1 to $q2';

  /// Two quantity ranges are considered equal only if their endpoints are exactly equal.
  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic obj) {
    if (obj is! QuantityRange) return false;
    return (q1 == obj.q1) && (q2 == obj.q2);
  }

  /// Two equal quantity ranges will have the same hash code.
  @override
  int get hashCode => hashObjects(<Object>[q1, q2]);
}
