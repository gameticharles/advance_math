// ignore_for_file: depend_on_referenced_packages

import 'package:test/test.dart';

import '../complex.dart';


/// Class to test extending Complex
class TestComplex extends Complex {
  TestComplex(num super.real, num super.imaginary);

  factory TestComplex.from(Complex other) {
    return TestComplex(other.real, other.imaginary);
  }

  @override
  String toString({bool asFraction = false, int? fractionDigits}) {
    return '$real ${imaginary}j';
  }
}

/// Returns a matcher which matches if the match argument is within [delta]
/// of some [value]; i.e. if the match argument is greater than
/// than or equal [value]-[delta] and less than or equal to [value]+[delta].
Matcher closeToZ(Complex value, num delta) => _IsCloseToZ(value, delta);

class _IsCloseToZ extends Matcher {
  const _IsCloseToZ(this._value, this._delta);

  final Complex _value;
  final num _delta;

  @override
  bool matches(item, Map matchState) {
    if (item is! Complex) {
      return false;
    }
    var reDiff = item.real - _value.real;
    if (reDiff < 0) reDiff = -reDiff;
    if (reDiff > _delta) {
      return false;
    }
    var imDiff = item.imaginary - _value.imaginary;
    if (imDiff < 0) imDiff = -imDiff;
    if (imDiff > _delta) {
      return false;
    }
    return true;
  }

  @override
  Description describe(Description description) => description
      .add('a complex value within ')
      .addDescriptionOf(_delta)
      .add(' of ')
      .addDescriptionOf(_value);

  @override
  Description describeMismatch(
      item, Description mismatchDescription, Map matchState, bool verbose) {
    if (item is! Complex) {
      return mismatchDescription.add(' not complex');
    } else {
      var diff = item.abs() - _value.abs();
      if (diff < 0) diff = -diff;
      return mismatchDescription.add(' differs by ').addDescriptionOf(diff);
    }
  }
}